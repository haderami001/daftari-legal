import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:peche_app/core/data/base/base_de_donnees.dart';
import 'package:peche_app/core/models/declaration.dart';
import 'package:peche_app/core/models/enums.dart';
import 'package:peche_app/core/regulation/calcul_reglementaire.dart';
import 'package:peche_app/core/regulation/referentiel.dart';
import 'package:peche_app/core/services/position_service.dart';
import 'package:peche_app/core/services/services.dart';
import 'package:peche_app/core/services/supervision.dart';
import 'package:peche_app/core/services/synchronisation.dart';
import 'package:peche_app/features/controle/rapport_pdf_screen.dart';
import 'package:peche_app/main.dart';
import 'package:serveur_peche/serveur_peche.dart' as serveur;

import 'administration_test.dart' show SessionRole, clientVers, jeton;

void main() {
  const calcul = CalculReglementaire(referentielDemo);
  final base = Uri.parse('https://api.test');
  late MockClient client;
  late String idControle;

  /// Un capitaine et un agent ont envoyé une déclaration et un contrôle
  /// (avec infractions) au vrai serveur, en mémoire.
  setUp(() async {
    client = clientVers(serveur.construireApi(
        stockage: serveur.StockageMemoire(),
        authentificateur: serveur.AuthJetonPartage(jeton)));
    final db = BaseDeDonnees.avec(NativeDatabase.memory());
    final s = Services(db,
        api: ApiHttp(base, client: client, jeton: () async => jeton));
    final flotte = await s.flotte.naviresAvecLicence();
    final pirogue = flotte.firstWhere((f) => f.navire.id == 'N1');
    final d = DeclarationCapitaine(
      navire: pirogue.navire,
      licence: pirogue.licence,
      engin: TypeEngin.casier,
      position: PositionGps(20.8, -17.4, DateTime.utc(2026, 10, 3, 8)),
      captures: [const Capture(especeCode: 'OCC', poidsKg: 50)],
    );
    await s.saisies.enregistrerDeclaration(d, calcul.verifierDeclaration(d));
    final chalutier = flotte.firstWhere((f) => f.navire.id == 'N2');
    final c = Controle(
      navire: chalutier.navire,
      agent: 'Agent test',
      date: DateTime.utc(2026, 10, 3, 9),
      position: PositionGps(20.6, -17.3, DateTime.utc(2026, 10, 3, 9)),
      engin: TypeEngin.chalutDemersal,
      maillagesMm: [55],
    );
    idControle = await s.saisies.enregistrerControle(
        c, calcul.verifierControle(c, licence: chalutier.licence), 'RAPPORT',
        rapportPdf: utf8.encode('%PDF-test'));
    final r = await s.synchro.synchroniser();
    expect(r.envoyes, 2);
    await db.close();
  });

  test('ApiSupervision : statistiques, listes, PDF', () async {
    final api = ApiSupervision(base, client: client, jeton: () async => jeton);
    expect(await api.statistiques(), {'declarations': 1, 'controles': 1});
    final controles = await api.lister('controles');
    expect(controles.single.id, idControle);
    expect(controles.single.navireId, 'N2');
    expect(controles.single.nbInfractions, greaterThan(0));
    expect(utf8.decode(await api.rapportPdf(idControle)), '%PDF-test');
  });

  group('écran', () {
    Future<void> lancer(WidgetTester tester, String role) async {
      tester.view.physicalSize = const Size(1080, 2400);
      addTearDown(tester.view.reset);
      final db = BaseDeDonnees.avec(NativeDatabase.memory());
      addTearDown(db.close);
      await tester.pumpWidget(PecheApp(
          services: Services(db,
              position: const PositionFixe(20, -17),
              session: SessionRole(role),
              supervision: ApiSupervision(base,
                  client: client, jeton: () async => jeton))));
      await tester.pumpAndSettle();
    }

    testWidgets('le superviseur voit les saisies reçues et ouvre le PDF',
        (tester) async {
      await lancer(tester, 'superviseur');
      // Pas de module de saisie pour lui, mais le tableau de bord.
      expect(find.text('Déclaration du capitaine'), findsNothing);
      await tester.tap(find.text('Tableau de bord'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Navire N1'), findsOneWidget);
      expect(find.textContaining('aucune infraction'), findsOneWidget);
      expect(find.textContaining('envoyé par jeton-partage'), findsOneWidget);

      await tester.tap(find.widgetWithText(Tab, 'Contrôles'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Navire N2'), findsOneWidget);
      await tester.tap(find.textContaining('Navire N2'));
      // L'aperçu PDF s'anime en continu : pas de pumpAndSettle.
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byType(RapportPdfScreen), findsOneWidget);
    });

    testWidgets('caché pour un agent', (tester) async {
      await lancer(tester, 'agent');
      expect(find.text('Tableau de bord'), findsNothing);
    });
  });
}
