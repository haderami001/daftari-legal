import 'dart:convert';

import 'package:http/http.dart' as http;

/// Refus ou panne lors d'une opération d'administration.
class ErreurAdministration implements Exception {
  const ErreurAdministration(this.message, {this.details = const []});

  final String message;

  /// Erreurs champ par champ renvoyées par le serveur (HTTP 400).
  final List<String> details;

  @override
  String toString() =>
      details.isEmpty ? message : '$message\n${details.join('\n')}';
}

/// Résultat d'un enregistrement : nouveau (201) ou modifié (200).
enum Ecriture { cree, modifie }

/// Gestion du référentiel central (navires, licences) par l'administrateur.
///
/// Contrairement aux saisies, ces opérations se font **en ligne** : le
/// serveur est la seule source de vérité, et il vérifie chaque champ.
class ApiAdministration {
  ApiAdministration(Uri base, {http.Client? client, this.jeton})
      : base = base.path.endsWith('/')
            ? base
            : base.replace(path: '${base.path}/'),
        _client = client ?? http.Client();

  final Uri base;
  final http.Client _client;
  final Future<String?> Function()? jeton;

  /// Référentiel complet, tel qu'il est sur le serveur.
  Future<Map<String, Object?>> referentiel() async {
    final r = await _appeler((entetes) =>
        _client.get(base.resolve('v1/referentiel'), headers: entetes));
    return _json(r) as Map<String, Object?>;
  }

  Future<Ecriture> enregistrerNavire(String id, Map<String, Object?> navire) =>
      _put('v1/navires/${Uri.encodeComponent(id)}', navire);

  Future<Ecriture> enregistrerLicence(
          String numero, Map<String, Object?> licence) =>
      _put('v1/licences/${Uri.encodeComponent(numero)}', licence);

  /// Suppression logique : l'élément disparaît des listes et des
  /// téléphones ; les saisies passées le gardent.
  Future<void> supprimerNavire(String id) => _appeler((entetes) =>
      _client.delete(base.resolve('v1/navires/${Uri.encodeComponent(id)}'),
          headers: entetes));

  Future<void> supprimerLicence(String numero) => _appeler((entetes) =>
      _client.delete(base.resolve('v1/licences/${Uri.encodeComponent(numero)}'),
          headers: entetes));

  Future<Ecriture> _put(String chemin, Map<String, Object?> corps) async {
    final r = await _appeler((entetes) => _client.put(base.resolve(chemin),
        headers: {...entetes, 'Content-Type': 'application/json'},
        body: jsonEncode(corps)));
    return r.statusCode == 201 ? Ecriture.cree : Ecriture.modifie;
  }

  Future<http.Response> _appeler(
      Future<http.Response> Function(Map<String, String>) requete) async {
    final cle = await jeton?.call();
    final http.Response r;
    try {
      r = await requete({if (cle != null) 'Authorization': 'Bearer $cle'})
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      throw ErreurAdministration('Réseau indisponible ($e)');
    }
    if (r.statusCode == 200 || r.statusCode == 201) return r;
    // Message du serveur : {"erreur", "message", "details"?}
    final Object? corps;
    try {
      corps = _json(r);
    } on FormatException {
      throw ErreurAdministration('Serveur : HTTP ${r.statusCode}');
    }
    if (corps is! Map) throw ErreurAdministration('HTTP ${r.statusCode}');
    throw ErreurAdministration(
      '${corps['message'] ?? 'HTTP ${r.statusCode}'}',
      details: [...(corps['details'] as List? ?? const []).map((d) => '$d')],
    );
  }

  Object? _json(http.Response r) => jsonDecode(utf8.decode(r.bodyBytes));
}
