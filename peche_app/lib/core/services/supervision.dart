import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'administration.dart';

/// Une saisie reçue par le serveur (résumé pour les listes).
class SaisieRecue {
  const SaisieRecue({
    required this.id,
    required this.navireId,
    required this.date,
    required this.nbInfractions,
    required this.recuLe,
    this.envoyePar,
  });

  factory SaisieRecue.depuisJson(Map<String, Object?> j) => SaisieRecue(
        id: j['id']! as String,
        navireId: j['navire_id']! as String,
        date: DateTime.parse(j['date']! as String).toLocal(),
        nbInfractions: j['nb_infractions']! as int,
        recuLe: DateTime.parse(j['recu_le']! as String).toLocal(),
        envoyePar: j['envoye_par'] as String?,
      );

  final String id;
  final String navireId;
  final DateTime date;
  final int nbInfractions;
  final DateTime recuLe;
  final String? envoyePar;
}

/// Consultation des saisies reçues par le serveur (rôle `superviseur`) :
/// statistiques, listes, rapports PDF signés.
class ApiSupervision {
  ApiSupervision(Uri base, {http.Client? client, this.jeton})
      : base = base.path.endsWith('/')
            ? base
            : base.replace(path: '${base.path}/'),
        _client = client ?? http.Client();

  final Uri base;
  final http.Client _client;
  final Future<String?> Function()? jeton;

  /// `{"declarations": n, "controles": n}`
  Future<Map<String, int>> statistiques() async => {
        for (final MapEntry(:key, :value)
            in (jsonDecode(utf8.decode(await _get('v1/statistiques'))) as Map)
                .entries)
          '$key': value as int,
      };

  /// [type] : `declarations` ou `controles`.
  Future<List<SaisieRecue>> lister(String type, {int limite = 100}) async => [
        for (final j
            in jsonDecode(utf8.decode(await _get('v1/$type?limite=$limite')))
                as List)
          SaisieRecue.depuisJson((j as Map).cast<String, Object?>()),
      ];

  Future<Uint8List> rapportPdf(String controleId) =>
      _get('v1/controles/${Uri.encodeComponent(controleId)}/rapport.pdf');

  Future<Uint8List> _get(String chemin) async {
    final cle = await jeton?.call();
    final http.Response r;
    try {
      r = await _client.get(base.resolve(chemin), headers: {
        if (cle != null) 'Authorization': 'Bearer $cle',
      }).timeout(const Duration(seconds: 30));
    } catch (e) {
      throw ErreurAdministration('Réseau indisponible ($e)');
    }
    if (r.statusCode != 200) {
      String message = 'HTTP ${r.statusCode}';
      try {
        final j = jsonDecode(utf8.decode(r.bodyBytes));
        if (j is Map && j['message'] is String) message = j['message'];
      } on FormatException {
        // corps non JSON : on garde le code HTTP
      }
      throw ErreurAdministration(message);
    }
    return r.bodyBytes;
  }
}
