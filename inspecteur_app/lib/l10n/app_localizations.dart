import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('fr')
  ];

  /// No description provided for @langue.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get langue;

  /// No description provided for @langueSysteme.
  ///
  /// In fr, this message translates to:
  /// **'Langue du téléphone'**
  String get langueSysteme;

  /// No description provided for @langueFrancais.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get langueFrancais;

  /// No description provided for @langueArabe.
  ///
  /// In fr, this message translates to:
  /// **'العربية'**
  String get langueArabe;

  /// No description provided for @engin.
  ///
  /// In fr, this message translates to:
  /// **'{engin, select, ligne{Ligne / palangre} filetMaillant{Filet maillant} casier{Casier / pot à poulpe} chalutDemersal{Chalut de fond} chalutPelagique{Chalut pélagique} senneTournante{Senne tournante} drague{Drague} other{{engin}}}'**
  String engin(String engin);

  /// No description provided for @especeNom.
  ///
  /// In fr, this message translates to:
  /// **'{code, select, OCC{Poulpe} CTC{Seiche} SAA{Sardinelle ronde} SOL{Sole} YFT{Albacore} BFT{Thon rouge} GPW{Mérou blanc} MGR{Courbine} MUF{Mulet jaune} SOP{Crevette rose du large} other{{code}}}'**
  String especeNom(String code);

  /// No description provided for @gravite.
  ///
  /// In fr, this message translates to:
  /// **'{gravite, select, mineure{Mineure} grave{Grave} tresGrave{Très grave} other{{gravite}}}'**
  String gravite(String gravite);

  /// No description provided for @uniteMm.
  ///
  /// In fr, this message translates to:
  /// **'mm'**
  String get uniteMm;

  /// No description provided for @uniteCm.
  ///
  /// In fr, this message translates to:
  /// **'cm'**
  String get uniteCm;

  /// No description provided for @uniteG.
  ///
  /// In fr, this message translates to:
  /// **'g'**
  String get uniteG;

  /// No description provided for @organismeCodePeches.
  ///
  /// In fr, this message translates to:
  /// **'Code des pêches (MRT)'**
  String get organismeCodePeches;

  /// No description provided for @valeursDemoDetail.
  ///
  /// In fr, this message translates to:
  /// **'Les seuils affichés doivent être validés avec les textes officiels avant toute utilisation.'**
  String get valeursDemoDetail;

  /// No description provided for @amendeIndicative.
  ///
  /// In fr, this message translates to:
  /// **'Amende indicative : {min} à {max} MRU'**
  String amendeIndicative(String min, String max);

  /// No description provided for @conforme.
  ///
  /// In fr, this message translates to:
  /// **'Conforme'**
  String get conforme;

  /// No description provided for @ajouter.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get ajouter;

  /// No description provided for @mesureMaille.
  ///
  /// In fr, this message translates to:
  /// **'Mesure d\'une maille (mm)'**
  String get mesureMaille;

  /// No description provided for @espece.
  ///
  /// In fr, this message translates to:
  /// **'Espèce'**
  String get espece;

  /// No description provided for @maillageMinimum.
  ///
  /// In fr, this message translates to:
  /// **'Minimum : {min} mm (tolérance {tolerance} %)'**
  String maillageMinimum(String min, String tolerance);

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inspecteur des pêches'**
  String get appTitle;

  /// No description provided for @accueilSousTitre.
  ///
  /// In fr, this message translates to:
  /// **'Textes, calculs et nouveautés pour le contrôle des pêches'**
  String get accueilSousTitre;

  /// No description provided for @moduleCalculateurs.
  ///
  /// In fr, this message translates to:
  /// **'Calculateurs'**
  String get moduleCalculateurs;

  /// No description provided for @moduleCalculateursDetail.
  ///
  /// In fr, this message translates to:
  /// **'Maillage, tailles minimales, amendes'**
  String get moduleCalculateursDetail;

  /// No description provided for @moduleBibliotheque.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque juridique'**
  String get moduleBibliotheque;

  /// No description provided for @moduleBibliothequeDetail.
  ///
  /// In fr, this message translates to:
  /// **'Code des pêches, décrets, arrêtés'**
  String get moduleBibliothequeDetail;

  /// No description provided for @moduleNouveautes.
  ///
  /// In fr, this message translates to:
  /// **'Nouveautés réglementaires'**
  String get moduleNouveautes;

  /// No description provided for @moduleNouveautesDetail.
  ///
  /// In fr, this message translates to:
  /// **'Décrets et circulaires du ministère'**
  String get moduleNouveautesDetail;

  /// No description provided for @bientot.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get bientot;

  /// No description provided for @valeursDemoVersion.
  ///
  /// In fr, this message translates to:
  /// **'Valeurs de démonstration ({version})'**
  String valeursDemoVersion(String version);

  /// No description provided for @ongletMaillage.
  ///
  /// In fr, this message translates to:
  /// **'Maillage'**
  String get ongletMaillage;

  /// No description provided for @ongletTailles.
  ///
  /// In fr, this message translates to:
  /// **'Tailles minimales'**
  String get ongletTailles;

  /// No description provided for @enginLabel.
  ///
  /// In fr, this message translates to:
  /// **'Engin'**
  String get enginLabel;

  /// No description provided for @mesureEchantillon.
  ///
  /// In fr, this message translates to:
  /// **'Mesure ({unite})'**
  String mesureEchantillon(String unite);

  /// No description provided for @mesuresSaisies.
  ///
  /// In fr, this message translates to:
  /// **'Mesures : {liste}'**
  String mesuresSaisies(String liste);

  /// No description provided for @effacerMesures.
  ///
  /// In fr, this message translates to:
  /// **'Effacer les mesures'**
  String get effacerMesures;

  /// No description provided for @aucuneMesure.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez une ou plusieurs mesures.'**
  String get aucuneMesure;

  /// No description provided for @pasDeMaillage.
  ///
  /// In fr, this message translates to:
  /// **'Pas de maillage réglementé pour cet engin.'**
  String get pasDeMaillage;

  /// No description provided for @seuilRetenu.
  ///
  /// In fr, this message translates to:
  /// **'Seuil retenu après tolérance : {seuil} mm'**
  String seuilRetenu(String seuil);

  /// No description provided for @moyenneMesuree.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne mesurée : {moyenne} mm'**
  String moyenneMesuree(String moyenne);

  /// No description provided for @tailleMinimale.
  ///
  /// In fr, this message translates to:
  /// **'Minimum : {min} {unite}'**
  String tailleMinimale(String min, String unite);

  /// No description provided for @sousTaille.
  ///
  /// In fr, this message translates to:
  /// **'{sous} sur {total} sous le minimum'**
  String sousTaille(String sous, String total);

  /// No description provided for @nonConforme.
  ///
  /// In fr, this message translates to:
  /// **'Non conforme · {gravite}'**
  String nonConforme(String gravite);

  /// No description provided for @source.
  ///
  /// In fr, this message translates to:
  /// **'Source : {organisme} · référentiel {version}'**
  String source(String organisme, String version);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
