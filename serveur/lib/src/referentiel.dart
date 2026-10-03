/// Référentiel central : navires (avec leurs certificats) et licences (avec
/// leurs quotas). L'administrateur le tient à jour sur le serveur ; les
/// téléphones le téléchargent pour travailler hors ligne.
///
/// Format JSON d'un navire (`PUT /v1/navires/{id}`) :
///
///     {"nom": "Imraguen 12", "immatriculation": "NDB-PA-1234",
///      "pavillon": "MRT", "type": "pirogue", "longueur_m": 14,
///      "puissance_kw": 30, "numero_imo": null,
///      "certificats": [{"type": "navigabilite", "numero": "NAV-1",
///                       "date_expiration": "2027-03-31"}]}
///
/// Format JSON d'une licence (`PUT /v1/licences/{numero}`) :
///
///     {"navire_id": "N1", "segment": "artisanale",
///      "engins_autorises": ["casier"], "especes_cibles": ["OCC"],
///      "date_debut": "2026-01-01", "date_fin": "2026-12-31",
///      "quotas_kg": {"OCC": 3000}}
library;

import 'validation.dart';

/// Valeurs connues de l'application (noms des enums Flutter).
const typesNavire = {'pirogue', 'chalutier', 'senneur', 'dragueur'};
const typesCertificat = {'navigabilite', 'jaugeage', 'hygiene', 'radio'};
const segmentsPeche = {'artisanale', 'cotiere', 'hauturiere'};

final _identifiant = RegExp(r'^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$');
final _pavillon = RegExp(r'^[A-Z]{3}$');
final _codeFao = RegExp(r'^[A-Z]{3}$');

/// Identifiant de navire ou numéro de licence acceptable dans une URL.
bool estIdentifiant(String s) => _identifiant.hasMatch(s);

/// Résultat d'un enregistrement dans le référentiel.
enum EcritureReferentiel {
  cree,
  modifie,

  /// Licence d'un navire absent du référentiel.
  navireInconnu,

  /// Immatriculation déjà utilisée par un autre navire.
  immatriculationEnDouble,
}

/// Vérifie un navire ; renvoie la liste des erreurs (vide = valide).
List<String> verifierNavire(String id, Map<String, Object?> d) {
  final e = <String>[];
  if (!estIdentifiant(id)) e.add('id : lettres, chiffres, « . _ - »');
  _texte(e, d, 'nom');
  _texte(e, d, 'immatriculation');
  final p = d['pavillon'];
  if (p is! String || !_pavillon.hasMatch(p)) {
    e.add('pavillon : code pays à 3 lettres (ex. MRT)');
  }
  _choix(e, d, 'type', typesNavire);
  _positif(e, d, 'longueur_m');
  _positif(e, d, 'puissance_kw');
  final imo = d['numero_imo'];
  if (imo != null && (imo is! String || !RegExp(r'^\d{7}$').hasMatch(imo))) {
    e.add('numero_imo : 7 chiffres ou null');
  }
  final certificats = d['certificats'] ?? const [];
  if (certificats is! List) {
    e.add('certificats : liste attendue');
  } else {
    for (final (i, c) in certificats.indexed) {
      if (c is! Map) {
        e.add('certificats[$i] : objet attendu');
        continue;
      }
      final m = c.cast<String, Object?>();
      _choix(e, m, 'type', typesCertificat, chemin: 'certificats[$i]');
      _texte(e, m, 'numero', chemin: 'certificats[$i]');
      _date(e, m, 'date_expiration', chemin: 'certificats[$i]');
    }
  }
  return e;
}

