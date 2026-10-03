import 'dart:convert';
import 'dart:io';

import 'package:serveur_peche/serveur_peche.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

/// Authentifie « jeton-<role> » avec ce rôle (tests seulement).
class _AuthRoles implements Authentificateur {
  @override
  Future<Utilisateur?> verifier(String jeton) async =>
      jeton.startsWith('jeton-')
          ? Utilisateur(id: jeton, nom: jeton, roles: {jeton.substring(6)})
          : null;
}

Map<String, Object?> navire({String immat = 'NDB-PA-9999'}) => {
      'nom': 'Nouvelle pirogue',
      'immatriculation': immat,
      'pavillon': 'MRT',
      'type': 'pirogue',
      'longueur_m': 12,
      'puissance_kw': 25,
      'certificats': [
        {
          'type': 'navigabilite',
          'numero': 'NAV-9',
          'date_expiration': '2027-05-31T00:00:00Z',
        },
      ],
    };

Map<String, Object?> licence({String navireId = 'N9'}) => {
      'navire_id': navireId,
      'segment': 'artisanale',
      'engins_autorises': ['ligne'],
      'especes_cibles': ['OCC'],
      'date_debut': '2026-01-01',
      'date_fin': '2026-12-31',
      'quotas_kg': {'OCC': 1500},
    };

