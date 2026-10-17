import 'dart:async';

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

  /// Nombre de saisies en attente, **en continu** : le flux (Stream) émet
  /// la valeur actuelle, puis une nouvelle valeur chaque fois que la table
  /// `file_envois` change (nouvelle saisie, envoi réussi…).
  ///
  /// Un `StreamController` fabrique le flux à la main : `onListen` démarre
  /// la surveillance quand un écran s'abonne, `onCancel` l'arrête quand
  /// l'écran se ferme.
  Stream<int> surveillerNombreEnAttente() {
    StreamSubscription<void>? changements;
    var arrete = false;
    late final StreamController<int> flux;
    flux = StreamController<int>(
      onListen: () async {
        flux.add(await nombreEnAttente());
        if (arrete) return;
        changements = _db
            .tableUpdates(TableUpdateQuery.onTable(_db.fileEnvois))
            .asyncMap((_) => nombreEnAttente())
            .listen(flux.add, onError: flux.addError);
      },
      onCancel: () {
        arrete = true;
        changements?.cancel(); // sans attendre : la fermeture reste immédiate
      },
    );
    return flux.stream;
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
