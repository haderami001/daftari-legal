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

  group('ApiHttp', () {
    test('POST idempotent vers /v1/sync/... avec le JSON', () async {
      late http.Request requete;
      final api = ApiHttp(
        Uri.parse('https://api.exemple.mr/peche'), // sans « / » final
        jeton: 'abc',
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
