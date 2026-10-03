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

  /// Enregistre le contrôle signé (avec le texte du rapport) et renvoie
  /// son identifiant (UUID).
  Future<String> enregistrerControle(
    Controle c,
    ResultatVerification resultat,
    String rapport,
  ) {
    final id = _uuid.v4();
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

  Future<void> _mettreEnFile(TypeEnvoi type, String id, String resume) =>
      _db.into(_db.fileEnvois).insert(
          FileEnvoisCompanion.insert(type: type, entiteId: id, resume: resume));
}
