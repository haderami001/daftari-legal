import 'package:drift/drift.dart';

import '../base/base_de_donnees.dart';

/// File d'envoi (« outbox ») vers le serveur central.
///
/// Le futur service de synchronisation fera, dès que le réseau revient :
///   1. `enAttente()` → envoyer chaque élément (`POST /sync`) ;
///   2. succès → `marquerEnvoye(id)` ; échec → `marquerEchec(id, erreur)`.
class FileEnvoiDepot {
  FileEnvoiDepot(this._db);

  final BaseDeDonnees _db;

  Future<List<EnvoiLigne>> enAttente() => (_db.select(_db.fileEnvois)
        ..where((e) => e.envoyeLe.isNull())
        ..orderBy([(e) => OrderingTerm(expression: e.creeLe)]))
      .get();

  Future<int> nombreEnAttente() async {
    final nombre = _db.fileEnvois.id.count();
    final requete = _db.selectOnly(_db.fileEnvois)
      ..addColumns([nombre])
      ..where(_db.fileEnvois.envoyeLe.isNull());
    return (await requete.getSingle()).read(nombre) ?? 0;
  }

  Future<void> marquerEnvoye(int id, {DateTime? le}) =>
      (_db.update(_db.fileEnvois)..where((e) => e.id.equals(id)))
          .write(FileEnvoisCompanion(envoyeLe: Value(le ?? DateTime.now())));

  Future<void> marquerEchec(int id, String erreur) => _db.customUpdate(
        'UPDATE file_envois SET tentatives = tentatives + 1, '
        'derniere_erreur = ? WHERE id = ?',
        variables: [Variable.withString(erreur), Variable.withInt(id)],
        updates: {_db.fileEnvois},
      );
}
