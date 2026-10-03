import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../models/enums.dart';
import '../donnees_demo.dart';
import 'tables.dart';

part 'base_de_donnees.g.dart';

/// Base SQLite locale : l'application fonctionne entièrement sans réseau.
///
/// - Le référentiel (navires, licences, quotas) est copié sur le téléphone.
/// - Chaque déclaration ou contrôle est enregistré ici, puis placé dans la
///   file d'envoi ([FileEnvois]) jusqu'à confirmation du serveur.
@DriftDatabase(tables: [
  Navires,
  Certificats,
  Licences,
  Quotas,
  Declarations,
  Equipages,
  Captures,
  Controles,
  ControleMaillages,
  ControleEchantillons,
  FileEnvois,
  Reglages,
])
class BaseDeDonnees extends _$BaseDeDonnees {
  /// Base réelle : un fichier SQLite sur le téléphone, ou, dans un
  /// navigateur (démo web), SQLite compilé en WebAssembly (`web/`).
  BaseDeDonnees()
      : super(driftDatabase(
          name: 'peche_conforme',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ));

  /// Base fournie de l'extérieur (ex. `NativeDatabase.memory()` en test).
  BaseDeDonnees.avec(super.executor);

  /// À incrémenter à chaque changement de structure, avec une étape de
  /// migration dans [migration].
  ///
  /// - v1 : schéma initial
  /// - v2 : colonne `controles.rapport_pdf` (rapport PDF signé)
  /// - v3 : table `reglages` (langue choisie)
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Prototype : on remplit la base avec la flotte de démo.
          // En production : téléchargement depuis l'API (GET /navires...).
          await insererDonneesDemo();
        },
        // Mise à jour d'une base existante, étape par étape : un téléphone
        // resté en v1 passe par chaque étape jusqu'à la version actuelle.
        onUpgrade: (m, depuis, vers) async {
          if (depuis < 2) {
            await m.addColumn(controles, controles.rapportPdf);
          }
          if (depuis < 3) {
            await m.createTable(reglages);
          }
        },
        beforeOpen: (details) async {
          // SQLite n'applique les clés étrangères que si on le demande.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> insererDonneesDemo() => transaction(() async {
        for (final n in naviresDemo) {
          await into(navires).insert(NavireLigne(
            id: n.id,
            nom: n.nom,
            immatriculation: n.immatriculation,
            pavillon: n.pavillon,
            type: n.type,
            longueurM: n.longueurM,
            puissanceKw: n.puissanceKw,
            numeroImo: n.numeroImo,
          ));
          for (final c in n.certificats) {
            await into(certificats).insert(CertificatsCompanion.insert(
              navireId: n.id,
              type: c.type,
              numero: c.numero,
              dateExpiration: c.dateExpiration,
            ));
          }
        }
        for (final l in licencesDemo.values) {
          await into(licences).insert(LicenceLigne(
            numero: l.numero,
            navireId: l.navireId,
            segment: l.segment,
            enginsAutorises: l.enginsAutorises,
            especesCibles: l.especesCibles,
            dateDebut: l.dateDebut,
            dateFin: l.dateFin,
          ));
          for (final MapEntry(key: code, value: kg) in l.quotasKg.entries) {
            await into(quotas).insert(QuotaLigne(
                licenceNumero: l.numero, especeCode: code, quotaKg: kg));
          }
        }
      });
}
