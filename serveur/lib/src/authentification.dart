import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/api.dart' as pc;

/// Rôles des comptes (définis dans Keycloak : keycloak/realm-peche.json).
abstract final class Roles {
  static const capitaine = 'capitaine';
  static const agent = 'agent';
  static const superviseur = 'superviseur';
  static const admin = 'admin';

  static const tous = {capitaine, agent, superviseur, admin};
}

/// Personne authentifiée qui appelle l'API.
class Utilisateur {
  const Utilisateur({
    required this.id,
    required this.nom,
    required this.roles,
  });

  /// Identifiant stable (`sub` du jeton Keycloak).
  final String id;

  /// Nom lisible (identifiant de connexion), conservé avec chaque saisie.
  final String nom;
  final Set<String> roles;

  /// L'administrateur a tous les droits.
  bool a(String role) => roles.contains(role) || roles.contains(Roles.admin);
}

/// Vérifie le jeton reçu dans `Authorization: Bearer <jeton>`.
abstract class Authentificateur {
  /// Renvoie l'utilisateur, ou `null` si le jeton est absent ou invalide.
  Future<Utilisateur?> verifier(String jeton);
}

/// Mode développement : un secret partagé donne tous les droits.
/// À n'utiliser qu'en local ou pour les tests.
class AuthJetonPartage implements Authentificateur {
  AuthJetonPartage(this._secret);

  final String _secret;

  @override
  Future<Utilisateur?> verifier(String jeton) async =>
      egaliteConstante(jeton, _secret)
          ? const Utilisateur(
              id: 'jeton-partage', nom: 'jeton-partage', roles: Roles.tous)
          : null;
}

/// Comparaison en temps constant (ne révèle pas le secret par la durée).
bool egaliteConstante(String a, String b) {
  final x = utf8.encode(a), y = utf8.encode(b);
  var diff = x.length ^ y.length;
  for (var i = 0; i < x.length && i < y.length; i++) {
    diff |= x[i] ^ y[i];
  }
  return diff == 0;
}

/// Fournit les clés publiques de Keycloak, indexées par `kid`.
abstract class SourceCles {
  Future<Map<String, RSAPublicKey>> charger();
}

/// Clés publiées par Keycloak (JWKS) :
/// `{issuer}/protocol/openid-connect/certs`.
class ClesJwks implements SourceCles {
  ClesJwks(this.url, {http.Client? client}) : _client = client ?? http.Client();

  final Uri url;
  final http.Client _client;

  @override
  Future<Map<String, RSAPublicKey>> charger() async {
    final rep = await _client.get(url).timeout(const Duration(seconds: 10));
    if (rep.statusCode != 200) {
      throw StateError('JWKS indisponible ($url) : HTTP ${rep.statusCode}');
    }
    return clesDepuisJwks(jsonDecode(rep.body) as Map<String, Object?>);
  }
}

/// Lit un document JWKS et garde les clés RSA de signature.
Map<String, RSAPublicKey> clesDepuisJwks(Map<String, Object?> jwks) => {
      for (final cle in (jwks['keys'] as List? ?? []).cast<Map>())
        if (cle['kty'] == 'RSA' &&
            (cle['use'] == null || cle['use'] == 'sig') &&
            cle['kid'] is String)
          cle['kid'] as String: RSAPublicKey.raw(pc.RSAPublicKey(
            _entier(cle['n'] as String),
            _entier(cle['e'] as String),
          )),
    };

/// Entier positif encodé en base64url (format des clés JWK).
BigInt _entier(String valeur) {
  final octets = base64Url.decode(base64Url.normalize(valeur));
  var n = BigInt.zero;
  for (final o in octets) {
    n = (n << 8) | BigInt.from(o);
  }
  return n;
}

/// Vérifie les jetons d'accès émis par Keycloak (OpenID Connect).
///
/// Contrôles : algorithme RS256 uniquement, signature avec une clé publiée
/// par Keycloak, émetteur (`iss`), destinataire (`aud` = cette API),
/// expiration (`exp`) et date de début (`nbf`).
class AuthOidc implements Authentificateur {
  AuthOidc({
    required this.emetteur,
    required this.audience,
    required this.cles,
    this.delaiRechargement = const Duration(minutes: 1),
  });

  /// Valeur attendue de `iss`, ex. `https://auth.peche.mr/realms/peche`.
  final String emetteur;

  /// Valeur attendue dans `aud`, ex. `peche-api`.
  final String audience;
  final SourceCles cles;

  /// Délai minimal entre deux rechargements des clés (rotation des clés).
  final Duration delaiRechargement;

  Map<String, RSAPublicKey> _cles = {};
  DateTime? _dernierChargement;

  @override
  Future<Utilisateur?> verifier(String jeton) async {
    final Map<String, Object?> entete;
    try {
      entete = jsonDecode(utf8.decode(
              base64Url.decode(base64Url.normalize(jeton.split('.').first))))
          as Map<String, Object?>;
    } catch (_) {
      return null;
    }
    // Refus explicite de tout autre algorithme (« none », HS256...).
    if (entete['alg'] != 'RS256' || entete['kid'] is! String) return null;

    final cle = await _cle(entete['kid']! as String);
    if (cle == null) return null;

    final JWT jwt;
    try {
      jwt = JWT.verify(jeton, cle, issuer: emetteur);
    } on JWTException {
      return null; // signature, expiration, émetteur...
    }
    final p = jwt.payload;
    if (p is! Map) return null;

    final aud = p['aud'];
    final audiences = aud is List ? aud : [aud];
    if (!audiences.contains(audience)) return null;
    if (p['exp'] is! int) return null; // jeton sans expiration : refusé

    final roles = ((p['realm_access'] as Map?)?['roles'] as List? ?? [])
        .whereType<String>()
        .where(Roles.tous.contains)
        .toSet();
    return Utilisateur(
      id: '${p['sub']}',
      nom: '${p['preferred_username'] ?? p['sub']}',
      roles: roles,
    );
  }

  Future<RSAPublicKey?> _cle(String kid) async {
    final connue = _cles[kid];
    if (connue != null) return connue;
    // Clé inconnue : Keycloak a peut-être changé de clé. On recharge, mais
    // pas plus d'une fois par [delaiRechargement] (protection contre un
    // flot de faux jetons).
    final maintenant = DateTime.now();
    final dernier = _dernierChargement;
    if (dernier != null && maintenant.difference(dernier) < delaiRechargement) {
      return null;
    }
    _dernierChargement = maintenant;
    _cles = await cles.charger();
    return _cles[kid];
  }
}
