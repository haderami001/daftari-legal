import 'dart:io';

import 'package:serveur_peche/serveur_peche.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

/// Lance le serveur. Configuration par variables d'environnement :
///
/// | Variable              | Rôle                                              |
/// |-----------------------|---------------------------------------------------|
/// | `OIDC_EMETTEUR`       | Keycloak : `https://auth.exemple.mr/realms/peche` |
/// |                       | (comptes et rôles ; recommandé)                   |
/// | `OIDC_AUDIENCE`       | `aud` attendu dans les jetons (`peche-api`)       |
/// | `OIDC_JWKS_URL`       | clés publiques, si l'adresse interne diffère de   |
/// |                       | l'émetteur (ex. réseau Docker)                    |
/// | `JETON_API`           | sans Keycloak : secret partagé (développement)    |
/// | `DATABASE_URL`        | `postgres://user:mdp@hote:5432/base` ; absent =   |
/// |                       | stockage en mémoire (démo, perdu à l'arrêt)       |
/// | `PORT`                | port d'écoute (8080 par défaut)                   |
/// | `ORIGINES_AUTORISEES` | origines web autorisées, séparées par des         |
/// |                       | virgules (`*` par défaut)                         |
Future<void> main() async {
  final env = Platform.environment;

  final Authentificateur auth;
  final emetteur = env['OIDC_EMETTEUR'] ?? '';
  final jeton = env['JETON_API'] ?? '';
  if (emetteur.isNotEmpty) {
    final jwks = env['OIDC_JWKS_URL'] ?? '';
    auth = AuthOidc(
      emetteur: emetteur,
      audience: env['OIDC_AUDIENCE'] ?? 'peche-api',
      cles: ClesJwks(Uri.parse(
          jwks.isNotEmpty ? jwks : '$emetteur/protocol/openid-connect/certs')),
    );
    stdout.writeln('Authentification Keycloak : $emetteur');
  } else if (jeton.length >= 16) {
    auth = AuthJetonPartage(jeton);
    stdout.writeln('ATTENTION : authentification par jeton partagé '
        '(développement). Utilisez Keycloak en production (OIDC_EMETTEUR).');
  } else {
    stderr.writeln('Configurez OIDC_EMETTEUR (Keycloak) ou JETON_API '
        '(16 caractères minimum).');
    exit(64);
  }

  final Stockage stockage;
  final url = env['DATABASE_URL'];
  if (url == null || url.isEmpty) {
    stdout.writeln('ATTENTION : DATABASE_URL absent, stockage EN MÉMOIRE '
        '(les saisies seront perdues à l\'arrêt).');
    stockage = StockageMemoire();
  } else {
    stockage = await StockagePostgres.ouvrir(Uri.parse(url));
    stdout.writeln('Base PostgreSQL prête (migrations appliquées).');
  }

  final api = construireApi(
    stockage: stockage,
    authentificateur: auth,
    originesAutorisees: (env['ORIGINES_AUTORISEES'] ?? '*')
        .split(',')
        .map((o) => o.trim())
        .where((o) => o.isNotEmpty)
        .toSet(),
    journal: stdout.writeln,
  );

  final port = int.tryParse(env['PORT'] ?? '') ?? 8080;
  final serveur =
      await shelf_io.serve(api, InternetAddress.anyIPv4, port, shared: true);
  stdout.writeln('Serveur Pêche Conforme sur le port ${serveur.port}');

  // Arrêt propre (Ctrl+C, docker stop) : on ferme la base.
  for (final signal in [ProcessSignal.sigint, ProcessSignal.sigterm]) {
    signal.watch().listen((_) async {
      await serveur.close();
      await stockage.fermer();
      exit(0);
    });
  }
}
