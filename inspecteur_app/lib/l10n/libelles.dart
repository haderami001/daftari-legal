import 'package:flutter/widgets.dart';
import 'package:peche_regles/peche_regles.dart';

import 'app_localizations.dart';

/// Libellés des valeurs du moteur de règles dans la langue de
/// l'utilisateur (les mêmes traductions que Pêche Conforme).
extension Libelles on AppLocalizations {
  String libelleEngin(TypeEngin e) => engin(e.name);

  String libelleGravite(Gravite g) => gravite(g.name);

  String nomEspece(String code) => especeNom(code);

  String unite(UniteMesure u) => switch (u) {
        UniteMesure.longueurCm => uniteCm,
        UniteMesure.poidsG => uniteG,
      };

  String organisme(String o) =>
      o == 'Code des pêches (MRT)' ? organismeCodePeches : o;
}

/// Raccourci : `context.l10n.appTitle`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
