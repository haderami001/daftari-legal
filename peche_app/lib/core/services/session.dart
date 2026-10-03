import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// Compte connecté (lu dans le jeton Keycloak).
class Profil {
  const Profil({
    required this.identifiant,
    required this.nomComplet,
    required this.roles,
  });

  final String identifiant;
  final String nomComplet;
  final Set<String> roles;

  bool _a(String r) => roles.contains(r) || roles.contains('admin');
  bool get peutDeclarer => _a('capitaine');
  bool get peutControler => _a('agent');

  /// Consultation des saisies reçues par le serveur.
  bool get peutSuperviser => _a('superviseur');

  /// Gestion du référentiel central (navires, licences).
  bool get peutAdministrer => roles.contains('admin');

  /// Profil du mode démonstration (sans Keycloak) : tous les modules.
  static const demo = Profil(
      identifiant: 'demo', nomComplet: 'Agent GCM-0427', roles: {'admin'});

  static Profil depuisJeton(String jetonAcces) {
    final p = jsonDecode(utf8.decode(
            base64Url.decode(base64Url.normalize(jetonAcces.split('.')[1]))))
        as Map;
    final roles = ((p['realm_access'] as Map?)?['roles'] as List? ?? [])
        .whereType<String>()
        .toSet();
    final login = '${p['preferred_username'] ?? p['sub']}';
    return Profil(
      identifiant: login,
      nomComplet: '${p['name'] ?? login}',
      roles: roles,
    );
  }
}

/// Erreurs de connexion, affichées à l'utilisateur.
enum ErreurConnexion { identifiants, reseau, serveur }

class ExceptionConnexion implements Exception {
  const ExceptionConnexion(this.erreur);
  final ErreurConnexion erreur;
}

/// Session expirée ou révoquée : il faut se reconnecter.
class SessionExpiree implements Exception {
  @override
  String toString() => 'Session expirée : reconnectez-vous';
}

/// Où sont gardés les jetons (chiffrés sur le téléphone).
abstract class CoffreJetons {
  Future<String?> lire();
  Future<void> ecrire(String? valeur);
}

class CoffreSecurise implements CoffreJetons {
  static const _cle = 'session_keycloak';
  final _stockage = const FlutterSecureStorage();

  @override
  Future<String?> lire() => _stockage.read(key: _cle);

  @override
  Future<void> ecrire(String? valeur) => valeur == null
      ? _stockage.delete(key: _cle)
      : _stockage.write(key: _cle, value: valeur);
}

class CoffreMemoire implements CoffreJetons {
  String? valeur;
  @override
  Future<String?> lire() async => valeur;
  @override
  Future<void> ecrire(String? v) async => valeur = v;
}

/// Session de l'utilisateur. Les écrans écoutent ses changements
/// (connexion, déconnexion).
abstract class Session extends ChangeNotifier {
  /// `false` = mode démonstration, pas d'écran de connexion.
  bool get exigeConnexion;
  Profil? get profil;
  Future<void> restaurer();
  Future<void> connecter(String identifiant, String motDePasse);
  Future<void> deconnecter();

  /// Jeton d'accès valide pour l'API (renouvelé si besoin), ou `null`.
  Future<String?> jetonAcces();
}

/// Sans Keycloak : profil de démonstration, jeton partagé optionnel.
class SessionDemo extends Session {
  SessionDemo({this.jetonPartage});
  final String? jetonPartage;

  @override
  bool get exigeConnexion => false;
  @override
  Profil? get profil => Profil.demo;
  @override
  Future<void> restaurer() async {}
  @override
  Future<void> connecter(String identifiant, String motDePasse) async {}
  @override
  Future<void> deconnecter() async {}
  @override
  Future<String?> jetonAcces() async => jetonPartage;
}

