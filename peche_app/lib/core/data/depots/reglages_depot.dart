import '../base/base_de_donnees.dart';

/// Réglages de l'appareil, conservés dans la base locale.
class ReglagesDepot {
  ReglagesDepot(this._db);

  final BaseDeDonnees _db;

  static const cleLangue = 'langue';

  Future<String?> lire(String cle) async =>
      (await (_db.select(_db.reglages)..where((r) => r.cle.equals(cle)))
              .getSingleOrNull())
          ?.valeur;

  /// Enregistre la valeur, ou supprime le réglage si [valeur] est `null`.
  Future<void> ecrire(String cle, String? valeur) async {
    if (valeur == null) {
      await (_db.delete(_db.reglages)..where((r) => r.cle.equals(cle))).go();
    } else {
      await _db
          .into(_db.reglages)
          .insertOnConflictUpdate(ReglageLigne(cle: cle, valeur: valeur));
    }
  }
}
