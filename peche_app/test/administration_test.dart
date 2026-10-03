import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:peche_app/core/data/base/base_de_donnees.dart';
import 'package:peche_app/core/services/administration.dart';
import 'package:peche_app/core/services/position_service.dart';
import 'package:peche_app/core/services/services.dart';
import 'package:peche_app/core/services/session.dart';
import 'package:peche_app/core/services/synchronisation.dart';
import 'package:peche_app/main.dart';
import 'package:serveur_peche/serveur_peche.dart' as serveur;
import 'package:shelf/shelf.dart' as shelf;

const jeton = 'jeton-administration-1234';

/// Client HTTP branché directement sur le VRAI serveur du dépôt, en
/// mémoire (les tests d'écran ne peuvent pas ouvrir de vraies connexions).
MockClient clientVers(shelf.Handler api) => MockClient((req) async {
      final rep = await api(shelf.Request(req.method, req.url,
          headers: req.headers, body: req.bodyBytes));
      return http.Response.bytes(
          await rep.read().expand((o) => o).toList(), rep.statusCode,
          headers: rep.headers);
    });

/// Session de test avec un rôle donné.
class SessionRole extends SessionDemo {
  SessionRole(this.role) : super(jetonPartage: jeton);
  final String role;
  @override
  Profil? get profil =>
      Profil(identifiant: role, nomComplet: 'Compte $role', roles: {role});
}

