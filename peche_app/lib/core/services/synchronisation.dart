import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/base/tables.dart';
import '../data/depots/file_envoi_depot.dart';
import '../data/depots/saisie_depot.dart';

/// Erreur d'envoi au serveur (réseau coupé, serveur en erreur...).
class ErreurSynchro implements Exception {
  const ErreurSynchro(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Ce que le serveur central doit savoir recevoir.
abstract class ApiSynchro {
  /// Envoie une saisie. Doit être **idempotent** côté serveur : recevoir
  /// deux fois le même [id] ne crée pas de doublon.
  Future<void> envoyer(TypeEnvoi type, String id, Map<String, Object?> donnees);
}

/// Client HTTP réel : `POST {base}/v1/sync/{declarations|controles}/{id}`.
///
/// L'adresse est fournie au lancement :
///     flutter run --dart-define=API_URL=https://api.exemple.mr
class ApiHttp implements ApiSynchro {
  ApiHttp(Uri base, {http.Client? client, this.jeton})
      // « https://x.mr/api » -> « https://x.mr/api/ » pour que resolve()
      // ajoute le chemin au lieu de remplacer le dernier segment.
      : base = base.path.endsWith('/')
            ? base
            : base.replace(path: '${base.path}/'),
        _client = client ?? http.Client();

  final Uri base;
  final http.Client _client;

  /// Jeton d'authentification (OpenID Connect) — à brancher sur Keycloak.
  final String? jeton;

  @override
  Future<void> envoyer(
      TypeEnvoi type, String id, Map<String, Object?> donnees) async {
    final segment = switch (type) {
      TypeEnvoi.declaration => 'declarations',
      TypeEnvoi.controle => 'controles',
    };
    final url = base.resolve('v1/sync/$segment/$id');
    final http.Response reponse;
    try {
      reponse = await _client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Idempotency-Key': id,
              if (jeton != null) 'Authorization': 'Bearer $jeton',
            },
            body: jsonEncode(donnees),
          )
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      throw ErreurSynchro('Réseau indisponible ($e)');
    }
    if (reponse.statusCode < 200 || reponse.statusCode >= 300) {
      throw ErreurSynchro('Serveur : HTTP ${reponse.statusCode}');
    }
  }
}

class ResultatSynchro {
  const ResultatSynchro({
    this.envoyes = 0,
    this.echecs = 0,
    this.message,
  });

  final int envoyes;
  final int echecs;

  /// Explication si rien n'a pu être tenté (ex. serveur non configuré).
  final String? message;

  @override
  String toString() => message ?? '$envoyes envoyé(s), $echecs échec(s)';
}

/// Vide la file d'envoi vers le serveur.
///
/// Chaque saisie est envoyée séparément : un échec n'empêche pas les
/// suivantes, et la saisie en échec reste dans la file (avec le nombre de
/// tentatives et la dernière erreur) pour le prochain essai.
class Synchroniseur {
  Synchroniseur({
    required this.saisies,
    required this.file,
    required this.api,
  });

  final SaisieDepot saisies;
  final FileEnvoiDepot file;

  /// `null` tant qu'aucun serveur n'est configuré.
  final ApiSynchro? api;

  bool get estConfigure => api != null;

  bool _enCours = false;

  Future<ResultatSynchro> synchroniser() async {
    final api = this.api;
    if (api == null) {
      return const ResultatSynchro(
          message: 'Serveur non configuré : les saisies restent sur le '
              'téléphone (paramètre API_URL).');
    }
    // Évite deux envois simultanés de la même file.
    if (_enCours) {
      return const ResultatSynchro(message: 'Envoi déjà en cours.');
    }
    _enCours = true;
    var envoyes = 0;
    var echecs = 0;
    try {
      for (final e in await file.enAttente()) {
        try {
          final donnees = switch (e.type) {
            TypeEnvoi.declaration =>
              await saisies.exporterDeclaration(e.entiteId),
            TypeEnvoi.controle => await saisies.exporterControle(e.entiteId),
          };
          await api.envoyer(e.type, e.entiteId, donnees);
          await file.marquerEnvoye(e.id);
          envoyes++;
        } catch (erreur) {
          await file.marquerEchec(e.id, '$erreur');
          echecs++;
        }
      }
    } finally {
      _enCours = false;
    }
    return ResultatSynchro(envoyes: envoyes, echecs: echecs);
  }
}
