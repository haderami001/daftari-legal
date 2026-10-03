import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'authentification.dart';
import 'stockage.dart';
import 'validation.dart';

const versionApi = '1.0.0';

/// Taille maximale d'une saisie (le PDF du rapport est inclus en base64).
const tailleMaxOctets = 5 * 1024 * 1024;

/// Construit le serveur HTTP complet (routes + protections).
///
/// - [authentificateur] : vérifie `Authorization: Bearer <jeton>` — jetons
///   Keycloak ([AuthOidc]) en production, secret partagé
///   ([AuthJetonPartage]) en développement.
/// - [originesAutorisees] : pour la version web de l'application (CORS).
///
/// Droits par rôle : déclarations → capitaine ; contrôles → agent ;
/// consultation → superviseur ; admin → tout.
Handler construireApi({
  required Stockage stockage,
  required Authentificateur authentificateur,
  Set<String> originesAutorisees = const {'*'},
  void Function(String)? journal,
}) {
  final routes = Router()
    ..get(
        '/v1/sante',
        (Request _) => _json(200, {
              'statut': 'ok',
              'version': versionApi,
            }))
    ..get('/v1/moi', (Request req) {
      final u = utilisateur(req);
      return _json(200, {'id': u.id, 'nom': u.nom, 'roles': u.roles.toList()});
    })
    ..post(
        '/v1/sync/<type>/<id>',
        (Request req, String type, String id) =>
            _recevoir(req, stockage, type, id))
    ..get('/v1/statistiques', (Request req) async {
      if (!utilisateur(req).a(Roles.superviseur)) return _interdit();
      return _json(200, await stockage.compter());
    })
    ..get('/v1/<type>', (Request req, String type) async {
      if (!utilisateur(req).a(Roles.superviseur)) return _interdit();
      final t = TypeSaisie.depuisSegment(type);
      if (t == null) return _erreur(404, 'introuvable', 'Type inconnu : $type');
      final limite =
          (int.tryParse(req.url.queryParameters['limite'] ?? '') ?? 50)
              .clamp(1, 500);
      final lignes = await stockage.lister(t, limite: limite);
      return _json(200, [for (final l in lignes) l.versJson()]);
    })
    ..get('/v1/controles/<id>/rapport.pdf', (Request req, String id) async {
      if (!utilisateur(req).a(Roles.superviseur)) return _interdit();
      final pdf = estUuid(id) ? await stockage.rapportPdf(id) : null;
      if (pdf == null) {
        return _erreur(404, 'introuvable', 'Aucun rapport PDF pour $id');
      }
      return Response.ok(pdf, headers: {
        'Content-Type': 'application/pdf',
        'Content-Disposition': 'inline; filename="rapport_$id.pdf"',
      });
    });

  return const Pipeline()
      .addMiddleware(_journaliser(journal))
      .addMiddleware(_cors(originesAutorisees))
      .addMiddleware(_authentifier(authentificateur, journal))
      .addMiddleware(_attraperErreurs(journal))
      .addHandler(routes.call);
}

Future<Response> _recevoir(
    Request req, Stockage stockage, String segment, String id) async {
  final type = TypeSaisie.depuisSegment(segment);
  if (type == null) {
    return _erreur(404, 'introuvable', 'Type de saisie inconnu : $segment');
  }
  final u = utilisateur(req);
  final roleRequis = switch (type) {
    TypeSaisie.declaration => Roles.capitaine,
    TypeSaisie.controle => Roles.agent,
  };
  if (!u.a(roleRequis)) return _interdit();
  if (!(req.mimeType ?? '').contains('json')) {
    return _erreur(415, 'type_media', 'Content-Type: application/json attendu');
  }
  final taille = req.contentLength;
  if (taille != null && taille > tailleMaxOctets) {
    return _erreur(413, 'trop_volumineux', 'Saisie de plus de 5 Mo');
  }

  final Object? corps;
  try {
    final texte = await req.readAsString();
    if (texte.length > tailleMaxOctets) {
      return _erreur(413, 'trop_volumineux', 'Saisie de plus de 5 Mo');
    }
    corps = jsonDecode(texte);
  } on FormatException {
    return _erreur(400, 'json_invalide', 'Le corps n\'est pas du JSON valide');
  }
  if (corps is! Map<String, Object?>) {
    return _erreur(400, 'json_invalide', 'Un objet JSON est attendu');
  }

  final erreurs = verifierSaisie(type, id, corps);
  if (erreurs.isNotEmpty) {
    return _json(400, {
      'erreur': 'donnees_invalides',
      'message': 'La saisie contient ${erreurs.length} erreur(s).',
      'details': erreurs,
    });
  }

  return switch (await stockage.enregistrer(type, id, corps, par: u)) {
    Enregistrement.cree => _json(201, {'statut': 'cree', 'id': id}),
    Enregistrement.dejaRecu => _json(200, {'statut': 'deja_recu', 'id': id}),
    Enregistrement.conflit => _erreur(409, 'conflit',
        'Une saisie différente existe déjà avec l\'identifiant $id'),
  };
}

