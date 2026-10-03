import 'dart:io';

import 'package:serveur_peche/serveur_peche.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

/// Lance le serveur. Configuration par variables d'environnement :
///
/// | Variable              | Rôle                                              |
/// |-----------------------|---------------------------------------------------|
/// | `JETON_API`           | secret partagé avec l'application (obligatoire)   |
/// | `DATABASE_URL`        | `postgres://user:mdp@hote:5432/base` ; absent =   |
/// |                       | stockage en mémoire (démo, perdu à l'arrêt)       |
/// | `PORT`                | port d'écoute (8080 par défaut)                   |
/// | `ORIGINES_AUTORISEES` | origines web autorisées, séparées par des         |
/// |                       | virgules (`*` par défaut)                         |
Future<void> main() async {
  final env = Platform.environment;

  final jeton = env['JETON_API'] ?? '';
  if (jeton.length < 16) {
    stderr.writeln('JETON_API manquant ou trop court (16 caractères minimum).');
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
    jeton: jeton,
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
