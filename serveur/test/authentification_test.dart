import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/export.dart' as pc;
import 'package:serveur_peche/serveur_peche.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'exemples.dart';

const emetteur = 'https://auth.test/realms/peche';

/// Paire de clés RSA générée pour le test (comme celles de Keycloak).
pc.AsymmetricKeyPair<pc.RSAPublicKey, pc.RSAPrivateKey> genererCles() {
  final aleatoire = pc.FortunaRandom()
    ..seed(pc.KeyParameter(Uint8List.fromList(
        List.generate(32, (_) => Random.secure().nextInt(256)))));
  final generateur = pc.RSAKeyGenerator()
    ..init(pc.ParametersWithRandom(
        pc.RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 64), aleatoire));
  final paire = generateur.generateKeyPair();
  return pc.AsymmetricKeyPair(
      paire.publicKey as pc.RSAPublicKey, paire.privateKey as pc.RSAPrivateKey);
}

/// Source de clés en mémoire, qui compte les chargements.
class ClesFixes implements SourceCles {
  ClesFixes(this.cles);
  Map<String, RSAPublicKey> cles;
  int chargements = 0;

  @override
  Future<Map<String, RSAPublicKey>> charger() async {
    chargements++;
    return cles;
  }
}

void main() {
  final paire = genererCles();
  final autrePaire = genererCles();
  late ClesFixes cles;
  late AuthOidc auth;

  setUp(() {
    cles = ClesFixes({'cle-1': RSAPublicKey.raw(paire.publicKey)});
    auth = AuthOidc(emetteur: emetteur, audience: 'peche-api', cles: cles);
  });

  String jeton({
    Map<String, Object?> en = const {},
    String kid = 'cle-1',
    pc.RSAPrivateKey? cle,
    Duration expire = const Duration(minutes: 5),
  }) =>
      JWT(
        {
          'iss': emetteur,
          'aud': ['peche-api', 'account'],
          'sub': 'id-agent',
          'preferred_username': 'agent.demo',
          'realm_access': {
            'roles': ['agent', 'offline_access'],
          },
          ...en,
        },
        header: {'kid': kid},
      ).sign(RSAPrivateKey.raw(cle ?? paire.privateKey),
          algorithm: JWTAlgorithm.RS256, expiresIn: expire);

  test('jeton Keycloak valide : utilisateur et rôles', () async {
    final u = await auth.verifier(jeton());
    expect(u, isNotNull);
    expect(u!.id, 'id-agent');
    expect(u.nom, 'agent.demo');
    expect(u.roles, {'agent'}); // offline_access ignoré
    expect(u.a(Roles.agent), isTrue);
    expect(u.a(Roles.capitaine), isFalse);
  });

  group('jetons refusés', () {
    test('expiré', () async {
      expect(await auth.verifier(jeton(expire: const Duration(seconds: -10))),
          isNull);
    });

    test('mauvais émetteur', () async {
      expect(await auth.verifier(jeton(en: {'iss': 'https://pirate.test'})),
          isNull);
    });

    test('destiné à une autre application (aud)', () async {
      expect(
          await auth.verifier(jeton(en: {
            'aud': ['account'],
          })),
          isNull);
    });

    test('signé avec une autre clé', () async {
      expect(await auth.verifier(jeton(cle: autrePaire.privateKey)), isNull);
    });

    test('modifié après signature (rôle ajouté)', () async {
      final parties = jeton().split('.');
      final charge = jsonDecode(
              utf8.decode(base64Url.decode(base64Url.normalize(parties[1]))))
          as Map;
      charge['realm_access'] = {
        'roles': ['admin'],
      };
      final falsifie = [
        parties[0],
        base64Url.encode(utf8.encode(jsonEncode(charge))).replaceAll('=', ''),
        parties[2],
      ].join('.');
      expect(await auth.verifier(falsifie), isNull);
    });

    test('algorithme « none »', () async {
      String b64(Object o) =>
          base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
      final sansSignature = '${b64({'alg': 'none', 'kid': 'cle-1'})}.${b64({
            'iss': emetteur,
            'aud': 'peche-api',
            'sub': 'x',
            'exp': 9999999999,
            'realm_access': {
              'roles': ['admin'],
            },
          })}.';
      expect(await auth.verifier(sansSignature), isNull);
    });

    test('HS256 signé avec la clé publique (attaque classique)', () async {
      final hs = JWT({
        'iss': emetteur,
        'aud': 'peche-api',
        'sub': 'x',
        'realm_access': {
          'roles': ['admin'],
        },
      }, header: {
        'kid': 'cle-1'
      }).sign(SecretKey('n'), algorithm: JWTAlgorithm.HS256);
      expect(await auth.verifier(hs), isNull);
    });

    test('n\'importe quoi', () async {
      expect(await auth.verifier('abc'), isNull);
      expect(await auth.verifier(''), isNull);
    });
  });

  test('rotation des clés : une nouvelle clé est rechargée, avec limite',
      () async {
    expect(await auth.verifier(jeton()), isNotNull);
    expect(cles.chargements, 1);

    // Keycloak publie une nouvelle clé.
    cles.cles = {
      ...cles.cles,
      'cle-2': RSAPublicKey.raw(autrePaire.publicKey),
    };
    final auth2 = AuthOidc(
        emetteur: emetteur,
        audience: 'peche-api',
        cles: cles,
        delaiRechargement: const Duration(minutes: 1));
    expect(
        await auth2.verifier(jeton(kid: 'cle-2', cle: autrePaire.privateKey)),
        isNotNull);
    final avant = cles.chargements;

    // Un flot de jetons avec des clés inconnues ne déclenche aucun
    // rechargement pendant le délai minimal (1 minute).
    for (var i = 0; i < 5; i++) {
      expect(await auth2.verifier(jeton(kid: 'inconnue-$i')), isNull);
    }
    expect(cles.chargements, avant);
  });

  test('clesDepuisJwks lit le format de Keycloak', () {
    String b64Entier(BigInt n) {
      var hex = n.toRadixString(16);
      if (hex.length.isOdd) hex = '0$hex';
      final octets = [
        for (var i = 0; i < hex.length; i += 2)
          int.parse(hex.substring(i, i + 2), radix: 16),
      ];
      return base64Url.encode(octets).replaceAll('=', '');
    }

    final lues = clesDepuisJwks({
      'keys': [
        {
          'kid': 'k1',
          'kty': 'RSA',
          'alg': 'RS256',
          'use': 'sig',
          'n': b64Entier(paire.publicKey.modulus!),
          'e': b64Entier(paire.publicKey.exponent!),
        },
        {'kid': 'k2', 'kty': 'RSA', 'use': 'enc', 'n': 'AQ', 'e': 'AQAB'},
        {'kid': 'k3', 'kty': 'EC', 'crv': 'P-256'},
      ],
    });
    expect(lues.keys, ['k1']);
    expect((lues['k1']!.key).modulus, paire.publicKey.modulus);
  });

  group('API avec Keycloak', () {
    late Handler api;
    setUp(() {
      api = construireApi(stockage: StockageMemoire(), authentificateur: auth);
    });

    Future<Response> poster(String type, String id, Map<String, Object?> corps,
            String jeton) async =>
        await api(Request(
            'POST', Uri.parse('http://localhost/v1/sync/$type/$id'),
            body: jsonEncode(corps),
            headers: {
              'content-type': 'application/json',
              'authorization': 'Bearer $jeton',
            }));

    String jetonRole(String role, {String nom = 'compte.demo'}) => jeton(en: {
          'preferred_username': nom,
          'realm_access': {
            'roles': [role],
          },
        });

    test('un agent envoie un contrôle mais pas une déclaration', () async {
      final agent = jetonRole('agent');
      expect(
          (await poster('controles', idControle, controle(), agent)).statusCode,
          201);
      expect(
          (await poster('declarations', idDeclaration, declaration(), agent))
              .statusCode,
          403);
    });

    test('un capitaine envoie une déclaration mais pas un contrôle', () async {
      final capitaine = jetonRole('capitaine');
      expect(
          (await poster(
                  'declarations', idDeclaration, declaration(), capitaine))
              .statusCode,
          201);
      expect(
          (await poster('controles', idControle, controle(), capitaine))
              .statusCode,
          403);
    });

    test('seuls superviseur et admin consultent ; qui a envoyé est gardé',
        () async {
      await poster('controles', idControle, controle(),
          jetonRole('agent', nom: 'agent.demo'));
      Future<Response> lire(String jeton) async =>
          await api(Request('GET', Uri.parse('http://localhost/v1/controles'),
              headers: {'authorization': 'Bearer $jeton'}));

      expect((await lire(jetonRole('agent'))).statusCode, 403);
      final rep = await lire(jetonRole('superviseur'));
      expect(rep.statusCode, 200);
      final liste = jsonDecode(await rep.readAsString()) as List;
      expect(liste.single['envoye_par'], 'agent.demo');
      expect((await lire(jetonRole('admin'))).statusCode, 200);
    });

    test('/v1/moi renvoie le compte du jeton', () async {
      final rep = await api(Request('GET', Uri.parse('http://localhost/v1/moi'),
          headers: {'authorization': 'Bearer ${jetonRole('capitaine')}'}));
      expect(jsonDecode(await rep.readAsString()), {
        'id': 'id-agent',
        'nom': 'compte.demo',
        'roles': ['capitaine'],
      });
    });

    test('Keycloak injoignable : 503 (le téléphone réessaiera)', () async {
      final panne = construireApi(
        stockage: StockageMemoire(),
        authentificateur: AuthOidc(
            emetteur: emetteur, audience: 'peche-api', cles: _ClesEnPanne()),
      );
      final rep = await panne(Request(
          'GET', Uri.parse('http://localhost/v1/moi'),
          headers: {'authorization': 'Bearer ${jeton()}'}));
      expect(rep.statusCode, 503);
    });
  });

  // Avec un vrai Keycloak (CI, ou local) :
  //   KEYCLOAK_URL_TEST=http://localhost:8180 dart test
  final keycloak = Platform.environment['KEYCLOAK_URL_TEST'];
  group('vrai Keycloak', () {
    test('connexion des comptes de démo et vérification des jetons', () async {
      final emetteurReel = '$keycloak/realms/peche';
      final authReel = AuthOidc(
        emetteur: emetteurReel,
        audience: 'peche-api',
        cles:
            ClesJwks(Uri.parse('$emetteurReel/protocol/openid-connect/certs')),
      );
      for (final (compte, role) in [
        ('capitaine.demo', 'capitaine'),
        ('agent.demo', 'agent'),
        ('superviseur.demo', 'superviseur'),
        ('admin.demo', 'admin'),
      ]) {
        final rep = await http.post(
            Uri.parse('$emetteurReel/protocol/openid-connect/token'),
            body: {
              'grant_type': 'password',
              'client_id': 'peche-app',
              'username': compte,
              'password': 'Demo-Peche-2026',
            });
        expect(rep.statusCode, 200, reason: compte);
        final acces = (jsonDecode(rep.body) as Map)['access_token'] as String;
        final u = await authReel.verifier(acces);
        expect(u?.nom, compte);
        expect(u?.roles, {role});
      }
    });
  }, skip: keycloak == null ? 'KEYCLOAK_URL_TEST non défini' : false);
}

class _ClesEnPanne implements SourceCles {
  @override
  Future<Map<String, RSAPublicKey>> charger() =>
      Future.error(const SocketException('Keycloak injoignable'));
}
