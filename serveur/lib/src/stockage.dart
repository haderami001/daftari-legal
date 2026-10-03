import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'authentification.dart';
import 'referentiel.dart';
import 'validation.dart';

/// Résultat d'un enregistrement, qui garantit l'idempotence :
/// renvoyer exactement la même saisie ne crée pas de doublon.
enum Enregistrement {
  /// Nouvelle saisie enregistrée (HTTP 201).
  cree,

  /// Saisie identique déjà reçue : rien à faire (HTTP 200).
  dejaRecu,

  /// Même identifiant mais contenu différent : refusé (HTTP 409).
  conflit,
}

/// Ligne de résumé pour les listes de consultation.
class ResumeSaisie {
  const ResumeSaisie({
    required this.id,
    required this.navireId,
    required this.date,
    required this.nbInfractions,
    required this.recuLe,
    this.envoyePar,
  });

  final String id;
  final String navireId;
  final DateTime date;
  final int nbInfractions;
  final DateTime recuLe;

  /// Compte qui a envoyé la saisie (identifiant de connexion).
  final String? envoyePar;

  Map<String, Object?> versJson() => {
        'id': id,
        'navire_id': navireId,
        'date': date.toUtc().toIso8601String(),
        'nb_infractions': nbInfractions,
        'recu_le': recuLe.toUtc().toIso8601String(),
        'envoye_par': envoyePar,
      };
}

/// Où le serveur range les saisies. Deux implémentations :
/// [StockageMemoire] (tests, démo) et `StockagePostgres` (production).
abstract class Stockage {
  /// [par] : compte authentifié qui envoie (conservé avec la saisie).
  Future<Enregistrement> enregistrer(
      TypeSaisie type, String id, Map<String, Object?> donnees,
      {Utilisateur? par});

  Future<List<ResumeSaisie>> lister(TypeSaisie type, {int limite = 50});

  /// Rapport PDF d'un contrôle, ou `null` s'il n'existe pas.
  Future<Uint8List?> rapportPdf(String controleId);

  Future<Map<String, int>> compter();

  /// Référentiel complet : `{"version", "navires": [...], "licences": [...]}`.
  /// La version augmente à chaque modification : le téléphone ne
  /// retélécharge que si elle a changé.
  Future<Map<String, Object?>> referentiel();

  Future<int> versionReferentiel();

  /// [navire] et [licence] sont déjà vérifiés et normalisés
  /// (voir `referentiel.dart`).
  Future<EcritureReferentiel> enregistrerNavire(Map<String, Object?> navire,
      {Utilisateur? par});

  Future<EcritureReferentiel> enregistrerLicence(Map<String, Object?> licence,
      {Utilisateur? par});

  Future<void> fermer();
}

/// Import en masse (ex. référentiel initial au démarrage) : tout est
/// vérifié avant d'écrire quoi que ce soit. Navires d'abord, puis licences.
Future<void> importerReferentiel(
    Stockage stockage, Map<String, Object?> donnees) async {
  final navires =
      (donnees['navires'] as List? ?? const []).cast<Map<String, Object?>>();
  final licences =
      (donnees['licences'] as List? ?? const []).cast<Map<String, Object?>>();
  final erreurs = [
    for (final n in navires) ...verifierNavire('${n['id']}', n),
    for (final l in licences) ...verifierLicence('${l['numero']}', l),
  ];
  if (erreurs.isNotEmpty) {
    throw FormatException('Référentiel invalide : ${erreurs.join(' ; ')}');
  }
  for (final n in navires) {
    final id = n['id']! as String;
    final r = await stockage.enregistrerNavire(navireNormalise(id, n));
    if (r == EcritureReferentiel.immatriculationEnDouble) {
      throw FormatException('Navire $id : immatriculation en double');
    }
  }
  for (final l in licences) {
    final numero = l['numero']! as String;
    final r = await stockage.enregistrerLicence(licenceNormalisee(numero, l));
    if (r == EcritureReferentiel.navireInconnu) {
      throw FormatException('Licence $numero : navire inconnu');
    }
  }
}

