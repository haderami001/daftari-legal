import '../models/declaration.dart';
import '../models/enums.dart';
import '../models/navire.dart';
import 'referentiel.dart';

/// Une non-conformité détectée par le moteur de règles.
class Infraction {
  const Infraction({
    required this.code,
    required this.gravite,
    required this.message,
    this.details = const {},
  });

  /// Code stable (utile pour les statistiques et la synchronisation).
  final String code;
  final Gravite gravite;

  /// Message en français (rapport officiel, PDF).
  final String message;

  /// Valeurs brutes du message (numéro, engin, poids...) : l'interface s'en
  /// sert pour rédiger le message dans la langue de l'utilisateur.
  final Map<String, Object> details;

  @override
  String toString() => '[${gravite.libelle}] $message';
}

class ResultatVerification {
  const ResultatVerification(this.infractions, this.bareme);

  final List<Infraction> infractions;
  final Map<Gravite, BaremeSanction> bareme;

  bool get conforme => infractions.isEmpty;

  double get amendeMin => infractions.fold(
      0, (total, i) => total + (bareme[i.gravite]?.amendeMin ?? 0));

  double get amendeMax => infractions.fold(
      0, (total, i) => total + (bareme[i.gravite]?.amendeMax ?? 0));
}

/// Moteur de calcul réglementaire.
///
/// Il est écrit en Dart « pur » (aucun import Flutter) : il peut donc être
/// testé unitairement, et réutilisé tel quel côté serveur (Dart Frog /
/// Shelf) pour garantir que l'app et le back-office appliquent les MÊMES
/// règles.
class CalculReglementaire {
  const CalculReglementaire(this.ref);

  final Referentiel ref;

  // ---------------------------------------------------------------------
  // Déclaration du capitaine
  // ---------------------------------------------------------------------

  ResultatVerification verifierDeclaration(
    DeclarationCapitaine d, {
    DateTime? date,
  }) {
    final jour = date ?? d.position.horodatage;
    return ResultatVerification([
      ...verifierLicence(d.licence, d.engin, jour),
      ...verifierCertificats(d.navire, jour),
      ...verifierQuotas(d.licence, d.captures),
      ...verifierPrisesAccessoires(d.licence, d.engin, d.captures),
    ], ref.bareme);
  }

  List<Infraction> verifierLicence(
      Licence licence, TypeEngin engin, DateTime jour) {
    return [
      if (!licence.estValideLe(jour))
        Infraction(
          code: 'LIC_INVALIDE',
          gravite: Gravite.tresGrave,
          message: 'Licence ${licence.numero} non valide à cette date.',
          details: {'licence': licence.numero},
        ),
      if (!licence.enginsAutorises.contains(engin))
        Infraction(
          code: 'ENGIN_NON_AUTORISE',
          gravite: Gravite.grave,
          message: 'Engin « ${engin.libelle} » non autorisé par la licence.',
          details: {'engin': engin},
        ),
    ];
  }

  List<Infraction> verifierCertificats(Navire navire, DateTime jour) {
    return [
      for (final c in navire.certificats)
        if (!c.estValideLe(jour))
          Infraction(
            code: 'CERT_EXPIRE',
            gravite: Gravite.mineure,
            message: '${c.type.libelle} n° ${c.numero} expiré.',
            details: {'certificat': c.type, 'numero': c.numero},
          ),
    ];
  }

  /// Compare les captures déclarées au quota restant de la licence.
  List<Infraction> verifierQuotas(Licence licence, List<Capture> captures) {
    final cumul = cumulParEspece(captures);
    return [
      for (final MapEntry(key: code, value: poids) in cumul.entries)
        if (licence.quotasKg[code] case final quota? when poids > quota)
          Infraction(
            code: 'QUOTA_DEPASSE',
            gravite: Gravite.grave,
            message: 'Quota $code dépassé : ${poids.toStringAsFixed(0)} kg '
                'pour ${quota.toStringAsFixed(0)} kg autorisés.',
            details: {'espece': code, 'poids': poids, 'quota': quota},
          ),
    ];
  }

  /// Prises accessoires = tout ce qui n'est pas une espèce cible de la licence.
  List<Infraction> verifierPrisesAccessoires(
      Licence licence, TypeEngin engin, List<Capture> captures) {
    final pct = pourcentagePrisesAccessoires(licence, captures);
    final max = ref.engin(engin)?.prisesAccessoiresMaxPct;
    if (max == null || pct <= max) return const [];
    return [
      Infraction(
        code: 'PRISES_ACCESSOIRES',
        gravite: Gravite.grave,
        message: 'Prises accessoires ${pct.toStringAsFixed(1)} % '
            '(max ${max.toStringAsFixed(0)} % pour ${engin.libelle}).',
        details: {'pct': pct, 'max': max, 'engin': engin},
      ),
    ];
  }

