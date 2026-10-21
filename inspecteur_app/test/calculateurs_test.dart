import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspecteur_app/main.dart';

void main() {
  Future<void> lancer(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const InspecteurApp());
    await tester.pumpAndSettle();
  }

  Future<void> mesurer(
      WidgetTester tester, String libelle, String valeur) async {
    await tester.enterText(find.widgetWithText(TextField, libelle), valeur);
    await tester.tap(find.byTooltip('Ajouter'));
    await tester.pumpAndSettle();
  }

  testWidgets('accueil : calculateurs ouverts, autres modules à venir',
      (tester) async {
    await lancer(tester);
    expect(find.text('Inspecteur des pêches'), findsWidgets);
    expect(
        find.text('Valeurs de démonstration (demo-2026.10)'), findsOneWidget);
    expect(find.text('Calculateurs'), findsOneWidget);
    expect(find.text('Bibliothèque juridique'), findsOneWidget);
    await tester.scrollUntilVisible(
        find.text('Nouveautés réglementaires'), 200);
    expect(find.text('Nouveautés réglementaires'), findsOneWidget);
    expect(find.text('Bientôt'), findsNWidgets(2));
  });

  testWidgets('maillage : moyenne comparée au minimum moins la tolérance',
      (tester) async {
    await lancer(tester);
    await tester.tap(find.text('Calculateurs'));
    await tester.pumpAndSettle();

    // Chalut de fond : 70 mm, tolérance 5 % -> seuil 66,5 mm.
    expect(find.text('Minimum : 70 mm (tolérance 5 %)'), findsOneWidget);
    expect(find.text('Seuil retenu après tolérance : 66.5 mm'), findsOneWidget);

    await mesurer(tester, "Mesure d'une maille (mm)", '60');
    expect(find.text('Moyenne mesurée : 60.0 mm'), findsOneWidget);
    expect(find.text('Non conforme · Grave'), findsOneWidget);
    expect(find.textContaining('Amende indicative'), findsOneWidget);

    // 60 et 75 : moyenne 67,5 mm, au-dessus du seuil.
    await mesurer(tester, "Mesure d'une maille (mm)", '75');
    expect(find.text('Moyenne mesurée : 67.5 mm'), findsOneWidget);
    expect(find.text('Conforme'), findsOneWidget);

    // Engin sans maillage réglementé.
    await tester.tap(find.text('Chalut de fond'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Casier / pot à poulpe').last);
    await tester.pumpAndSettle();
    expect(find.text('Pas de maillage réglementé pour cet engin.'),
        findsOneWidget);
  });

  testWidgets('tailles minimales : gravité selon la part sous le minimum',
      (tester) async {
    await lancer(tester);
    await tester.tap(find.text('Calculateurs'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tailles minimales'));
    await tester.pumpAndSettle();

    // Poulpe : 500 g minimum, règle du Code des pêches.
    expect(find.text('Minimum : 500 g'), findsOneWidget);
    expect(find.textContaining('Code des pêches (MRT)'), findsOneWidget);

    await mesurer(tester, 'Mesure (g)', '800');
    expect(find.text('Conforme'), findsOneWidget);
    // 1 individu sur 2 trop petit : 50 % -> mineure.
    await mesurer(tester, 'Mesure (g)', '450');
    expect(find.text('1 sur 2 sous le minimum'), findsOneWidget);
    expect(find.text('Non conforme · Mineure'), findsOneWidget);
    // 2 sur 3 : plus de la moitié -> grave.
    await mesurer(tester, 'Mesure (g)', '300');
    expect(find.text('Non conforme · Grave'), findsOneWidget);
  });

  testWidgets('en arabe : interface de droite à gauche', (tester) async {
    await lancer(tester);
    await tester.tap(find.byTooltip('Langue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();

    expect(find.text('مفتش الصيد'), findsWidgets);
    expect(find.text('الحاسبات'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('الحاسبات'))),
        TextDirection.rtl);
  });
}