void main() {
  late StockageMemoire stockage;
  late Handler api;

  setUp(() {
    stockage = StockageMemoire();
    api = construireApi(stockage: stockage, authentificateur: _AuthRoles());
  });

  Future<Response> appeler(String methode, String chemin,
          {String role = 'admin',
          Object? corps,
          Map<String, String> entetes = const {}}) async =>
      await api(Request(methode, Uri.parse('http://localhost$chemin'),
          body: corps == null ? null : jsonEncode(corps),
          headers: {
            'authorization': 'Bearer jeton-$role',
            if (corps != null) 'content-type': 'application/json',
            ...entetes,
          }));

  Future<Object?> lire(Response r) async => jsonDecode(await r.readAsString());

  test('admin : création puis modification d\'un navire et d\'une licence',
      () async {
    expect((await appeler('PUT', '/v1/navires/N9', corps: navire())).statusCode,
        201);
    expect((await appeler('PUT', '/v1/navires/N9', corps: navire())).statusCode,
        200);
    expect(
        (await appeler('PUT', '/v1/licences/LIC-9', corps: licence()))
            .statusCode,
        201);

    final r = await appeler('GET', '/v1/referentiel', role: 'capitaine');
    expect(r.statusCode, 200);
    final ref = await lire(r) as Map;
    expect(r.headers['etag'], '"${ref['version']}"');
    expect(ref['navires'], [
      {
        'id': 'N9',
        'nom': 'Nouvelle pirogue',
        'immatriculation': 'NDB-PA-9999',
        'pavillon': 'MRT',
        'type': 'pirogue',
        'longueur_m': 12.0,
        'puissance_kw': 25.0,
        'numero_imo': null,
        'certificats': [
          {
            'type': 'navigabilite',
            'numero': 'NAV-9',
            'date_expiration': '2027-05-31',
          },
        ],
      },
    ]);
    expect((ref['licences'] as List).single,
        containsPair('quotas_kg', {'OCC': 1500.0}));
  });

  test('téléphone à jour : 304 sans données', () async {
    await appeler('PUT', '/v1/navires/N9', corps: navire());
    final etag = (await appeler('GET', '/v1/referentiel')).headers['etag']!;
    final r = await appeler('GET', '/v1/referentiel',
        role: 'agent', entetes: {'if-none-match': etag});
    expect(r.statusCode, 304);

    await appeler('PUT', '/v1/navires/N9', corps: navire()..['nom'] = 'X');
    final r2 = await appeler('GET', '/v1/referentiel',
        role: 'agent', entetes: {'if-none-match': etag});
    expect(r2.statusCode, 200);
  });

  test('seul l\'admin modifie ; lecture pour tout compte connecté', () async {
    for (final role in ['capitaine', 'agent', 'superviseur']) {
      expect(
          (await appeler('PUT', '/v1/navires/N9', role: role, corps: navire()))
              .statusCode,
          403);
    }
    final sansJeton =
        await api(Request('GET', Uri.parse('http://localhost/v1/referentiel')));
    expect(sansJeton.statusCode, 401);
  });

  test('erreurs : données invalides, navire inconnu, immatriculation prise',
      () async {
    final invalide = await appeler('PUT', '/v1/navires/N9',
        corps: navire()
          ..['type'] = 'sousmarin'
          ..['pavillon'] = 'mr'
          ..['longueur_m'] = -1);
    expect(invalide.statusCode, 400);
    expect((await lire(invalide) as Map)['details'], hasLength(3));

    expect(
        (await appeler('PUT', '/v1/licences/LIC-9', corps: licence()))
            .statusCode,
        422);

    await appeler('PUT', '/v1/navires/N9', corps: navire());
    expect(
        (await appeler('PUT', '/v1/navires/N10', corps: navire())).statusCode,
        409);
    expect(
        (await appeler('PUT', '/v1/licences/LIC-9',
                corps: licence()..['date_fin'] = '2025-01-01'))
            .statusCode,
        400);
    expect(
        (await appeler('PUT', '/v1/navires/a%20b', corps: navire())).statusCode,
        400);
  });

  test('suppression : licence puis navire, marqués supprimés, rétablis',
      () async {
    await appeler('PUT', '/v1/navires/N9', corps: navire());
    await appeler('PUT', '/v1/licences/LIC-9', corps: licence());

    // Réservé à l'admin.
    expect(
        (await appeler('DELETE', '/v1/licences/LIC-9', role: 'agent'))
            .statusCode,
        403);
    // Le navire a encore une licence.
    final refus = await appeler('DELETE', '/v1/navires/N9');
    expect(refus.statusCode, 409);
    expect((await lire(refus) as Map)['erreur'], 'licences_actives');

    final v1 = await stockage.versionReferentiel();
    expect((await appeler('DELETE', '/v1/licences/LIC-9')).statusCode, 200);
    expect((await appeler('DELETE', '/v1/licences/LIC-9')).statusCode, 404);
    expect((await appeler('DELETE', '/v1/navires/N9')).statusCode, 200);
    expect((await appeler('DELETE', '/v1/navires/INCONNU')).statusCode, 404);
    expect(await stockage.versionReferentiel(), greaterThan(v1));

    // Toujours dans le référentiel, marqués : les téléphones les retirent.
    final ref = await stockage.referentiel();
    expect((ref['navires']! as List).single, containsPair('supprime', true));
    expect((ref['licences']! as List).single, containsPair('supprime', true));

    // Pas de licence sur un navire supprimé.
    expect(
        (await appeler('PUT', '/v1/licences/LIC-10', corps: licence()))
            .statusCode,
        422);
    // Un nouvel enregistrement rétablit le navire.
    expect((await appeler('PUT', '/v1/navires/N9', corps: navire())).statusCode,
        200);
    expect(((await stockage.referentiel())['navires']! as List).single,
        isNot(contains('supprime')));
  });

  test('le référentiel de démonstration est valide et s\'importe', () async {
    await importerReferentiel(
        stockage,
        jsonDecode(File('donnees/referentiel_demo.json').readAsStringSync())
            as Map<String, Object?>);
    final ref = await stockage.referentiel();
    expect([for (final n in ref['navires']! as List) (n as Map)['id']],
        ['N1', 'N2', 'N3']);
    expect(ref['licences'], hasLength(3));
  });

  test('import refusé en entier si une ligne est invalide', () async {
    await expectLater(
        importerReferentiel(stockage, {
          'navires': [
            {...navire(), 'id': 'N9'},
            {...navire(), 'id': 'N10', 'type': '?'},
          ],
        }),
        throwsFormatException);
    expect(await stockage.versionReferentiel(), 0);
  });
}