  double pourcentagePrisesAccessoires(Licence licence, List<Capture> captures) {
    final total = captures.fold<double>(0, (s, c) => s + c.poidsKg);
    if (total == 0) return 0;
    final accessoires = captures
        .where((c) => !licence.especesCibles.contains(c.especeCode))
        .fold<double>(0, (s, c) => s + c.poidsKg);
    return accessoires / total * 100;
  }

  static Map<String, double> cumulParEspece(List<Capture> captures) {
    final cumul = <String, double>{};
    for (final c in captures) {
      cumul.update(c.especeCode, (v) => v + c.poidsKg,
          ifAbsent: () => c.poidsKg);
    }
    return cumul;
  }

  // ---------------------------------------------------------------------
  // Contrôle par l'agent garde-côtes
  // ---------------------------------------------------------------------

  ResultatVerification verifierControle(Controle c, {Licence? licence}) {
    return ResultatVerification([
      if (!c.pavillonConforme)
        const Infraction(
          code: 'PAVILLON',
          gravite: Gravite.tresGrave,
          message: 'Pavillon / identification du navire non conforme.',
        ),
      if (!c.marquageConforme)
        const Infraction(
          code: 'MARQUAGE',
          gravite: Gravite.mineure,
          message: 'Marquage extérieur (immatriculation) absent ou illisible.',
        ),
      if (licence != null) ...verifierLicence(licence, c.engin, c.date),
      ...verifierCertificats(c.navire, c.date),
      ...verifierMaillage(c.engin, c.maillagesMm),
      ...verifierTailles(c.echantillons),
      if (!c.planStockageConforme)
        const Infraction(
          code: 'STOCKAGE',
          gravite: Gravite.mineure,
          message: 'Plan de stockage en cale non conforme à la déclaration.',
        ),
    ], ref.bareme);
  }

  /// Le maillage retenu est la moyenne des mesures (au moins 1 mesure),
  /// comparée au minimum réglementaire diminué de la tolérance.
  List<Infraction> verifierMaillage(TypeEngin engin, List<double> mesuresMm) {
    final regle = ref.engin(engin);
    if (regle == null || regle.maillageMinMm == 0 || mesuresMm.isEmpty) {
      return const [];
    }
    final moyenne = mesuresMm.reduce((a, b) => a + b) / mesuresMm.length;
    final seuil = regle.maillageMinMm * (1 - ref.toleranceMaillagePct / 100);
    if (moyenne >= seuil) return const [];
    return [
      Infraction(
        code: 'MAILLAGE',
        gravite: Gravite.grave,
        message: 'Maillage moyen ${moyenne.toStringAsFixed(1)} mm < '
            '${regle.maillageMinMm.toStringAsFixed(0)} mm requis '
            '(${engin.libelle}).',
        details: {
          'moyenne': moyenne,
          'min': regle.maillageMinMm,
          'engin': engin,
        },
      ),
    ];
  }

  /// Une infraction par espèce ayant au moins un individu sous la taille
  /// (ou le poids) minimale.
  List<Infraction> verifierTailles(List<Echantillon> echantillons) {
    final parEspece = <String, List<Echantillon>>{};
    for (final e in echantillons) {
      parEspece.putIfAbsent(e.especeCode, () => []).add(e);
    }
    final result = <Infraction>[];
    parEspece.forEach((code, liste) {
      final regle = ref.espece(code);
      if (regle == null) return;
      final sousTaille = liste.where((e) => e.valeur < regle.minimum).length;
      if (sousTaille == 0) return;
      final pct = sousTaille / liste.length * 100;
      result.add(Infraction(
        code: 'TAILLE_MIN',
        gravite: pct > 50 ? Gravite.grave : Gravite.mineure,
        message: '${regle.nomCommun} : $sousTaille/${liste.length} '
            'individus sous ${regle.minimum.toStringAsFixed(0)} '
            '${regle.unite.symbole} (${regle.organisme}).',
        details: {
          'espece': code,
          'sous': sousTaille,
          'total': liste.length,
          'min': regle.minimum,
          'unite': regle.unite,
          'organisme': regle.organisme,
        },
      ));
    });
    return result;
  }
}