/// Vérifie une licence ; renvoie la liste des erreurs (vide = valide).
List<String> verifierLicence(String numero, Map<String, Object?> d) {
  final e = <String>[];
  if (!estIdentifiant(numero)) e.add('numero : lettres, chiffres, « . _ - »');
  _texte(e, d, 'navire_id');
  _choix(e, d, 'segment', segmentsPeche);
  final engins = d['engins_autorises'];
  if (engins is! List ||
      engins.isEmpty ||
      engins.any((x) => !enginsConnus.contains(x))) {
    e.add('engins_autorises : liste non vide d\'engins connus');
  }
  final especes = d['especes_cibles'];
  if (especes is! List ||
      especes.any((x) => x is! String || !_codeFao.hasMatch(x))) {
    e.add('especes_cibles : liste de codes FAO à 3 lettres');
  }
  _date(e, d, 'date_debut');
  _date(e, d, 'date_fin');
  final debut = DateTime.tryParse('${d['date_debut']}');
  final fin = DateTime.tryParse('${d['date_fin']}');
  if (debut != null && fin != null && fin.isBefore(debut)) {
    e.add('date_fin : antérieure à date_debut');
  }
  final quotas = d['quotas_kg'] ?? const {};
  if (quotas is! Map ||
      quotas.entries.any((q) =>
          q.key is! String ||
          !_codeFao.hasMatch(q.key as String) ||
          q.value is! num ||
          (q.value as num) < 0)) {
    e.add('quotas_kg : {"CODE": kg ≥ 0}');
  }
  return e;
}

/// Forme canonique (champs connus seulement, valeurs par défaut) avant
/// enregistrement.
Map<String, Object?> navireNormalise(String id, Map<String, Object?> d) => {
      'id': id,
      'nom': (d['nom']! as String).trim(),
      'immatriculation': (d['immatriculation']! as String).trim(),
      'pavillon': d['pavillon'],
      'type': d['type'],
      'longueur_m': (d['longueur_m']! as num).toDouble(),
      'puissance_kw': (d['puissance_kw']! as num).toDouble(),
      'numero_imo': d['numero_imo'],
      'certificats': [
        for (final c in (d['certificats'] ?? const []) as List)
          {
            'type': (c as Map)['type'],
            'numero': c['numero'],
            'date_expiration': _jour(c['date_expiration']! as String),
          },
      ],
    };

Map<String, Object?> licenceNormalisee(String numero, Map<String, Object?> d) =>
    {
      'numero': numero,
      'navire_id': d['navire_id'],
      'segment': d['segment'],
      'engins_autorises': [...(d['engins_autorises']! as List)],
      'especes_cibles': [...(d['especes_cibles']! as List)],
      'date_debut': _jour(d['date_debut']! as String),
      'date_fin': _jour(d['date_fin']! as String),
      'quotas_kg': {
        for (final q in ((d['quotas_kg'] ?? const {}) as Map).entries)
          q.key as String: (q.value as num).toDouble(),
      },
    };

/// « 2027-03-31T00:00:00Z » -> « 2027-03-31 ».
String _jour(String s) => DateTime.parse(s).toIso8601String().substring(0, 10);

void _texte(List<String> e, Map<String, Object?> d, String champ,
    {String? chemin}) {
  final x = d[champ];
  if (x is! String || x.trim().isEmpty) {
    e.add('${chemin == null ? '' : '$chemin.'}$champ : texte obligatoire');
  }
}

void _choix(
    List<String> e, Map<String, Object?> d, String champ, Set<String> valeurs,
    {String? chemin}) {
  if (!valeurs.contains(d[champ])) {
    e.add('${chemin == null ? '' : '$chemin.'}$champ : valeur inconnue '
        '(${d[champ]})');
  }
}

void _positif(List<String> e, Map<String, Object?> d, String champ) {
  final x = d[champ];
  if (x is! num || x <= 0) e.add('$champ : nombre > 0 obligatoire');
}

void _date(List<String> e, Map<String, Object?> d, String champ,
    {String? chemin}) {
  final x = d[champ];
  if (x is! String || DateTime.tryParse(x) == null) {
    e.add('${chemin == null ? '' : '$chemin.'}$champ : date AAAA-MM-JJ');
  }
}
