/// Vérification des saisies reçues du téléphone.
///
/// Le serveur ne fait jamais confiance aux données reçues : chaque champ est
/// contrôlé (présence, type, bornes) avant d'être enregistré. La liste des
/// erreurs est renvoyée telle quelle à l'application (HTTP 400).
library;

import 'dart:convert';

enum TypeSaisie {
  declaration('declarations'),
  controle('controles');

  const TypeSaisie(this.segment);

  /// Segment d'URL : /v1/sync/{segment}/{id}.
  final String segment;

  static TypeSaisie? depuisSegment(String s) =>
      values.where((t) => t.segment == s).firstOrNull;
}

/// Engins connus de l'application (`TypeEngin.name` côté Flutter).
const enginsConnus = {
  'ligne',
  'filetMaillant',
  'casier',
  'chalutDemersal',
  'chalutPelagique',
  'senneTournante',
  'drague',
};

final _uuid = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    caseSensitive: false);
final _codeFao = RegExp(r'^[A-Z]{3}$');

bool estUuid(String s) => _uuid.hasMatch(s);

/// Vérifie une saisie et renvoie la liste des erreurs (vide = valide).
List<String> verifierSaisie(
    TypeSaisie type, String idUrl, Map<String, Object?> d) {
  final v = _Verificateur(d);
  v.texte('id');
  if (!estUuid(idUrl)) v.erreurs.add('id : doit être un UUID');
  if (d['id'] is String && d['id'] != idUrl) {
    v.erreurs.add('id : différent de celui de l\'URL');
  }
  v.texte('navire_id');
  v.choix('engin', enginsConnus);
  v.position('position');
  v.entier('nb_infractions', min: 0);

  switch (type) {
    case TypeSaisie.declaration:
      v.texte('licence_numero');
      v.date('horodatage');
      v.liste('equipage', (e, chemin) {
        e.texte('nom', chemin: chemin);
        e.texte('fonction', chemin: chemin);
        e.texte('nationalite', chemin: chemin);
      });
      v.liste('captures', (e, chemin) {
        e.codeEspece('espece', chemin: chemin);
        e.nombre('poids_kg', min: 0, strict: true, chemin: chemin);
      });
    case TypeSaisie.controle:
      v.texte('agent');
      v.date('date');
      v.booleen('pavillon_conforme');
      v.booleen('marquage_conforme');
      v.booleen('stockage_conforme');
      v.texte('observations', vide: true);
      v.nombre('amende_min_mru', min: 0);
      v.nombre('amende_max_mru', min: 0);
      if (d['amende_min_mru'] is num &&
          d['amende_max_mru'] is num &&
          (d['amende_max_mru'] as num) < (d['amende_min_mru'] as num)) {
        v.erreurs.add('amende_max_mru : inférieure à amende_min_mru');
      }
      v.listeNombres('maillages_mm');
      v.liste('echantillons', (e, chemin) {
        e.codeEspece('espece', chemin: chemin);
        e.nombre('valeur', min: 0, strict: true, chemin: chemin);
      });
      v.texte('rapport');
      final pdf = d['rapport_pdf_base64'];
      if (pdf != null) {
        if (pdf is! String) {
          v.erreurs.add('rapport_pdf_base64 : doit être un texte');
        } else {
          try {
            final octets = base64Decode(pdf);
            if (octets.length < 5 ||
                String.fromCharCodes(octets.take(5)) != '%PDF-') {
              v.erreurs.add('rapport_pdf_base64 : n\'est pas un PDF');
            }
          } on FormatException {
            v.erreurs.add('rapport_pdf_base64 : base64 invalide');
          }
        }
      }
  }
  return v.erreurs;
}

class _Verificateur {
  _Verificateur(this.d, [List<String>? erreurs]) : erreurs = erreurs ?? [];

  final Map<String, Object?> d;
  final List<String> erreurs;

  String _nom(String champ, String? chemin) =>
      chemin == null ? champ : '$chemin.$champ';

  void texte(String champ, {bool vide = false, String? chemin}) {
    final x = d[champ];
    if (x is! String) {
      erreurs.add('${_nom(champ, chemin)} : texte obligatoire');
    } else if (!vide && x.trim().isEmpty) {
      erreurs.add('${_nom(champ, chemin)} : ne doit pas être vide');
    }
  }

  void choix(String champ, Set<String> valeurs) {
    final x = d[champ];
    if (x is! String || !valeurs.contains(x)) {
      erreurs.add('$champ : valeur inconnue ($x)');
    }
  }

  void booleen(String champ) {
    if (d[champ] is! bool) erreurs.add('$champ : vrai/faux obligatoire');
  }

  void entier(String champ, {int? min}) {
    final x = d[champ];
    if (x is! int) {
      erreurs.add('$champ : entier obligatoire');
    } else if (min != null && x < min) {
      erreurs.add('$champ : doit être ≥ $min');
    }
  }

  void nombre(String champ, {num? min, bool strict = false, String? chemin}) {
    final x = d[champ];
    final nom = _nom(champ, chemin);
    if (x is! num) {
      erreurs.add('$nom : nombre obligatoire');
    } else if (min != null && (strict ? x <= min : x < min)) {
      erreurs.add('$nom : doit être ${strict ? '>' : '≥'} $min');
    }
  }

  void codeEspece(String champ, {String? chemin}) {
    final x = d[champ];
    if (x is! String || !_codeFao.hasMatch(x)) {
      erreurs.add('${_nom(champ, chemin)} : code FAO à 3 lettres attendu');
    }
  }

  void date(String champ) {
    final x = d[champ];
    if (x is! String || DateTime.tryParse(x) == null) {
      erreurs.add('$champ : date ISO 8601 obligatoire');
    }
  }

  void position(String champ) {
    final p = d[champ];
    if (p is! Map) {
      erreurs.add('$champ : {lat, lon} obligatoire');
      return;
    }
    final lat = p['lat'], lon = p['lon'];
    if (lat is! num || lat < -90 || lat > 90) {
      erreurs.add('$champ.lat : entre -90 et 90');
    }
    if (lon is! num || lon < -180 || lon > 180) {
      erreurs.add('$champ.lon : entre -180 et 180');
    }
  }

  void listeNombres(String champ) {
    final l = d[champ];
    if (l is! List) {
      erreurs.add('$champ : liste obligatoire');
    } else if (l.any((x) => x is! num || x <= 0)) {
      erreurs.add('$champ : nombres positifs attendus');
    }
  }

  void liste(String champ,
      void Function(_Verificateur element, String chemin) verifier) {
    final l = d[champ];
    if (l is! List) {
      erreurs.add('$champ : liste obligatoire');
      return;
    }
    for (final (i, e) in l.indexed) {
      if (e is! Map) {
        erreurs.add('$champ[$i] : objet attendu');
      } else {
        verifier(
            _Verificateur(e.cast<String, Object?>(), erreurs), '$champ[$i]');
      }
    }
  }
}

/// Empreinte stable d'une saisie (clés triées) : sert à reconnaître un
/// renvoi identique (idempotence) d'un renvoi modifié (conflit).
String jsonCanonique(Object? valeur) => jsonEncode(_trier(valeur));

Object? _trier(Object? v) => switch (v) {
      Map() => {
          for (final k in (v.keys.map((k) => '$k').toList()..sort()))
            k: _trier(v[k]),
        },
      List() => [for (final e in v) _trier(e)],
      _ => v,
    };
