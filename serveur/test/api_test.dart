import 'dart:convert';

import 'package:serveur_peche/serveur_peche.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'exemples.dart';

void main() {
  late Handler api;

  setUp(() {
    api = construireApi(stockage: StockageMemoire(), jeton: jetonTest);
  });

  Future<(int, Object?)> appeler(
    String methode,
    String chemin, {
    Object? corps,
    String? jeton = jetonTest,
    Map<String, String> entetes = const {},
  }) async {
    final rep = await api(Request(
      methode,
      Uri.parse('http://localhost$chemin'),
      body:
          corps is String ? corps : (corps == null ? null : jsonEncode(corps)),
      headers: {
        if (corps != null) 'content-type': 'application/json',
        if (jeton != null) 'authorization': 'Bearer $jeton',
        ...entetes,
      },
    ));
    final texte = await rep.readAsString();
    final estJson = rep.headers['content-type']?.contains('json') ?? false;
    return (rep.statusCode, estJson ? jsonDecode(texte) : texte);
  }

  test('santé : accessible sans jeton', () async {
    final (code, corps) = await appeler('GET', '/v1/sante', jeton: null);
    expect(code, 200);
    expect((corps! as Map)['statut'], 'ok');
  });

  group('authentification', () {
    test('sans jeton : 401', () async {
      final (code, _) = await appeler(
          'POST', '/v1/sync/declarations/$idDeclaration',
          corps: declaration(), jeton: null);
      expect(code, 401);
    });

    test('mauvais jeton : 401', () async {
      final (code, _) = await appeler('GET', '/v1/statistiques',
          jeton: 'mauvais-jeton-1234567890');
      expect(code, 401);
    });
  });

  group('réception idempotente', () {
    test('déclaration : 201, puis renvoi identique 200, puis conflit 409',
        () async {
      const chemin = '/v1/sync/declarations/$idDeclaration';

      final (c1, r1) = await appeler('POST', chemin, corps: declaration());
      expect((c1, (r1! as Map)['statut']), (201, 'cree'));

      // Le téléphone renvoie (réseau coupé avant la réponse) : pas de doublon.
      final (c2, r2) = await appeler('POST', chemin, corps: declaration());
      expect((c2, (r2! as Map)['statut']), (200, 'deja_recu'));

      // Même identifiant, contenu différent : refusé.
      final modifiee = declaration()..['nb_infractions'] = 3;
      final (c3, r3) = await appeler('POST', chemin, corps: modifiee);
      expect((c3, (r3! as Map)['erreur']), (409, 'conflit'));

      final (_, stats) = await appeler('GET', '/v1/statistiques');
      expect(stats, {'declarations': 1, 'controles': 0});
    });

    test("l'ordre des champs n'empêche pas de reconnaître un renvoi", () async {
      const chemin = '/v1/sync/declarations/$idDeclaration';
      await appeler('POST', chemin, corps: declaration());
      final inverse = Map.fromEntries(declaration().entries.toList().reversed);
      final (code, _) = await appeler('POST', chemin, corps: inverse);
      expect(code, 200);
    });

    test('contrôle avec PDF : enregistré, PDF téléchargeable', () async {
      final (code, _) = await appeler('POST', '/v1/sync/controles/$idControle',
          corps: controle());
      expect(code, 201);

      final rep = await api(Request('GET',
          Uri.parse('http://localhost/v1/controles/$idControle/rapport.pdf'),
          headers: {'authorization': 'Bearer $jetonTest'}));
      expect(rep.statusCode, 200);
      expect(rep.headers['content-type'], 'application/pdf');
      expect(await rep.read().expand((o) => o).toList(), pdfMinimal);

      final (_, liste) = await appeler('GET', '/v1/controles');
      expect((liste! as List).single, containsPair('nb_infractions', 2));
    });
  });

  group('validation', () {
    test('erreurs détaillées', () async {
      final d = declaration()
        ..['engin'] = 'dynamite'
        ..['captures'] = [
          {'espece': 'poulpe', 'poids_kg': -3},
        ]
        ..['position'] = {'lat': 120, 'lon': -17};
      final (code, corps) = await appeler(
          'POST', '/v1/sync/declarations/$idDeclaration',
          corps: d);
      expect(code, 400);
      expect((corps! as Map)['details'], [
        'engin : valeur inconnue (dynamite)',
        'position.lat : entre -90 et 90',
        'captures[0].espece : code FAO à 3 lettres attendu',
        'captures[0].poids_kg : doit être > 0',
      ]);
    });

    test("l'identifiant doit être un UUID identique à celui de l'URL",
        () async {
      final (c1, r1) = await appeler('POST', '/v1/sync/declarations/123',
          corps: declaration());
      expect(c1, 400);
      expect((r1! as Map)['details'], contains('id : doit être un UUID'));

      final (c2, r2) = await appeler(
          'POST', '/v1/sync/declarations/$idControle',
          corps: declaration());
      expect(c2, 400);
      expect((r2! as Map)['details'],
          contains("id : différent de celui de l'URL"));
    });

    test('PDF corrompu refusé', () async {
      final c = controle()..['rapport_pdf_base64'] = base64Encode([1, 2, 3]);
      final (code, corps) =
          await appeler('POST', '/v1/sync/controles/$idControle', corps: c);
      expect(code, 400);
      expect((corps! as Map)['details'],
          ["rapport_pdf_base64 : n'est pas un PDF"]);
    });

    test('JSON invalide, mauvais type de contenu, type inconnu', () async {
      final (c1, _) = await appeler(
          'POST', '/v1/sync/declarations/$idDeclaration',
          corps: '{pas du json');
      expect(c1, 400);

      final (c2, _) = await appeler(
          'POST', '/v1/sync/declarations/$idDeclaration',
          corps: declaration(), entetes: {'content-type': 'text/plain'});
      expect(c2, 415);

      final (c3, _) = await appeler('POST', '/v1/sync/navires/$idDeclaration',
          corps: declaration());
      expect(c3, 404);
    });
  });

  test('CORS : la version web peut appeler l\'API', () async {
    final rep = await api(Request(
        'OPTIONS', Uri.parse('http://localhost/v1/sync/controles/x'),
        headers: {'origin': 'https://app.exemple.mr'}));
    expect(rep.statusCode, 204);
    expect(rep.headers['access-control-allow-origin'], '*');
    expect(
        rep.headers['access-control-allow-headers'], contains('Authorization'));
  });
}
