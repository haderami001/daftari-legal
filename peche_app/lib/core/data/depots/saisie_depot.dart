import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../models/declaration.dart';
import '../../regulation/calcul_reglementaire.dart';
import '../base/base_de_donnees.dart';
import '../base/tables.dart';

/// Enregistrement des saisies faites sur le téléphone.
///
/// Chaque enregistrement est fait dans une **transaction** : soit tout est
/// écrit (la saisie + ses lignes + l'entrée dans la file d'envoi), soit
/// rien ne l'est. On ne peut donc pas perdre une déclaration à moitié.
class SaisieDepot {
  SaisieDepot(this._db, {Uuid uuid = const Uuid()}) : _uuid = uuid;

  final BaseDeDonnees _db;
  final Uuid _uuid;

  /// Enregistre la déclaration et renvoie son identifiant (UUID).
  Future<String> enregistrerDeclaration(
    DeclarationCapitaine d,
    ResultatVerification resultat,
  ) {
    final id = _uuid.v4();
    return _db.transaction(() async {
      await _db.into(_db.declarations).insert(DeclarationsCompanion.insert(
            id: id,
            navireId: d.navire.id,
            licenceNumero: d.licence.numero,
            engin: d.engin,
            latitude: d.position.latitude,
            longitude: d.position.longitude,
            horodatage: d.position.horodatage,
            nbInfractions: Value(resultat.infractions.length),
          ));
      for (final m in d.equipage) {
        await _db.into(_db.equipages).insert(EquipagesCompanion.insert(
              declarationId: id,
              nom: m.nom,
              fonction: m.fonction,
              nationalite: m.nationalite,
            ));
      }
      for (final c in d.captures) {
        await _db.into(_db.captures).insert(CapturesCompanion.insert(
              declarationId: id,
              especeCode: c.especeCode,
              poidsKg: c.poidsKg,
            ));
      }
      await _mettreEnFile(
        TypeEnvoi.declaration,
        id,
        'Déclaration ${d.navire.nom} — '
        '${d.poidsTotalKg.toStringAsFixed(0)} kg',
      );
      return id;
    });
  }

  /// Crée un identifiant (UUID v4) pour une nouvelle saisie. Utile quand
  /// l'identifiant doit figurer dans un document avant l'enregistrement
  /// (ex. le n° imprimé sur le rapport PDF).
  String nouvelIdentifiant() => _uuid.v4();

  /// Enregistre le contrôle signé (texte et PDF du rapport) et renvoie son
  /// identifiant (UUID).
  Future<String> enregistrerControle(
    Controle c,
    ResultatVerification resultat,
    String rapport, {
    String? identifiant,
    Uint8List? rapportPdf,
  }) {
    final id = identifiant ?? _uuid.v4();
    return _db.transaction(() async {
      await _db.into(_db.controles).insert(ControlesCompanion.insert(
            id: id,
            navireId: c.navire.id,
            agent: c.agent,
            date: c.date,
            latitude: c.position.latitude,
            longitude: c.position.longitude,
            engin: c.engin,
            pavillonConforme: c.pavillonConforme,
            marquageConforme: c.marquageConforme,
            planStockageConforme: c.planStockageConforme,
            observations: Value(c.observations),
            nbInfractions: resultat.infractions.length,
            amendeMin: resultat.amendeMin,
            amendeMax: resultat.amendeMax,
            rapport: rapport,
            rapportPdf: Value(rapportPdf),
          ));
      for (final m in c.maillagesMm) {
        await _db.into(_db.controleMaillages).insert(
            ControleMaillagesCompanion.insert(controleId: id, mesureMm: m));
      }
      for (final e in c.echantillons) {
        await _db.into(_db.controleEchantillons).insert(
            ControleEchantillonsCompanion.insert(
                controleId: id, especeCode: e.especeCode, valeur: e.valeur));
      }
      await _mettreEnFile(
        TypeEnvoi.controle,
        id,
        'Contrôle ${c.navire.nom} — '
        '${resultat.infractions.length} infraction(s)',
      );
      return id;
    });
  }

  /// Relit le rapport PDF signé d'un contrôle (`null` si absent).
  Future<Uint8List?> rapportPdf(String controleId) async {
    final ligne = await (_db.select(_db.controles)
          ..where((c) => c.id.equals(controleId)))
        .getSingleOrNull();
    return ligne?.rapportPdf;
  }

  /// Relit les captures d'une déclaration enregistrée.
  Future<List<Capture>> captures(String declarationId) async {
    final lignes = await (_db.select(_db.captures)
          ..where((c) => c.declarationId.equals(declarationId)))
        .get();
    return [
      for (final l in lignes)
        Capture(especeCode: l.especeCode, poidsKg: l.poidsKg),
    ];
  }

  // -------------------------------------------------------------------------
  // Export JSON pour l'envoi au serveur (format de `POST /v1/sync/...`)
  // -------------------------------------------------------------------------

  Future<Map<String, Object?>> exporterDeclaration(String id) async {
    final d = await (_db.select(_db.declarations)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    final equipage = await (_db.select(_db.equipages)
          ..where((t) => t.declarationId.equals(id)))
        .get();
    final captures = await (_db.select(_db.captures)
          ..where((t) => t.declarationId.equals(id)))
        .get();
    return {
      'id': d.id,
      'navire_id': d.navireId,
      'licence_numero': d.licenceNumero,
      'engin': d.engin.name,
      'position': {'lat': d.latitude, 'lon': d.longitude},
      'horodatage': d.horodatage.toUtc().toIso8601String(),
      'nb_infractions': d.nbInfractions,
      'equipage': [
        for (final m in equipage)
          {'nom': m.nom, 'fonction': m.fonction, 'nationalite': m.nationalite},
      ],
      'captures': [
        for (final c in captures)
          {'espece': c.especeCode, 'poids_kg': c.poidsKg},
      ],
    };
  }

  Future<Map<String, Object?>> exporterControle(String id) async {
    final c = await (_db.select(_db.controles)..where((t) => t.id.equals(id)))
        .getSingle();
    final maillages = await (_db.select(_db.controleMaillages)
          ..where((t) => t.controleId.equals(id)))
        .get();
    final echantillons = await (_db.select(_db.controleEchantillons)
          ..where((t) => t.controleId.equals(id)))
        .get();
    return {
      'id': c.id,
      'navire_id': c.navireId,
      'agent': c.agent,
      'date': c.date.toUtc().toIso8601String(),
      'position': {'lat': c.latitude, 'lon': c.longitude},
      'engin': c.engin.name,
      'pavillon_conforme': c.pavillonConforme,
      'marquage_conforme': c.marquageConforme,
      'stockage_conforme': c.planStockageConforme,
      'observations': c.observations,
      'nb_infractions': c.nbInfractions,
      'amende_min_mru': c.amendeMin,
      'amende_max_mru': c.amendeMax,
      'maillages_mm': [for (final m in maillages) m.mesureMm],
      'echantillons': [
        for (final e in echantillons)
          {'espece': e.especeCode, 'valeur': e.valeur},
      ],
      'rapport': c.rapport,
      if (c.rapportPdf != null)
        'rapport_pdf_base64': base64Encode(c.rapportPdf!),
    };
  }

  Future<void> _mettreEnFile(TypeEnvoi type, String id, String resume) =>
      _db.into(_db.fileEnvois).insert(
          FileEnvoisCompanion.insert(type: type, entiteId: id, resume: resume));
}
