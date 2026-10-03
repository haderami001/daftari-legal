import 'package:drift/drift.dart';

import '../../models/enums.dart';
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

  /// Installe le référentiel téléchargé du serveur (`GET /v1/referentiel`)
  /// et renvoie sa version. Tout ou rien : en cas d'erreur, l'ancien
  /// référentiel reste intact.
  ///
  /// Les navires et licences sont mis à jour ou ajoutés (jamais supprimés :
  /// les saisies déjà faites y font référence) ; leurs certificats et
  /// quotas sont remplacés.
  Future<int> appliquerReferentiel(Map<String, Object?> ref) =>
      _db.transaction(() async {
        for (final n in (ref['navires']! as List).cast<Map>()) {
          final id = n['id'] as String;
          await _db.into(_db.navires).insertOnConflictUpdate(NavireLigne(
                id: id,
                nom: n['nom'] as String,
                immatriculation: n['immatriculation'] as String,
                pavillon: n['pavillon'] as String,
                type: TypeNavire.values.byName(n['type'] as String),
                longueurM: (n['longueur_m'] as num).toDouble(),
                puissanceKw: (n['puissance_kw'] as num).toDouble(),
                numeroImo: n['numero_imo'] as String?,
              ));
          await (_db.delete(_db.certificats)
                ..where((c) => c.navireId.equals(id)))
              .go();
          for (final c in (n['certificats'] as List? ?? []).cast<Map>()) {
            await _db.into(_db.certificats).insert(CertificatsCompanion.insert(
                  navireId: id,
                  type: TypeCertificat.values.byName(c['type'] as String),
                  numero: c['numero'] as String,
                  dateExpiration:
                      DateTime.parse(c['date_expiration'] as String),
                ));
          }
        }
        for (final l in (ref['licences']! as List).cast<Map>()) {
          final numero = l['numero'] as String;
          await _db.into(_db.licences).insertOnConflictUpdate(LicenceLigne(
                numero: numero,
                navireId: l['navire_id'] as String,
                segment: TypePeche.values.byName(l['segment'] as String),
                enginsAutorises: {
                  for (final e in l['engins_autorises'] as List)
                    TypeEngin.values.byName(e as String),
                },
                especesCibles:
                    (l['especes_cibles'] as List).cast<String>().toSet(),
                dateDebut: DateTime.parse(l['date_debut'] as String),
                dateFin: DateTime.parse(l['date_fin'] as String),
              ));
          await (_db.delete(_db.quotas)
                ..where((q) => q.licenceNumero.equals(numero)))
              .go();
          for (final MapEntry(:key, :value)
              in (l['quotas_kg'] as Map? ?? {}).entries) {
            await _db.into(_db.quotas).insert(QuotaLigne(
                licenceNumero: numero,
                especeCode: key as String,
                quotaKg: (value as num).toDouble()));
          }
        }
        return ref['version']! as int;
      });
}