Response _json(int code, Object? corps) => Response(code,
    body: jsonEncode(corps),
    headers: {'Content-Type': 'application/json; charset=utf-8'});

Response _erreur(int code, String erreur, String message) =>
    _json(code, {'erreur': erreur, 'message': message});

Middleware _journaliser(void Function(String)? journal) =>
    (interne) => (req) async {
          final debut = DateTime.now();
          final rep = await interne(req);
          journal?.call('${debut.toUtc().toIso8601String()} ${req.method} '
              '/${req.url.path} -> ${rep.statusCode} '
              '(${DateTime.now().difference(debut).inMilliseconds} ms)');
          return rep;
        };

/// Autorise la version web de l'application (autre origine) à appeler l'API.
Middleware _cors(Set<String> origines) => (interne) => (req) async {
      final origine = req.headers['origin'];
      final autorisee = origine != null &&
          (origines.contains('*') || origines.contains(origine));
      final entetes = {
        if (autorisee) ...{
          'Access-Control-Allow-Origin': origines.contains('*') ? '*' : origine,
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers':
              'Authorization, Content-Type, Idempotency-Key',
          'Access-Control-Max-Age': '86400',
          'Vary': 'Origin',
        },
      };
      if (req.method == 'OPTIONS') return Response(204, headers: entetes);
      final rep = await interne(req);
      return rep.change(headers: entetes);
    };

/// L'utilisateur authentifié de la requête (posé par [_authentifier]).
Utilisateur utilisateur(Request req) =>
    req.context['utilisateur']! as Utilisateur;

Response _interdit() =>
    _erreur(403, 'interdit', 'Votre rôle ne permet pas cette action');

/// Toutes les routes sauf /v1/sante exigent un jeton valide.
Middleware _authentifier(
        Authentificateur auth, void Function(String)? journal) =>
    (interne) => (req) async {
          if (req.url.path == 'v1/sante') return interne(req);
          final entete = req.headers['authorization'] ?? '';
          if (!entete.startsWith('Bearer ')) {
            return _erreur(401, 'non_autorise', 'Jeton absent ou invalide');
          }
          final Utilisateur? u;
          try {
            u = await auth.verifier(entete.substring(7).trim());
          } catch (e) {
            // Keycloak injoignable (clés publiques) : ce n'est pas la faute
            // du client, il réessaiera.
            journal?.call('Authentification indisponible : $e');
            return _erreur(503, 'authentification_indisponible',
                'Vérification du jeton impossible pour le moment');
          }
          if (u == null) {
            return _erreur(401, 'non_autorise', 'Jeton absent ou invalide');
          }
          return interne(req.change(context: {'utilisateur': u}));
        };

Middleware _attraperErreurs(void Function(String)? journal) =>
    (interne) => (req) async {
          try {
            return await interne(req);
          } catch (e, pile) {
            journal?.call('ERREUR ${req.method} /${req.url.path} : $e\n$pile');
            return _erreur(500, 'erreur_interne',
                'Erreur du serveur, la saisie n\'a pas été enregistrée');
          }
        };
