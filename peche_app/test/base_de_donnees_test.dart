import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peche_app/core/data/base/base_de_donnees.dart';
import 'package:peche_app/core/data/base/tables.dart';
import 'package:peche_app/core/services/services.dart';
import 'package:peche_app/core/models/declaration.dart';
import 'package:peche_app/core/models/enums.dart';
import 'package:peche_app/core/regulation/calcul_reglementaire.dart';
import 'package:peche_app/core/regulation/referentiel.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  late BaseDeDonnees base;
  late Services depots;
  const calcul = CalculReglementaire(referentielDemo);

  setUp(() {
    // Base SQLite en mémoire : recréée vide (puis remplie) à chaque test.
    base = BaseDeDonnees.avec(NativeDatabase.memory());
    depots = Services(base);
  });
  tearDown(() => base.close());

  test('la base est remplie avec la flotte de démo à la création', () async {
    final flotte = await depots.flotte.naviresAvecLicence();
    expect(flotte.map((f) => f.navire.nom),
        ['Atlantic Star', 'Banc d\'Arguin', 'Imraguen 12']);

    final chalutier = flotte.first;
    expect(chalutier.navire.certificats, hasLength(3));
    expect(chalutier.licence.enginsAutorises, {TypeEngin.chalutDemersal});
    expect(chalutier.licence.especesCibles, {'SOL', 'CTC'});
    expect(chalutier.licence.quotasKg, {'SOL': 20000, 'CTC': 15000});
  });

  test('une déclaration est enregistrée avec ses lignes et mise en file',
      () async {
    final (:navire, :licence) = (await depots.flotte.naviresAvecLicence())
        .firstWhere((f) => f.navire.id == 'N1');
    final d = DeclarationCapitaine(
      navire: navire,
      licence: licence,
      engin: TypeEngin.casier,
      position: PositionGps(20.85, -17.45, DateTime(2026, 10, 3, 8)),
      equipage: [
        const MembreEquipage(
            nom: 'Ahmed', fonction: 'Patron', nationalite: 'MRT'),
      ],
      captures: [
        const Capture(especeCode: 'OCC', poidsKg: 120),
        const Capture(especeCode: 'CTC', poidsKg: 30),
      ],
    );

    final id = await depots.saisies
        .enregistrerDeclaration(d, calcul.verifierDeclaration(d));

    final relues = await depots.saisies.captures(id);
    expect(relues.map((c) => (c.especeCode, c.poidsKg)),
        [('OCC', 120.0), ('CTC', 30.0)]);
    expect(await base.select(base.equipages).get(), hasLength(1));

    final ligne = await (base.select(base.declarations)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    // 30 kg de seiche sur 150 kg = 20 % > 5 % autorisés pour le casier.
    expect(ligne.nbInfractions, 1);

    final file = await depots.envois.enAttente();
    expect(file.single.type, TypeEnvoi.declaration);
    expect(file.single.entiteId, id);
    expect(file.single.resume, contains('150 kg'));
  });

  test('un contrôle signé garde ses mesures, son rapport et ses amendes',
      () async {
    final (:navire, :licence) =
        (await depots.flotte.naviresAvecLicence()).first;
    final c = Controle(
      navire: navire,
      agent: 'Agent test',
      date: DateTime(2026, 10, 3, 9),
      position: PositionGps(20.6, -17.3, DateTime(2026, 10, 3, 9)),
      engin: TypeEngin.chalutDemersal,
      maillagesMm: [60, 61],
      echantillons: [const Echantillon(especeCode: 'SOL', valeur: 20)],
    );
    final r = calcul.verifierControle(c, licence: licence);

    final id = await depots.saisies.enregistrerControle(c, r, 'RAPPORT X');

    final ligne = await base.select(base.controles).getSingle();
    expect(ligne.id, id);
    expect(ligne.rapport, 'RAPPORT X');
    expect(ligne.nbInfractions, r.infractions.length);
    expect(ligne.amendeMax, r.amendeMax);
    expect(await base.select(base.controleMaillages).get(), hasLength(2));
    expect(await base.select(base.controleEchantillons).get(), hasLength(1));
    expect(await depots.envois.nombreEnAttente(), 1);
  });

  test('file d\'envoi : échec puis succès', () async {
    final (:navire, :licence) =
        (await depots.flotte.naviresAvecLicence()).first;
    final d = DeclarationCapitaine(
      navire: navire,
      licence: licence,
      engin: TypeEngin.chalutDemersal,
      position: PositionGps(20, -17, DateTime(2026, 10, 3)),
    );
    await depots.saisies
        .enregistrerDeclaration(d, calcul.verifierDeclaration(d));
    final envoi = (await depots.envois.enAttente()).single;

    await depots.envois.marquerEchec(envoi.id, 'Pas de réseau');
    final apresEchec = (await depots.envois.enAttente()).single;
    expect(apresEchec.tentatives, 1);
    expect(apresEchec.derniereErreur, 'Pas de réseau');

    await depots.envois.marquerEnvoye(envoi.id);
    expect(await depots.envois.enAttente(), isEmpty);
    expect(await depots.envois.nombreEnAttente(), 0);
  });

  test('une saisie à moitié invalide n\'est pas enregistrée (transaction)',
      () async {
    final (:navire, :licence) =
        (await depots.flotte.naviresAvecLicence()).first;
    final d = DeclarationCapitaine(
      navire: navire,
      licence: licence,
      engin: TypeEngin.chalutDemersal,
      position: PositionGps(20, -17, DateTime(2026, 10, 3)),
      // Code espèce invalide (4 lettres) : l'insertion de la capture échoue.
      captures: [const Capture(especeCode: 'SOLE', poidsKg: 10)],
    );

    await expectLater(
      depots.saisies.enregistrerDeclaration(d, calcul.verifierDeclaration(d)),
      throwsA(isA<InvalidDataException>()),
    );
    expect(await base.select(base.declarations).get(), isEmpty);
    expect(await depots.envois.nombreEnAttente(), 0);
  });

  test('migration v1 -> v4 : rapport PDF, réglages, suppression logique',
      () async {
    // 1. On fabrique une base « comme sur un téléphone resté en v1 » :
    //    schéma actuel, puis on retire la colonne ajoutée en v2.
    final brute = sqlite3.openInMemory();
    final v1 = BaseDeDonnees.avec(
        NativeDatabase.opened(brute, closeUnderlyingOnClose: false));
    await v1.customSelect('SELECT 1').get(); // crée et remplit la base
    await v1.close();
    brute.execute('ALTER TABLE controles DROP COLUMN rapport_pdf');
    brute.execute('DROP TABLE reglages'); // ajoutée en v3
    brute.execute('ALTER TABLE navires DROP COLUMN supprime'); // v4
    brute.execute('ALTER TABLE licences DROP COLUMN supprime'); // v4
    brute.userVersion = 1;

    // 2. On la rouvre avec le code actuel : onUpgrade doit s'exécuter.
    final v2 = BaseDeDonnees.avec(NativeDatabase.opened(brute));
    addTearDown(v2.close);
    final saisies = Services(v2).saisies;
    final (:navire, :licence) =
        (await Services(v2).flotte.naviresAvecLicence()).first;
    final c = Controle(
      navire: navire,
      agent: 'Agent test',
      date: DateTime(2026, 10, 3),
      position: PositionGps(20, -17, DateTime(2026, 10, 3)),
      engin: TypeEngin.chalutDemersal,
    );
    final id = await saisies.enregistrerControle(
      c,
      calcul.verifierControle(c, licence: licence),
      'RAPPORT',
      rapportPdf: Uint8List.fromList([37, 80, 68, 70]), // « %PDF »
    );

    expect(brute.userVersion, 4);
    expect(await saisies.rapportPdf(id), [37, 80, 68, 70]);
    final reglages = Services(v2).reglages;
    await reglages.ecrire('langue', 'ar');
    expect(await reglages.lire('langue'), 'ar');
  });
}
