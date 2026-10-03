import 'package:drift/drift.dart';

import '../../models/navire.dart';
import '../base/base_de_donnees.dart';

/// Un navire et sa licence la plus récente.
typedef NavireLicence = ({Navire navire, Licence licence});

/// Lecture du référentiel stocké sur le téléphone (navires, licences).
class FlotteDepot {
  FlotteDepot(this._db);

  final BaseDeDonnees _db;

  /// Navires ayant au moins une licence, triés par nom.
  Future<List<NavireLicence>> naviresAvecLicence() async {
    final lignes = await (_db.select(_db.navires)
          ..orderBy([(n) => OrderingTerm(expression: n.nom)]))
        .get();
    final certificats = await _db.select(_db.certificats).get();
    final licences = await (_db.select(_db.licences)
          ..orderBy([(l) => OrderingTerm.desc(l.dateFin)]))
        .get();
    final quotas = await _db.select(_db.quotas).get();

    final resultat = <NavireLicence>[];
    for (final n in lignes) {
      // Les licences sont triées par date de fin décroissante :
      // la première trouvée est la plus récente.
      final l = licences.where((l) => l.navireId == n.id).firstOrNull;
      if (l == null) continue;
      resultat.add((
        navire: Navire(
          id: n.id,
          nom: n.nom,
          immatriculation: n.immatriculation,
          pavillon: n.pavillon,
          type: n.type,
          longueurM: n.longueurM,
          puissanceKw: n.puissanceKw,
          numeroImo: n.numeroImo,
          certificats: [
            for (final c in certificats.where((c) => c.navireId == n.id))
              Certificat(
                type: c.type,
                numero: c.numero,
                dateExpiration: c.dateExpiration,
              ),
          ],
        ),
        licence: Licence(
          numero: l.numero,
          navireId: l.navireId,
          segment: l.segment,
          enginsAutorises: l.enginsAutorises,
          especesCibles: l.especesCibles,
          dateDebut: l.dateDebut,
          dateFin: l.dateFin,
          quotasKg: {
            for (final q in quotas.where((q) => q.licenceNumero == l.numero))
              q.especeCode: q.quotaKg,
          },
        ),
      ));
    }
    return resultat;
  }
}
