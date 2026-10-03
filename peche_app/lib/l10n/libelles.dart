import 'package:flutter/widgets.dart';

import '../core/models/enums.dart';
import '../core/regulation/calcul_reglementaire.dart';
import '../core/regulation/referentiel.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

/// Libellés traduits des données métier.
///
/// Le moteur réglementaire reste en Dart pur et en français (rapport
/// officiel). L'interface, elle, passe par ces méthodes pour afficher les
/// énumérations, les espèces et les messages d'infraction dans la langue de
/// l'utilisateur : `context.l10n.libelleEngin(TypeEngin.casier)`.
extension Libelles on AppLocalizations {
  String libelleEngin(TypeEngin e) => engin(e.name);
  String libelleTypeNavire(TypeNavire t) => typeNavire(t.name);
  String libelleSegment(TypePeche s) => segment(s.name);
  String libelleGravite(Gravite g) => gravite(g.name);
  String libelleCertificat(TypeCertificat c) => certificat(c.name);
  String nomEspece(String code) => especeNom(code);

  String unite(UniteMesure u) => switch (u) {
        UniteMesure.longueurCm => uniteCm,
        UniteMesure.poidsG => uniteG,
      };

  String organisme(String o) =>
      o == 'Code des pêches (MRT)' ? organismeCodePeches : o;

  /// Message d'une infraction dans la langue de l'utilisateur. Si le code
  /// est inconnu (nouvelle règle pas encore traduite), on garde le message
  /// français du moteur.
  String messageInfraction(Infraction i) {
    final d = i.details;
    String n0(Object? v) => (v as num).toStringAsFixed(0);
    String n1(Object? v) => (v as num).toStringAsFixed(1);
    return switch (i.code) {
      'LIC_INVALIDE' => infLicenceInvalide('${d['licence']}'),
      'ENGIN_NON_AUTORISE' =>
        infEnginNonAutorise(libelleEngin(d['engin']! as TypeEngin)),
      'CERT_EXPIRE' => infCertificatExpire(
          libelleCertificat(d['certificat']! as TypeCertificat),
          '${d['numero']}'),
      'QUOTA_DEPASSE' => infQuotaDepasse(
          nomEspece('${d['espece']}'), n0(d['poids']), n0(d['quota'])),
      'PRISES_ACCESSOIRES' => infPrisesAccessoires(
          n1(d['pct']), n0(d['max']), libelleEngin(d['engin']! as TypeEngin)),
      'PAVILLON' => infPavillon,
      'MARQUAGE' => infMarquage,
      'STOCKAGE' => infStockage,
      'MAILLAGE' => infMaillage(n1(d['moyenne']), n0(d['min']),
          libelleEngin(d['engin']! as TypeEngin)),
      'TAILLE_MIN' => infTailleMin(
          nomEspece('${d['espece']}'),
          '${d['sous']}',
          '${d['total']}',
          n0(d['min']),
          unite(d['unite']! as UniteMesure),
          organisme('${d['organisme']}')),
      _ => i.message,
    };
  }
}

/// Raccourci : `context.l10n.moduleControle`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