/// Comptes Keycloak (OpenID Connect).
///
/// Connexion par identifiant et mot de passe (« direct grant »), avec le
/// scope `offline_access` : le jeton de renouvellement reste valable
/// 30 jours sans réseau, l'agent peut donc travailler en mer et envoyer au
/// retour. Évolution recommandée : connexion par le navigateur
/// (Authorization Code + PKCE, déjà autorisée dans keycloak/realm-peche.json).
class SessionKeycloak extends Session {
  SessionKeycloak({
    required this.emetteur,
    this.clientId = 'peche-app',
    CoffreJetons? coffre,
    http.Client? client,
    DateTime Function()? horloge,
  })  : _coffre = coffre ?? CoffreSecurise(),
        _client = client ?? http.Client(),
        _horloge = horloge ?? DateTime.now;

  /// `https://auth.exemple.mr/realms/peche`
  final Uri emetteur;
  final String clientId;
  final CoffreJetons _coffre;
  final http.Client _client;
  final DateTime Function() _horloge;

  String? _acces;
  String? _renouvellement;
  DateTime? _expiration;
  Profil? _profil;

  Uri get _urlJetons => Uri.parse('$emetteur/protocol/openid-connect/token');

  @override
  bool get exigeConnexion => true;
  @override
  Profil? get profil => _profil;

  @override
  Future<void> restaurer() async {
    final brut = await _coffre.lire();
    if (brut == null) return;
    final d = jsonDecode(brut) as Map;
    _acces = d['acces'] as String;
    _renouvellement = d['renouvellement'] as String;
    _expiration = DateTime.parse(d['expiration'] as String);
    _profil = Profil.depuisJeton(_acces!);
    notifyListeners();
  }

  @override
  Future<void> connecter(String identifiant, String motDePasse) async {
    await _demanderJetons({
      'grant_type': 'password',
      'username': identifiant,
      'password': motDePasse,
      'scope': 'openid offline_access',
    }, connexion: true);
    notifyListeners();
  }

  @override
  Future<String?> jetonAcces() async {
    if (_renouvellement == null) throw SessionExpiree();
    final reste = _expiration!.difference(_horloge());
    if (reste > const Duration(seconds: 30)) return _acces;
    await _demanderJetons({
      'grant_type': 'refresh_token',
      'refresh_token': _renouvellement!,
    });
    return _acces;
  }

  @override
  Future<void> deconnecter() async {
    final r = _renouvellement;
    _acces = _renouvellement = _expiration = _profil = null;
    await _coffre.ecrire(null);
    notifyListeners();
    if (r != null) {
      // Révocation côté Keycloak (au mieux : peut échouer hors réseau).
      try {
        await _client.post(
            Uri.parse('$emetteur/protocol/openid-connect/logout'),
            body: {'client_id': clientId, 'refresh_token': r});
      } catch (_) {}
    }
  }

  Future<void> _demanderJetons(Map<String, String> corps,
      {bool connexion = false}) async {
    final http.Response rep;
    try {
      rep = await _client.post(_urlJetons, body: {
        'client_id': clientId,
        ...corps
      }).timeout(const Duration(seconds: 20));
    } catch (_) {
      if (connexion) {
        throw const ExceptionConnexion(ErreurConnexion.reseau);
      }
      rethrow; // la synchronisation réessaiera plus tard
    }
    if (rep.statusCode == 400 || rep.statusCode == 401) {
      if (connexion) {
        throw const ExceptionConnexion(ErreurConnexion.identifiants);
      }
      // Jeton de renouvellement expiré ou révoqué.
      await deconnecter();
      throw SessionExpiree();
    }
    if (rep.statusCode != 200) {
      if (connexion) throw const ExceptionConnexion(ErreurConnexion.serveur);
      throw StateError('Keycloak : HTTP ${rep.statusCode}');
    }
    final d = jsonDecode(rep.body) as Map;
    _acces = d['access_token'] as String;
    _renouvellement = d['refresh_token'] as String;
    _expiration =
        _horloge().add(Duration(seconds: (d['expires_in'] as num).toInt()));
    _profil = Profil.depuisJeton(_acces!);
    await _coffre.ecrire(jsonEncode({
      'acces': _acces,
      'renouvellement': _renouvellement,
      'expiration': _expiration!.toIso8601String(),
    }));
  }
}
