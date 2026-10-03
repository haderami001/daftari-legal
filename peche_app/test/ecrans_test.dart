import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peche_app/main.dart';

void main() {
  Future<void> ouvrir(WidgetTester tester, String module) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const PecheApp());
    await tester.tap(find.text(module));
    await tester.pumpAndSettle();
  }

  testWidgets('déclaration du capitaine : parcours des 4 étapes',
      (tester) async {
    await ouvrir(tester, 'Déclaration du capitaine');
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Suivant').hitTestable());
      await tester.pumpAndSettle();
    }
    expect(find.text('Signer et envoyer').hitTestable(), findsOneWidget);
    expect(find.text('Conforme'), findsOneWidget);
  });

  testWidgets('contrôle agent : génération du rapport', (tester) async {
    await ouvrir(tester, 'Contrôle garde-côtes');
    await tester.scrollUntilVisible(
        find.text('Générer le rapport d\'inspection'), 300,
        scrollable: find.byType(Scrollable).first);
    // Le chalutier de démo a un agrément sanitaire expiré.
    expect(find.textContaining('non-conformité'), findsOneWidget);
    await tester.tap(find.text('Générer le rapport d\'inspection'));
    await tester.pumpAndSettle();
    expect(find.textContaining('RAPPORT D\'INSPECTION'), findsOneWidget);
  });

  testWidgets('guide réglementaire', (tester) async {
    await ouvrir(tester, 'Guide réglementaire');
    expect(find.textContaining('Code des pêches'), findsOneWidget);
  });
}