/// Empreinte SHA-256 du contenu canonique d'une saisie.
String empreinte(Map<String, Object?> donnees) =>
    sha256.convert(utf8.encode(jsonCanonique(donnees))).toString();

/// Date « métier » d'une saisie : horodatage de la déclaration ou date du
/// contrôle.
DateTime dateSaisie(TypeSaisie type, Map<String, Object?> d) =>
    DateTime.parse(switch (type) {
      TypeSaisie.declaration => d['horodatage']! as String,
      TypeSaisie.controle => d['date']! as String,
    });

typedef _SaisieMemoire = ({
  Map<String, Object?> donnees,
  String empreinte,
  DateTime recuLe,
  String? envoyePar,
});

/// Stockage en mémoire : perdu à l'arrêt du serveur.
class StockageMemoire implements Stockage {
  final _saisies = {
    for (final t in TypeSaisie.values) t: <String, _SaisieMemoire>{},
  };

  @override
  Future<Enregistrement> enregistrer(
      TypeSaisie type, String id, Map<String, Object?> donnees,
      {Utilisateur? par}) async {
    final table = _saisies[type]!;
    final e = empreinte(donnees);
    final existant = table[id];
    if (existant != null) {
      return existant.empreinte == e
          ? Enregistrement.dejaRecu
          : Enregistrement.conflit;
    }
    table[id] = (
      donnees: donnees,
      empreinte: e,
      recuLe: DateTime.now(),
      envoyePar: par?.nom,
    );
    return Enregistrement.cree;
  }

  @override
  Future<List<ResumeSaisie>> lister(TypeSaisie type, {int limite = 50}) async {
    final lignes = [
      for (final MapEntry(key: id, value: s) in _saisies[type]!.entries)
        ResumeSaisie(
          id: id,
          navireId: s.donnees['navire_id']! as String,
          date: dateSaisie(type, s.donnees),
          nbInfractions: s.donnees['nb_infractions']! as int,
          recuLe: s.recuLe,
          envoyePar: s.envoyePar,
        ),
    ]..sort((a, b) => b.recuLe.compareTo(a.recuLe));
    return lignes.take(limite).toList();
  }

  @override
  Future<Uint8List?> rapportPdf(String controleId) async {
    final b64 = _saisies[TypeSaisie.controle]![controleId]
        ?.donnees['rapport_pdf_base64'] as String?;
    return b64 == null ? null : base64Decode(b64);
  }

  @override
  Future<Map<String, int>> compter() async => {
        for (final t in TypeSaisie.values) t.segment: _saisies[t]!.length,
      };

  final _navires = <String, Map<String, Object?>>{};
  final _licences = <String, Map<String, Object?>>{};
  var _version = 0;

  @override
  Future<Map<String, Object?>> referentiel() async => {
        'version': _version,
        'navires': [
          for (final k in _navires.keys.toList()..sort()) _navires[k],
        ],
        'licences': [
          for (final k in _licences.keys.toList()..sort()) _licences[k],
        ],
      };

  @override
  Future<int> versionReferentiel() async => _version;

  @override
  Future<EcritureReferentiel> enregistrerNavire(Map<String, Object?> navire,
      {Utilisateur? par}) async {
    final id = navire['id']! as String;
    if (_navires.values.any((n) =>
        n['id'] != id && n['immatriculation'] == navire['immatriculation'])) {
      return EcritureReferentiel.immatriculationEnDouble;
    }
    final nouveau = !_navires.containsKey(id);
    _navires[id] = navire;
    _version++;
    return nouveau ? EcritureReferentiel.cree : EcritureReferentiel.modifie;
  }

  @override
  Future<EcritureReferentiel> enregistrerLicence(Map<String, Object?> licence,
      {Utilisateur? par}) async {
    if (!_navires.containsKey(licence['navire_id'])) {
      return EcritureReferentiel.navireInconnu;
    }
    final numero = licence['numero']! as String;
    final nouveau = !_licences.containsKey(numero);
    _licences[numero] = licence;
    _version++;
    return nouveau ? EcritureReferentiel.cree : EcritureReferentiel.modifie;
  }

  @override
  Future<void> fermer() async {}
}
