import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'stockage.dart';
import 'validation.dart';

const versionApi = '1.0.0';

/// Taille maximale d'une saisie (le PDF du rapport est inclus en base64).
const tailleMaxOctets = 5 * 1024 * 1024;

/// Construit le serveur HTTP complet (routes + protections).
///
/// - [jeton] : secret partagé attendu dans `Authorization: Bearer <jeton>`
///   (à remplacer par Keycloak / OpenID Connect en production).
/// - [originesAutorisees] : pour la version web de l'application (CORS).
Handler construireApi({
  required Stockage stockage,
  required String jeton,
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
    ..post(
        '/v1/sync/<type>/<id>',
        (Request req, String type, String id) =>
            _recevoir(req, stockage, type, id))
    ..get('/v1/statistiques',
        (Request _) async => _json(200, await stockage.compter()))
    ..get('/v1/<type>', (Request req, String type) async {
      final t = TypeSaisie.depuisSegment(type);
      if (t == null) return _erreur(404, 'introuvable', 'Type inconnu : $type');
      final limite =
          (int.tryParse(req.url.queryParameters['limite'] ?? '') ?? 50)
              .clamp(1, 500);
      final lignes = await stockage.lister(t, limite: limite);
      return _json(200, [for (final l in lignes) l.versJson()]);
    })
    ..get('/v1/controles/<id>/rapport.pdf', (Request _, String id) async {
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
      .addMiddleware(_authentifier(jeton))
      .addMiddleware(_attraperErreurs(journal))
      .addHandler(routes.call);
}

Future<Response> _recevoir(
    Request req, Stockage stockage, String segment, String id) async {
  final type = TypeSaisie.depuisSegment(segment);
  if (type == null) {
    return _erreur(404, 'introuvable', 'Type de saisie inconnu : $segment');
  }
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

  return switch (await stockage.enregistrer(type, id, corps)) {
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

/// Toutes les routes sauf /v1/sante exigent le jeton.
Middleware _authentifier(String jeton) => (interne) => (req) {
      if (req.url.path == 'v1/sante') return interne(req);
      final entete = req.headers['authorization'] ?? '';
      if (!_egaliteConstante(entete, 'Bearer $jeton')) {
        return _erreur(401, 'non_autorise', 'Jeton absent ou invalide');
      }
      return interne(req);
    };

/// Comparaison en temps constant (ne révèle pas le jeton par la durée).
bool _egaliteConstante(String a, String b) {
  final x = utf8.encode(a), y = utf8.encode(b);
  var diff = x.length ^ y.length;
  for (var i = 0; i < x.length && i < y.length; i++) {
    diff |= x[i] ^ y[i];
  }
  return diff == 0;
}

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
