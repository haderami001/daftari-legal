@Tags(['postgres'])
library;

import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:serveur_peche/serveur_peche.dart';
import 'package:test/test.dart';

import 'exemples.dart';

/// Tests sur une vraie base PostgreSQL. Ils ne tournent que si
/// `DATABASE_URL_TEST` est défini (la CI GitHub fournit une base) :
///     DATABASE_URL_TEST=postgres://postgres:postgres@localhost:5432/peche_test dart test
void main() {
  final url = Platform.environment['DATABASE_URL_TEST'];
  if (url == null || url.isEmpty) {
    test('PostgreSQL', () {}, skip: 'DATABASE_URL_TEST non défini');
    return;
  }

  late StockagePostgres stockage;

  setUp(() async {
    // Base vide à chaque test.
    final c = await Connection.open(_endpoint(Uri.parse(url)),
        settings: const ConnectionSettings(sslMode: SslMode.disable));
    await c.execute('DROP TABLE IF EXISTS declarations, controles, '
        'schema_version CASCADE');
    await c.close();
    stockage = await StockagePostgres.ouvrir(Uri.parse(url));
  });
  tearDown(() => stockage.fermer());

  test('les migrations sont appliquées une seule fois', () async {
    await stockage.fermer();
    // Deuxième démarrage : rien à refaire, pas d'erreur.
    stockage = await StockagePostgres.ouvrir(Uri.parse(url));
    expect(await stockage.compter(), {'declarations': 0, 'controles': 0});
  });

  test('déclaration : créée, renvoi reconnu, conflit détecté', () async {
    expect(
        await stockage.enregistrer(
            TypeSaisie.declaration, idDeclaration, declaration()),
        Enregistrement.cree);
    expect(
        await stockage.enregistrer(
            TypeSaisie.declaration, idDeclaration, declaration()),
        Enregistrement.dejaRecu);
    expect(
        await stockage.enregistrer(TypeSaisie.declaration, idDeclaration,
            declaration()..['engin'] = 'ligne'),
        Enregistrement.conflit);

    final liste = await stockage.lister(TypeSaisie.declaration);
    expect(liste.single.id, idDeclaration);
    expect(liste.single.navireId, 'N1');
    expect(liste.single.date, DateTime.utc(2026, 10, 3, 8));
  });

  test('contrôle : colonnes et PDF enregistrés', () async {
    expect(
        await stockage.enregistrer(TypeSaisie.controle, idControle, controle()),
        Enregistrement.cree);
    expect(await stockage.rapportPdf(idControle), pdfMinimal);
    expect(await stockage.compter(), {'declarations': 0, 'controles': 1});

    final c = await Connection.open(_endpoint(Uri.parse(url)),
        settings: const ConnectionSettings(sslMode: SslMode.disable));
    final r = await c
        .execute("SELECT amende_max_mru::text, maillages_mm, marquage_conforme "
            "FROM controles WHERE id = '$idControle'");
    await c.close();
    expect(r.first[0], '1200000.00');
    expect(r.first[1], [62.0, 64.0]);
    expect(r.first[2], false);
  });

  test('poids total de la déclaration calculé', () async {
    await stockage.enregistrer(
        TypeSaisie.declaration, idDeclaration, declaration());
    final c = await Connection.open(_endpoint(Uri.parse(url)),
        settings: const ConnectionSettings(sslMode: SslMode.disable));
    final r = await c.execute('SELECT poids_total_kg::text FROM declarations');
    await c.close();
    expect(r.first.first, '124.50');
  });
}

Endpoint _endpoint(Uri u) => Endpoint(
      host: u.host,
      port: u.hasPort ? u.port : 5432,
      database: u.pathSegments.first,
      username: u.userInfo.split(':').first,
      password: u.userInfo.split(':').skip(1).join(':'),
    );