void main() {
  late serveur.StockageMemoire stockage;
  late MockClient client;
  final base = Uri.parse('https://api.test');

  setUp(() {
    stockage = serveur.StockageMemoire();
    client = clientVers(serveur.construireApi(
        stockage: stockage, authentificateur: serveur.AuthJetonPartage(jeton)));
  });

  group('ApiAdministration', () {
    test('enregistre un navire avec certificats, puis le relit', () async {
      final api =
          ApiAdministration(base, client: client, jeton: () async => jeton);
      final navire = {
        'nom': 'Tanit',
        'immatriculation': 'NKT-SE-0001',
        'pavillon': 'MRT',
        'type': 'senneur',
        'longueur_m': 30.0,
        'puissance_kw': 500.0,
        'numero_imo': null,
        'certificats': [
          {
            'type': 'radio',
            'numero': 'VMS-1',
            'date_expiration': '2027-12-31',
          },
        ],
      };
      expect(await api.enregistrerNavire('N4', navire), Ecriture.cree);
      expect(await api.enregistrerNavire('N4', navire), Ecriture.modifie);
      final ref = await api.referentiel();
      expect((ref['navires']! as List).single, {'id': 'N4', ...navire});
    });

    test('refus du serveur : message et détail champ par champ', () async {
      final api =
          ApiAdministration(base, client: client, jeton: () async => jeton);
      await expectLater(
          api.enregistrerNavire('N4', {'nom': 'X'}),
          throwsA(isA<ErreurAdministration>()
              .having((e) => e.details, 'details', isNotEmpty)));
      await expectLater(
          api.enregistrerLicence('LIC-1', {
            'navire_id': 'INCONNU',
            'segment': 'artisanale',
            'engins_autorises': ['ligne'],
            'especes_cibles': ['OCC'],
            'date_debut': '2026-01-01',
            'date_fin': '2026-12-31',
          }),
          throwsA(isA<ErreurAdministration>().having(
              (e) => e.message, 'message', contains('absent du référentiel'))));

      final pasAdmin = ApiAdministration(base,
          client: clientVers(serveur.construireApi(
              stockage: stockage, authentificateur: _AuthAgent())),
          jeton: () async => 'x');
      await expectLater(
          pasAdmin.enregistrerNavire('N4', {}),
          throwsA(isA<ErreurAdministration>()
              .having((e) => e.message, 'message', contains('rôle'))));
    });
  });

  group('écran d\'administration', () {
    Future<Services> lancer(WidgetTester tester, String role) async {
      tester.view.physicalSize = const Size(1080, 2400);
      addTearDown(tester.view.reset);
      final db = BaseDeDonnees.avec(NativeDatabase.memory());
      addTearDown(db.close);
      final services = Services(db,
          position: const PositionFixe(20, -17),
          session: SessionRole(role),
          api: ApiHttp(base, client: client, jeton: () async => jeton),
          administration: ApiAdministration(base,
              client: client, jeton: () async => jeton));
      await tester.pumpWidget(PecheApp(services: services));
      await tester.pumpAndSettle();
      return services;
    }

    testWidgets('réservé à l\'administrateur', (tester) async {
      await lancer(tester, 'agent');
      expect(find.text('Navires et licences'), findsNothing);
    });

    testWidgets('ajout d\'un navire puis de sa licence, refus affiché',
        (tester) async {
      final services = await lancer(tester, 'admin');
      await tester.tap(find.text('Navires et licences'));
      await tester.pumpAndSettle();
      expect(find.text('Aucun élément pour l\'instant'), findsOneWidget);

      // Nouveau navire.
      await tester.tap(find.text('Ajouter un navire'));
      await tester.pumpAndSettle();
      Future<void> saisir(String libelle, String texte) =>
          tester.enterText(find.widgetWithText(TextFormField, libelle), texte);
      await saisir('Identifiant (ex. N4)', 'N4');
      await saisir('Nom', 'Tanit');
      await saisir('Immatriculation', 'NKT-SE-0001');
      await saisir('Longueur (m)', '30,5');
      await saisir('Puissance (kW)', '500');
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      expect(find.text('Tanit'), findsOneWidget);
      // Retour à l'accueil : il reçoit le nombre de modifications (1).
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('1 modification enregistrée'), findsOneWidget);
      await tester.tap(find.text('Navires et licences'));
      await tester.pumpAndSettle();
      final navire =
          ((await stockage.referentiel())['navires']! as List).single as Map;
      expect(navire['longueur_m'], 30.5);
      expect(navire['pavillon'], 'MRT');

      // Deuxième navire avec la même immatriculation : refus du serveur.
      await tester.tap(find.text('Ajouter un navire'));
      await tester.pumpAndSettle();
      await saisir('Identifiant (ex. N4)', 'N5');
      await saisir('Nom', 'Copie');
      await saisir('Immatriculation', 'NKT-SE-0001');
      await saisir('Longueur (m)', '10');
      await saisir('Puissance (kW)', '10');
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Refusé par le serveur'), findsOneWidget);
      expect(find.textContaining('déjà utilisée'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Liste verticale du formulaire (les champs texte ont aussi un
      // Scrollable, horizontal).
      final vertical = find.byWidgetPredicate(
          (w) => w is Scrollable && w.axisDirection == AxisDirection.down);

      // Licence du nouveau navire.
      await tester.tap(find.text('Licences'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ajouter une licence'));
      await tester.pumpAndSettle();
      await saisir('Numéro de licence', 'LIC-COT-2026-0400');
      await tester.tap(find.text('Navire'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tanit (N4)').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Senne tournante'));
      await saisir(
          'Espèces ciblées (codes FAO séparés par des virgules)', 'saa, sae');
      for (final champ in ['Début', 'Fin']) {
        await tester.tap(find.widgetWithText(InputDecorator, champ));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
      }
      await tester.scrollUntilVisible(find.text('Ajouter un quota'), 200,
          scrollable: vertical);
      await tester.tap(find.text('Ajouter un quota'));
      await tester.pumpAndSettle();
      await saisir('Espèce (code FAO)', 'SAA');
      await saisir('kg', '80000');
      await tester.scrollUntilVisible(find.text('Enregistrer'), 200,
          scrollable: vertical);
      await tester.ensureVisible(find.text('Enregistrer'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      final licence =
          ((await stockage.referentiel())['licences']! as List).single as Map;
      expect(licence['navire_id'], 'N4');
      expect(licence['engins_autorises'], ['senneTournante']);
      expect(licence['especes_cibles'], ['SAA', 'SAE']);
      expect(licence['quotas_kg'], {'SAA': 80000.0});
      expect(find.textContaining('LIC-COT-2026-0400'), findsOneWidget);

      // Le téléphone a reçu la nouvelle flotte (synchronisation).
      await tester.runAsync(() => services.synchro.synchroniser());
      final flotte =
          await tester.runAsync(() => services.flotte.naviresAvecLicence());
      expect(flotte!.map((f) => f.navire.id), contains('N4'));
    });
  });
}

class _AuthAgent implements serveur.Authentificateur {
  @override
  Future<serveur.Utilisateur?> verifier(String jeton) async =>
      const serveur.Utilisateur(id: 'a', nom: 'a', roles: {'agent'});
}
