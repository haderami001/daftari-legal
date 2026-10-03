import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:peche_app/core/data/base/base_de_donnees.dart';
import 'package:peche_app/core/services/position_service.dart';
import 'package:peche_app/core/services/services.dart';
import 'package:peche_app/core/services/session.dart';
import 'package:peche_app/main.dart';

/// Jeton au format Keycloak (non signé : l'app ne fait que le lire).
String faux(String login, List<String> roles) {
  String b64(Object o) =>
      base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
  return '${b64({'alg': 'RS256'})}.${b64({
        'preferred_username': login,
        'name': 'Nom de $login',
        'realm_access': {'roles': roles},
      })}.signature';
}

final emetteur = Uri.parse('https://auth.test/realms/peche');

/// Faux Keycloak : agent.demo / bon-mot-de-passe.
MockClient fauxKeycloak({List<Map<String, String>>? journal}) =>
    MockClient((req) async {
      final f = req.bodyFields;
      journal?.add(f);
      if (req.url.path.endsWith('/logout')) return http.Response('', 204);
      final ok = (f['grant_type'] == 'password' &&
              f['username'] == 'agent.demo' &&
              f['password'] == 'bon-mot-de-passe') ||
          (f['grant_type'] == 'refresh_token' && f['refresh_token'] == 'r1');
      if (!ok) return http.Response('{"error":"invalid_grant"}', 400);
      return http.Response(
          jsonEncode({
            'access_token': faux('agent.demo', ['agent']),
            'refresh_token': 'r1',
            'expires_in': 300,
          }),
          200);
    });

void main() {
  group('SessionKeycloak', () {
    test('connexion : profil et rôles, jetons gardés dans le coffre', () async {
      final coffre = CoffreMemoire();
      final s = SessionKeycloak(
          emetteur: emetteur, coffre: coffre, client: fauxKeycloak());
      await s.connecter('agent.demo', 'bon-mot-de-passe');

      expect(s.profil!.identifiant, 'agent.demo');
      expect(s.profil!.nomComplet, 'Nom de agent.demo');
      expect(s.profil!.peutControler, isTrue);
      expect(s.profil!.peutDeclarer, isFalse);
      expect(coffre.valeur, contains('r1'));

      // Relance de l'application, sans réseau : la session revient.
      final relance = SessionKeycloak(
          emetteur: emetteur,
          coffre: coffre,
          client: MockClient((_) => throw const SocketException('hors ligne')));
      await relance.restaurer();
      expect(relance.profil!.identifiant, 'agent.demo');
    });

    test('mauvais mot de passe / pas de réseau : erreurs distinctes', () async {
      final s = SessionKeycloak(
          emetteur: emetteur, coffre: CoffreMemoire(), client: fauxKeycloak());
      await expectLater(
          s.connecter('agent.demo', 'faux'),
          throwsA(isA<ExceptionConnexion>().having(
              (e) => e.erreur, 'erreur', ErreurConnexion.identifiants)));

      final horsLigne = SessionKeycloak(
          emetteur: emetteur,
          coffre: CoffreMemoire(),
          client: MockClient((_) => throw const SocketException('x')));
      await expectLater(
          horsLigne.connecter('agent.demo', 'bon-mot-de-passe'),
          throwsA(isA<ExceptionConnexion>()
              .having((e) => e.erreur, 'erreur', ErreurConnexion.reseau)));
    });

    test('jeton expiré : renouvelé automatiquement', () async {
      var maintenant = DateTime(2026, 10, 3, 8);
      final journal = <Map<String, String>>[];
      final s = SessionKeycloak(
          emetteur: emetteur,
          coffre: CoffreMemoire(),
          client: fauxKeycloak(journal: journal),
          horloge: () => maintenant);
      await s.connecter('agent.demo', 'bon-mot-de-passe');
      await s.jetonAcces();
      expect(journal, hasLength(1)); // encore valide

      maintenant = maintenant.add(const Duration(minutes: 10));
      await s.jetonAcces();
      expect(journal.last['grant_type'], 'refresh_token');
    });

    test('session révoquée : déconnexion et SessionExpiree', () async {
      final coffre = CoffreMemoire()
        ..valeur = jsonEncode({
          'acces': faux('agent.demo', ['agent']),
          'renouvellement': 'revoque',
          'expiration': DateTime(2000).toIso8601String(),
        });
      final s = SessionKeycloak(
          emetteur: emetteur, coffre: coffre, client: fauxKeycloak());
      await s.restaurer();
      await expectLater(s.jetonAcces(), throwsA(isA<SessionExpiree>()));
      expect(s.profil, isNull);
      expect(coffre.valeur, isNull);
    });
  });

  group('écrans', () {
    Future<void> lancer(WidgetTester tester, Session session) async {
      tester.view.physicalSize = const Size(1080, 2400);
      addTearDown(tester.view.reset);
      final base = BaseDeDonnees.avec(NativeDatabase.memory());
      addTearDown(base.close);
      await tester.pumpWidget(PecheApp(
          services: Services(base,
              position: const PositionFixe(20, -17), session: session)));
      await tester.pumpAndSettle();
    }

    testWidgets('connexion puis accueil selon le rôle (agent)', (tester) async {
      final session = SessionKeycloak(
          emetteur: emetteur, coffre: CoffreMemoire(), client: fauxKeycloak());
      await lancer(tester, session);
      expect(find.text('Se connecter'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'agent.demo');
      await tester.enterText(find.byType(TextField).at(1), 'faux');
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();
      expect(
          find.text('Identifiant ou mot de passe incorrect.'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(1), 'bon-mot-de-passe');
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      // Agent : contrôle oui, déclaration non.
      expect(find.text('Contrôle garde-côtes'), findsOneWidget);
      expect(find.text('Déclaration du capitaine'), findsNothing);

      // Déconnexion : retour à l'écran de connexion.
      await tester.tap(find.byTooltip('Compte'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Se déconnecter'));
      await tester.pumpAndSettle();
      expect(find.text('Se connecter'), findsOneWidget);
    });

    testWidgets('mode démonstration : pas de connexion, tous les modules',
        (tester) async {
      await lancer(tester, SessionDemo());
      expect(find.text('Se connecter'), findsNothing);
      expect(find.text('Déclaration du capitaine'), findsOneWidget);
      expect(find.text('Contrôle garde-côtes'), findsOneWidget);
    });
  });
}
