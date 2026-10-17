import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peche_app/core/data/base/base_de_donnees.dart';
import 'package:peche_app/core/models/declaration.dart';
import 'package:peche_app/core/models/ports.dart';
import 'package:peche_app/core/qr_licence.dart';
import 'package:peche_app/core/regulation/calcul_reglementaire.dart';
import 'package:peche_app/core/regulation/rapport.dart';
import 'package:peche_app/core/regulation/rapport_pdf.dart';
import 'package:peche_app/core/regulation/referentiel.dart';
import 'package:peche_app/core/services/photo_service.dart';
import 'package:peche_app/core/services/position_service.dart';
import 'package:peche_app/core/services/services.dart';
import 'package:peche_app/main.dart';

import 'photo_test_data.dart';

void main() {
  const calcul = CalculReglementaire(referentielDemo);

  group('QR code de licence', () {
    test('aller-retour, même avec des caractères spéciaux', () {
      final qr = contenuQrLicence('LIC-ART/2026:0091', 'N1');
      expect(qr, startsWith('PECHE-CONFORME:LICENCE:'));
      expect(lireQrLicence(qr), (numero: 'LIC-ART/2026:0091', navireId: 'N1'));
      expect(lireQrLicence('  $qr\n'), isNotNull);
    });

    test('un autre QR code est refusé', () {
      expect(lireQrLicence('https://exemple.mr'), isNull);
      expect(lireQrLicence('PECHE-CONFORME:LICENCE:'), isNull);
      expect(lireQrLicence('PECHE-CONFORME:LICENCE:abc'), isNull);
      expect(lireQrLicence('PECHE-CONFORME:LICENCE:%E0%A4%A:N1'), isNull);
    });
  });

  test('nouvelles espèces : un mérou trop petit est signalé', () {
    final taille = calcul.verifierTailles(const [
      Echantillon(especeCode: 'GPW', valeur: 30),
      Echantillon(especeCode: 'GPW', valeur: 50),
    ]);
    expect(taille, hasLength(1));
    expect(taille.single.code, 'TAILLE_MIN');
    expect(taille.single.details['espece'], 'GPW');
    expect(referentielDemo.espece('GPW')!.nomCommun, 'Mérou blanc');
  });

  group('port de débarquement et photos', () {
    late BaseDeDonnees base;
    late Services services;

    setUp(() {
      base = BaseDeDonnees.avec(NativeDatabase.memory());
      services = Services(base, position: const PositionFixe(20, -17));
    });
    tearDown(() => base.close());

    test('déclaration : le port est enregistré et envoyé', () async {
      final (:navire, :licence) =
          (await services.flotte.naviresAvecLicence()).first;
      final d = DeclarationCapitaine(
        navire: navire,
        licence: licence,
        engin: licence.enginsAutorises.first,
        position: PositionGps(20, -17, DateTime(2026, 10, 3)),
        portDebarquement: 'NDB',
      );
      final id = await services.saisies
          .enregistrerDeclaration(d, calcul.verifierDeclaration(d));
      final json = await services.saisies.exporterDeclaration(id);
      expect(json['port_debarquement'], 'NDB');
    });

    test('contrôle à quai avec photos : base, envoi, rapports', () async {
      final (:navire, :licence) =
          (await services.flotte.naviresAvecLicence()).first;
      final c = Controle(
        navire: navire,
        agent: 'Agent test',
        date: DateTime(2026, 10, 3),
        position: PositionGps(20, -17, DateTime(2026, 10, 3)),
        engin: licence.enginsAutorises.first,
        portDebarquement: 'NKC',
        photos: [photoTest, photoTest],
      );
      final r = calcul.verifierControle(c, licence: licence);
      final texte = genererRapportControle(c, r);
      expect(texte, contains('À quai, port de Nouakchott'));
      expect(texte, contains('Photos de preuve      : 2'));

      final pdf =
          await genererRapportPdf(c, r, licence: licence, identifiant: 'abcd');
      expect(String.fromCharCodes(pdf.take(5)), '%PDF-');
      // L'annexe photos ajoute au moins une page.
      final sansPhotos = await genererRapportPdf(
          Controle(
            navire: navire,
            agent: 'Agent test',
            date: DateTime(2026, 10, 3),
            position: PositionGps(20, -17, DateTime(2026, 10, 3)),
            engin: licence.enginsAutorises.first,
          ),
          r,
          licence: licence);
      expect(pdf.length, greaterThan(sansPhotos.length));

      final id = await services.saisies
          .enregistrerControle(c, r, texte, rapportPdf: pdf);
      expect(await services.saisies.photos(id), [photoTest, photoTest]);
      final json = await services.saisies.exporterControle(id);
      expect(json['port_debarquement'], 'NKC');
      expect(json['photos_base64'], hasLength(2));
    });

    test('contrôle sans photo : pas de champ photos envoyé', () async {
      final (:navire, :licence) =
          (await services.flotte.naviresAvecLicence()).first;
      final c = Controle(
        navire: navire,
        agent: 'Agent test',
        date: DateTime(2026, 10, 3),
        position: PositionGps(20, -17, DateTime(2026, 10, 3)),
        engin: licence.enginsAutorises.first,
      );
      final r = calcul.verifierControle(c, licence: licence);
      final id = await services.saisies.enregistrerControle(c, r, 'R');
      final json = await services.saisies.exporterControle(id);
      expect(json.containsKey('photos_base64'), isFalse);
      expect(json.containsKey('port_debarquement'), isFalse);
      expect(lieuControle(c), 'En mer');
    });

    test('chaque port a un nom', () {
      for (final code in portsDebarquement.keys) {
        expect(nomPort(code), isNot(code));
      }
      expect(nomPort('XXX'), 'XXX');
    });
  });

  testWidgets('contrôle : une photo de preuve est ajoutée au rapport signé',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);
    final base = BaseDeDonnees.avec(NativeDatabase.memory());
    addTearDown(base.close);
    final services = Services(base,
        position: const PositionFixe(20.62, -17.30),
        photo: PhotoFixe(photoTest));
    await tester.pumpWidget(PecheApp(services: services));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contrôle garde-côtes'));
    await tester.pumpAndSettle();

    final prendre = find.text('Prendre une photo');
    await tester.scrollUntilVisible(prendre, 300,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(prendre);
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsOneWidget);

    final bouton = find.text('Générer le rapport d\'inspection');
    await tester.scrollUntilVisible(bouton, 300,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(bouton);
    await tester.pumpAndSettle();
    expect(find.textContaining('Photos de preuve      : 1'), findsOneWidget);
    await tester.tap(find.text('Signer'));
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final controle = (await base.select(base.controles).get()).single;
    expect(await services.saisies.photos(controle.id), [photoTest]);
  });

  testWidgets('déclaration : le capitaine affiche le QR code de sa licence',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);
    final base = BaseDeDonnees.avec(NativeDatabase.memory());
    addTearDown(base.close);
    await tester.pumpWidget(PecheApp(
        services: Services(base, position: const PositionFixe(20, -17))));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Déclaration du capitaine'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('QR code de la licence'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Montrez ce code'), findsOneWidget);
  });
}
