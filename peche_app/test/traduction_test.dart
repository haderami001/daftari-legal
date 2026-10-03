import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peche_app/core/data/base/base_de_donnees.dart';
import 'package:peche_app/core/data/depots/reglages_depot.dart';
import 'package:peche_app/core/data/donnees_demo.dart';
import 'package:peche_app/core/models/declaration.dart';
import 'package:peche_app/core/models/enums.dart';
import 'package:peche_app/core/regulation/calcul_reglementaire.dart';
import 'package:peche_app/core/regulation/referentiel.dart';
import 'package:peche_app/core/services/position_service.dart';
import 'package:peche_app/core/services/services.dart';
import 'package:peche_app/l10n/libelles.dart';
import 'package:peche_app/main.dart';

void main() {
  final fr = lookupAppLocalizations(const Locale('fr'));
  final ar = lookupAppLocalizations(const Locale('ar'));

  group('traductions', () {
    test('le français reprend les libellés du moteur', () {
      for (final e in TypeEngin.values) {
        expect(fr.libelleEngin(e), e.libelle);
      }
      for (final r in referentielDemo.especes.values) {
        expect(fr.nomEspece(r.code), r.nomCommun);
      }
    });

    test('chaque engin, espèce et gravité a un libellé arabe', () {
      final arabe = RegExp(r'[؀-ۿ]');
      for (final e in TypeEngin.values) {
        expect(ar.libelleEngin(e), matches(arabe), reason: e.name);
      }
      for (final code in referentielDemo.especes.keys) {
        expect(ar.nomEspece(code), matches(arabe), reason: code);
      }
      for (final g in Gravite.values) {
        expect(ar.libelleGravite(g), matches(arabe), reason: g.name);
      }
    });

    test('pluriels arabes (1, 2, 3-10, 11+)', () {
      expect(ar.nonConformites(1), 'مخالفة واحدة');
      expect(ar.nonConformites(2), 'مخالفتان');
      expect(ar.nonConformites(3), '3 مخالفات');
      expect(ar.nonConformites(11), '11 مخالفة');
      expect(fr.nonConformites(1), '1 non-conformité');
      expect(fr.nonConformites(3), '3 non-conformités');
    });

    test('les messages d\'infraction sont traduits, en gardant les valeurs',
        () {
      const calcul = CalculReglementaire(referentielDemo);
      final c = Controle(
        navire: naviresDemo[1],
        agent: 'test',
        date: DateTime(2026, 10, 3),
        position: PositionGps(20, -17, DateTime(2026, 10, 3)),
        engin: TypeEngin.chalutDemersal,
        marquageConforme: false,
        maillagesMm: [60, 62],
        echantillons: const [Echantillon(especeCode: 'SOL', valeur: 20)],
      );
      final r = calcul.verifierControle(c, licence: licencesDemo['N2']);

      final codes = r.infractions.map((i) => i.code).toSet();
      expect(codes,
          containsAll(['MARQUAGE', 'CERT_EXPIRE', 'MAILLAGE', 'TAILLE_MIN']));
      for (final i in r.infractions) {
        // Aucun code ne retombe sur le message français du moteur.
        expect(ar.messageInfraction(i), isNot(i.message), reason: i.code);
      }
      final maillage = r.infractions.firstWhere((i) => i.code == 'MAILLAGE');
      expect(ar.messageInfraction(maillage),
          'متوسط مقاس العين 61.0 مم أقل من 70 مم المطلوبة (شباك الجر القاعية).');
      // En français, l'interface affiche le même texte que le rapport.
      for (final i in r.infractions) {
        expect(fr.messageInfraction(i), i.message, reason: i.code);
      }
    });
  });

  group('interface en arabe', () {
    late BaseDeDonnees base;

    Future<Services> lancer(WidgetTester tester, {String? langue}) async {
      tester.view.physicalSize = const Size(1080, 2400);
      addTearDown(tester.view.reset);
      base = BaseDeDonnees.avec(NativeDatabase.memory());
      addTearDown(base.close);
      final services =
          Services(base, position: const PositionFixe(20.62, -17.30));
      if (langue != null) {
        await services.reglages.ecrire(ReglagesDepot.cleLangue, langue);
      }
      await tester.pumpWidget(PecheApp(services: services));
      await tester.pumpAndSettle();
      return services;
    }

    testWidgets('la langue enregistrée est appliquée, de droite à gauche',
        (tester) async {
      await lancer(tester, langue: 'ar');

      expect(find.text('تصريح الربّان'), findsOneWidget);
      expect(find.text('تفتيش خفر السواحل'), findsOneWidget);
      final direction =
          Directionality.of(tester.element(find.text('تصريح الربّان')));
      expect(direction, TextDirection.rtl);
    });

    testWidgets('contrôle en arabe : infractions traduites', (tester) async {
      await lancer(tester, langue: 'ar');
      await tester.tap(find.text('تفتيش خفر السواحل'));
      await tester.pumpAndSettle();

      final bouton = find.text('إنشاء تقرير التفتيش');
      await tester.scrollUntilVisible(bouton, 300,
          scrollable: find.byType(Scrollable).first);
      // Le chalutier de démo a un agrément sanitaire expiré.
      expect(find.text('مخالفة واحدة'), findsOneWidget);
      expect(find.text('الاعتماد الصحي رقم SAN-2024-33 منتهي الصلاحية.'),
          findsOneWidget);
    });

    testWidgets('le menu Langue change et mémorise la langue', (tester) async {
      final services = await lancer(tester);
      expect(find.text('Déclaration du capitaine'), findsOneWidget);

      await tester.tap(find.byTooltip('Langue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('العربية').last);
      await tester.pumpAndSettle();

      expect(find.text('تصريح الربّان'), findsOneWidget);
      expect(await services.reglages.lire(ReglagesDepot.cleLangue), 'ar');

      // Retour à la langue du téléphone (français dans les tests).
      await tester.tap(find.byTooltip('اللغة'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('لغة الهاتف').last);
      await tester.pumpAndSettle();
      expect(find.text('Déclaration du capitaine'), findsOneWidget);
      expect(await services.reglages.lire(ReglagesDepot.cleLangue), isNull);
    });
  });
}
