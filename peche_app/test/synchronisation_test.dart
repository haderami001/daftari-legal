import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:peche_app/core/data/base/base_de_donnees.dart';
import 'package:peche_app/core/data/base/tables.dart';
import 'package:peche_app/core/models/declaration.dart';
import 'package:peche_app/core/models/enums.dart';
import 'package:peche_app/core/regulation/calcul_reglementaire.dart';
import 'package:peche_app/core/regulation/referentiel.dart';
import 'package:peche_app/core/services/services.dart';
import 'package:peche_app/core/services/synchronisation.dart';

import 'faux_serveur.dart';

void main() {
  const calcul = CalculReglementaire(referentielDemo);
  late BaseDeDonnees base;

  setUp(() => base = BaseDeDonnees.avec(NativeDatabase.memory()));
  tearDown(() => base.close());

  /// Enregistre une déclaration et un contrôle (avec PDF) dans la file.
  Future<(String, String)> remplirFile(Services s) async {
    final flotte = await s.flotte.naviresAvecLicence();
    final pirogue = flotte.firstWhere((f) => f.navire.id == 'N1');
    final d = DeclarationCapitaine(
      navire: pirogue.navire,
      licence: pirogue.licence,
      engin: TypeEngin.casier,
      position: PositionGps(20.85, -17.45, DateTime.utc(2026, 10, 3, 8)),
      captures: [const Capture(especeCode: 'OCC', poidsKg: 80)],
    );
    final idDecl = await s.saisies
        .enregistrerDeclaration(d, calcul.verifierDeclaration(d));

    final chalutier = flotte.first;
    final c = Controle(
      navire: chalutier.navire,
      agent: 'Agent test',
      date: DateTime.utc(2026, 10, 3, 9),
      position: PositionGps(20.6, -17.3, DateTime.utc(2026, 10, 3, 9)),
      engin: TypeEngin.chalutDemersal,
      maillagesMm: [72],
    );
    final idCtrl = await s.saisies.enregistrerControle(
      c,
      calcul.verifierControle(c, licence: chalutier.licence),
      'RAPPORT',
      rapportPdf: utf8.encode('%PDF-test'),
    );
    return (idDecl, idCtrl);
  }

  test('sans serveur configuré, rien ne bouge', () async {
    final s = Services(base);
    await remplirFile(s);

    final r = await s.synchro.synchroniser();

    expect(r.statut, StatutSynchro.nonConfigure);
    expect(await s.envois.nombreEnAttente(), 2);
    expect((await s.envois.enAttente()).first.tentatives, 0);
  });

  test('envoi réussi : la file est vidée et les données sont complètes',
      () async {
    final serveur = FauxServeur();
    final s = Services(base, api: serveur);
    final (idDecl, idCtrl) = await remplirFile(s);

    final r = await s.synchro.synchroniser();

    expect(r.envoyes, 2);
    expect(r.echecs, 0);
    expect(await s.envois.nombreEnAttente(), 0);

    final (typeD, idD, decl) = serveur.recus[0];
    expect((typeD, idD), (TypeEnvoi.declaration, idDecl));
    expect(decl['captures'], [
      {'espece': 'OCC', 'poids_kg': 80.0},
    ]);
    expect(decl['horodatage'], '2026-10-03T08:00:00.000Z');

    final (typeC, idC, ctrl) = serveur.recus[1];
    expect((typeC, idC), (TypeEnvoi.controle, idCtrl));
    expect(ctrl['maillages_mm'], [72.0]);
    expect(utf8.decode(base64Decode(ctrl['rapport_pdf_base64']! as String)),
        '%PDF-test');
  });

  test('panne : la saisie reste en file avec l\'erreur, puis repart', () async {
    final serveur = FauxServeur()..enPanne = true;
    final s = Services(base, api: serveur);
    await remplirFile(s);

    final r1 = await s.synchro.synchroniser();
    expect((r1.envoyes, r1.echecs), (0, 2));
    final enAttente = await s.envois.enAttente();
    expect(enAttente.map((e) => e.tentatives), [1, 1]);
    expect(enAttente.first.derniereErreur, 'Serveur : HTTP 503');

    serveur.enPanne = false;
    final r2 = await s.synchro.synchroniser();
    expect((r2.envoyes, r2.echecs), (2, 0));
    expect(await s.envois.nombreEnAttente(), 0);
  });

  test('référentiel : téléchargé, installé, puis plus retéléchargé', () async {
    final serveur = FauxServeur()
      ..referentiel = {
        'version': 7,
        'navires': [
          {
            'id': 'N1', // navire existant, modifié
            'nom': 'Imraguen 12 (renommé)',
            'immatriculation': 'NDB-PA-1234',
            'pavillon': 'MRT',
            'type': 'pirogue',
            'longueur_m': 14.5,
            'puissance_kw': 30,
            'numero_imo': null,
            'certificats': [
              {
                'type': 'navigabilite',
                'numero': 'NAV-2026-500',
                'date_expiration': '2028-01-31',
              },
            ],
          },
          {
            'id': 'N4', // nouveau navire
            'nom': 'Tanit',
            'immatriculation': 'NKT-SE-0001',
            'pavillon': 'MRT',
            'type': 'senneur',
            'longueur_m': 30,
            'puissance_kw': 500,
            'numero_imo': null,
            'certificats': <Object>[],
          },
        ],
        'licences': [
          {
            'numero': 'LIC-COT-2026-0400',
            'navire_id': 'N4',
            'segment': 'cotiere',
            'engins_autorises': ['senneTournante'],
            'especes_cibles': ['SAA', 'SAE'],
            'date_debut': '2026-01-01',
            'date_fin': '2026-12-31',
            'quotas_kg': {'SAA': 80000},
          },
        ],
      };
    final s = Services(base, api: serveur);

    final r1 = await s.synchro.synchroniser();
    expect(r1.referentielVersion, 7);
    expect(r1.erreurReferentiel, isNull);

    final flotte = {
      for (final f in await s.flotte.naviresAvecLicence()) f.navire.id: f
    };
    expect(flotte.keys, containsAll(['N1', 'N2', 'N3', 'N4']));
    expect(flotte['N1']!.navire.nom, 'Imraguen 12 (renommé)');
    expect(flotte['N1']!.navire.certificats.single.numero, 'NAV-2026-500');
    expect(flotte['N4']!.licence.quotasKg, {'SAA': 80000});
    expect(flotte['N4']!.licence.especesCibles, {'SAA', 'SAE'});

    // Deuxième synchronisation : le téléphone annonce sa version (7).
    final r2 = await s.synchro.synchroniser();
    expect(r2.referentielVersion, isNull);
    expect(serveur.versionsDemandees, [null, 7]);
  });

  test('référentiel : un navire supprimé sur le serveur est masqué', () async {
    final serveur = FauxServeur()
      ..referentiel = {
        'version': 9,
        'navires': [
          {
            'id': 'N3',
            'nom': 'Banc d\'Arguin',
            'immatriculation': 'NDB-SE-0789',
            'pavillon': 'MRT',
            'type': 'senneur',
            'longueur_m': 28,
            'puissance_kw': 450,
            'supprime': true,
          },
        ],
        'licences': [
          {
            'numero': 'LIC-COT-2026-0340',
            'navire_id': 'N3',
            'segment': 'cotiere',
            'engins_autorises': ['senneTournante'],
            'especes_cibles': ['SAA'],
            'date_debut': '2026-01-01',
            'date_fin': '2026-12-31',
            'supprime': true,
          },
        ],
      };
    final s = Services(base, api: serveur);
    await s.synchro.synchroniser();

    final ids = [
      for (final f in await s.flotte.naviresAvecLicence()) f.navire.id
    ];
    expect(ids, isNot(contains('N3')));
    expect(ids, containsAll(['N1', 'N2']));
    // Toujours en base (les saisies passées y font référence).
    final n3 = await (base.select(base.navires)
          ..where((n) => n.id.equals('N3')))
        .getSingle();
    expect(n3.supprime, isTrue);
  });

  test('référentiel invalide : rien n\'est modifié', () async {
    final serveur = FauxServeur()
      ..referentiel = {
        'version': 8,
        'navires': [
          {
            'id': 'N1',
            'nom': 'Modifié',
            'immatriculation': 'NDB-PA-1234',
            'pavillon': 'MRT',
            'type': 'sousmarin', // inconnu de cette version de l'app
            'longueur_m': 14,
            'puissance_kw': 30,
          },
        ],
        'licences': <Object>[],
      };
    final s = Services(base, api: serveur);
    final r = await s.synchro.synchroniser();
    expect(r.erreurReferentiel, isNotNull);
    final n1 = (await s.flotte.naviresAvecLicence())
        .firstWhere((f) => f.navire.id == 'N1');
    expect(n1.navire.nom, 'Imraguen 12');
    expect(await s.reglages.lire('referentiel_version'), isNull);
  });

  group('ApiHttp', () {
    test('POST idempotent vers /v1/sync/... avec le JSON', () async {
      late http.Request requete;
      final api = ApiHttp(
        Uri.parse('https://api.exemple.mr/peche'), // sans « / » final
        jeton: () async => 'abc',
        client: MockClient((r) async {
          requete = r;
          return http.Response('', 201);
        }),
      );

      await api.envoyer(TypeEnvoi.controle, 'id-42', {'agent': 'A'});

      expect(requete.method, 'POST');
      expect(requete.url.toString(),
          'https://api.exemple.mr/peche/v1/sync/controles/id-42');
      expect(requete.headers['Idempotency-Key'], 'id-42');
      expect(requete.headers['Authorization'], 'Bearer abc');
      expect(jsonDecode(requete.body), {'agent': 'A'});
    });

    test('référentiel : If-None-Match, 304 = rien à faire', () async {
      final entetes = <Map<String, String>>[];
      final api = ApiHttp(
        Uri.parse('https://api.exemple.mr'),
        jeton: () async => 'abc',
        client: MockClient((r) async {
          entetes.add(r.headers);
          expect(r.url.path, '/v1/referentiel');
          return r.headers['If-None-Match'] == '"3"'
              ? http.Response('', 304)
              : http.Response('{"version":3,"navires":[],"licences":[]}', 200);
        }),
      );
      expect((await api.telechargerReferentiel())!['version'], 3);
      expect(await api.telechargerReferentiel(versionConnue: 3), isNull);
      expect(entetes.first['Authorization'], 'Bearer abc');
    });

    test('une réponse d\'erreur du serveur lève ErreurSynchro', () async {
      final api = ApiHttp(
        Uri.parse('https://api.exemple.mr/'),
        client: MockClient((_) async => http.Response('oups', 500)),
      );
      await expectLater(
        api.envoyer(TypeEnvoi.declaration, 'x', {}),
        throwsA(isA<ErreurSynchro>()
            .having((e) => e.message, 'message', 'Serveur : HTTP 500')),
      );
    });
  });
}
