import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peche_app/core/data/base/base_de_donnees.dart';
import 'package:peche_app/core/data/base/tables.dart';
import 'package:peche_app/core/services/position_service.dart';
import 'package:peche_app/core/services/services.dart';
import 'package:peche_app/core/models/declaration.dart';
import 'package:peche_app/core/models/enums.dart';
import 'package:peche_app/core/regulation/calcul_reglementaire.dart';
import 'package:peche_app/core/regulation/referentiel.dart';
import 'package:peche_app/core/services/synchronisation.dart';
import 'package:peche_app/main.dart';

import 'faux_serveur.dart';

void main() {
  late BaseDeDonnees base;
  late Services services;

  /// Lance l'application avec une base SQLite en mémoire, une position
  /// fixe et, si fourni, un faux serveur.
  Future<void> lancer(WidgetTester tester, {ApiSynchro? api}) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);
    base = BaseDeDonnees.avec(NativeDatabase.memory());
    addTearDown(base.close);
    services =
        Services(base, position: const PositionFixe(20.62, -17.30), api: api);
    await tester.pumpWidget(PecheApp(services: services));
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
    expect(find.text('1 saisie à envoyer au serveur'), findsOneWidget);
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
    // La génération du PDF est un vrai travail asynchrone : on lui laisse
    // le temps de finir, puis on affiche les images suivantes. (Pas de
    // pumpAndSettle : l'indicateur de chargement de l'aperçu tourne.)
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Rapport d\'inspection (PDF)'), findsOneWidget);
    final controles = await base.select(base.controles).get();
    expect(controles.single.rapport, contains('RAPPORT D\'INSPECTION'));
    final pdf = controles.single.rapportPdf!;
    expect(String.fromCharCodes(pdf.take(5)), '%PDF-');
  });

  testWidgets('envois en attente : « Envoyer maintenant » vide la file',
      (tester) async {
    final serveur = FauxServeur();
    await lancer(tester, api: serveur);
    final (:navire, :licence) =
        (await services.flotte.naviresAvecLicence()).first;
    final d = DeclarationCapitaine(
      navire: navire,
      licence: licence,
      engin: TypeEngin.chalutDemersal,
      position: PositionGps(20, -17, DateTime(2026, 10, 3)),
      captures: [const Capture(especeCode: 'SOL', poidsKg: 500)],
    );
    await services.saisies.enregistrerDeclaration(
        d, const CalculReglementaire(referentielDemo).verifierDeclaration(d));

    await tester.tap(find.text('Envois en attente'));
    await tester.pumpAndSettle();
    expect(find.textContaining('500 kg'), findsOneWidget);

    await tester.tap(find.byTooltip('Envoyer maintenant'));
    await tester.pumpAndSettle();

    expect(find.text('Tout a été envoyé.'), findsOneWidget);
    expect(find.text('1 envoyé(s), 0 échec(s)'), findsOneWidget);
    expect(serveur.recus.single.$1, TypeEnvoi.declaration);
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
