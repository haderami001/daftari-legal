// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get langue => 'Langue';

  @override
  String get langueSysteme => 'Langue du téléphone';

  @override
  String get langueFrancais => 'Français';

  @override
  String get langueArabe => 'العربية';

  @override
  String engin(String engin) {
    String _temp0 = intl.Intl.selectLogic(
      engin,
      {
        'ligne': 'Ligne / palangre',
        'filetMaillant': 'Filet maillant',
        'casier': 'Casier / pot à poulpe',
        'chalutDemersal': 'Chalut de fond',
        'chalutPelagique': 'Chalut pélagique',
        'senneTournante': 'Senne tournante',
        'drague': 'Drague',
        'other': '$engin',
      },
    );
    return '$_temp0';
  }

  @override
  String especeNom(String code) {
    String _temp0 = intl.Intl.selectLogic(
      code,
      {
        'OCC': 'Poulpe',
        'CTC': 'Seiche',
        'SAA': 'Sardinelle ronde',
        'SOL': 'Sole',
        'YFT': 'Albacore',
        'BFT': 'Thon rouge',
        'GPW': 'Mérou blanc',
        'MGR': 'Courbine',
        'MUF': 'Mulet jaune',
        'SOP': 'Crevette rose du large',
        'other': '$code',
      },
    );
    return '$_temp0';
  }

  @override
  String gravite(String gravite) {
    String _temp0 = intl.Intl.selectLogic(
      gravite,
      {
        'mineure': 'Mineure',
        'grave': 'Grave',
        'tresGrave': 'Très grave',
        'other': '$gravite',
      },
    );
    return '$_temp0';
  }

  @override
  String get uniteMm => 'mm';

  @override
  String get uniteCm => 'cm';

  @override
  String get uniteG => 'g';

  @override
  String get organismeCodePeches => 'Code des pêches (MRT)';

  @override
  String get valeursDemoDetail =>
      'Les seuils affichés doivent être validés avec les textes officiels avant toute utilisation.';

  @override
  String amendeIndicative(String min, String max) {
    return 'Amende indicative : $min à $max MRU';
  }

  @override
  String get conforme => 'Conforme';

  @override
  String get ajouter => 'Ajouter';

  @override
  String get mesureMaille => 'Mesure d\'une maille (mm)';

  @override
  String get espece => 'Espèce';

  @override
  String maillageMinimum(String min, String tolerance) {
    return 'Minimum : $min mm (tolérance $tolerance %)';
  }

  @override
  String get appTitle => 'Inspecteur des pêches';

  @override
  String get accueilSousTitre =>
      'Textes, calculs et nouveautés pour le contrôle des pêches';

  @override
  String get moduleCalculateurs => 'Calculateurs';

  @override
  String get moduleCalculateursDetail => 'Maillage, tailles minimales, amendes';

  @override
  String get moduleBibliotheque => 'Bibliothèque juridique';

  @override
  String get moduleBibliothequeDetail => 'Code des pêches, décrets, arrêtés';

  @override
  String get moduleNouveautes => 'Nouveautés réglementaires';

  @override
  String get moduleNouveautesDetail => 'Décrets et circulaires du ministère';

  @override
  String get bientot => 'Bientôt';

  @override
  String valeursDemoVersion(String version) {
    return 'Valeurs de démonstration ($version)';
  }

  @override
  String get ongletMaillage => 'Maillage';

  @override
  String get ongletTailles => 'Tailles minimales';

  @override
  String get enginLabel => 'Engin';

  @override
  String mesureEchantillon(String unite) {
    return 'Mesure ($unite)';
  }

  @override
  String mesuresSaisies(String liste) {
    return 'Mesures : $liste';
  }

  @override
  String get effacerMesures => 'Effacer les mesures';

  @override
  String get aucuneMesure => 'Ajoutez une ou plusieurs mesures.';

  @override
  String get pasDeMaillage => 'Pas de maillage réglementé pour cet engin.';

  @override
  String seuilRetenu(String seuil) {
    return 'Seuil retenu après tolérance : $seuil mm';
  }

  @override
  String moyenneMesuree(String moyenne) {
    return 'Moyenne mesurée : $moyenne mm';
  }

  @override
  String tailleMinimale(String min, String unite) {
    return 'Minimum : $min $unite';
  }

  @override
  String sousTaille(String sous, String total) {
    return '$sous sur $total sous le minimum';
  }

  @override
  String nonConforme(String gravite) {
    return 'Non conforme · $gravite';
  }

  @override
  String source(String organisme, String version) {
    return 'Source : $organisme · référentiel $version';
  }
}
