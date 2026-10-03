import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peche_app/core/data/base/base_de_donnees.dart';
import 'package:peche_app/core/data/depots/depots.dart';
import 'package:peche_app/main.dart';

void main() {
  late BaseDeDonnees base;

  /// Lance l'application avec une base SQLite en mémoire.
  Future<void> lancer(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);
    base = BaseDeDonnees.avec(NativeDatabase.memory());
    addTearDown(base.close);
    await tester.pumpWidget(PecheApp(depots: Depots(base)));
    await tester.pumpAndSettle();
  }

  Future<void> ouvrir(WidgetTester tester, String module) async {
    await lancer(tester);
    await tester.tap(find.text(module));
    await tester.pumpAndSettle();
  }

  testWidgets('déclaration du capitaine : 4 étapes puis enregistrement local',
      (tester) async {
    await ouvrir(tester, 'Déclaration du capitaine');
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Suivant').hitTestable());
      await tester.pumpAndSettle();
    }
    // Le chalutier de démo (premier par ordre alphabétique) a un agrément
    // sanitaire expiré.
    expect(find.textContaining('non-conformité'), findsOneWidget);

    // Le bouton de la 4e étape (la dernière dans l'arbre) est sous le
    // résultat : on fait défiler jusqu'à lui.
    final signer = find.text('Signer et envoyer').last;
    await tester.ensureVisible(signer);
    await tester.pumpAndSettle();
    await tester.tap(signer);
    await tester.pumpAndSettle();

    // Retour à l'accueil : la saisie attend dans la file d'envoi.
    expect(find.text('1 saisie(s) à envoyer au serveur'), findsOneWidget);
    expect(await base.select(base.declarations).get(), hasLength(1));
  });

  testWidgets('contrôle agent : rapport signé puis enregistré', (tester) async {
    await ouvrir(tester, 'Contrôle garde-côtes');
    final bouton = find.text('Générer le rapport d\'inspection');
    await tester.scrollUntilVisible(bouton, 300,
        scrollable: find.byType(Scrollable).first);
    expect(find.textContaining('non-conformité'), findsOneWidget);

    await tester.tap(bouton);
    await tester.pumpAndSettle();
    expect(find.textContaining('RAPPORT D\'INSPECTION'), findsOneWidget);

    await tester.tap(find.text('Signer'));
    await tester.pumpAndSettle();

    final controles = await base.select(base.controles).get();
    expect(controles.single.rapport, contains('RAPPORT D\'INSPECTION'));
    expect(find.text('1 saisie(s) à envoyer au serveur'), findsOneWidget);
  });

  testWidgets('envois en attente : vide au départ', (tester) async {
    await ouvrir(tester, 'Envois en attente');
    expect(find.text('Tout a été envoyé.'), findsOneWidget);
  });

  testWidgets('guide réglementaire', (tester) async {
    await ouvrir(tester, 'Guide réglementaire');
    expect(find.textContaining('Code des pêches'), findsOneWidget);
  });
}
