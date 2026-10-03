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

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'Pêche Conforme'**
  String get appTitle;

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

  /// No description provided for @moduleDeclaration.
  ///
  /// In fr, this message translates to:
  /// **'Déclaration du capitaine'**
  String get moduleDeclaration;

  /// No description provided for @moduleDeclarationDetail.
  ///
  /// In fr, this message translates to:
  /// **'Navire, licence, équipage, captures'**
  String get moduleDeclarationDetail;

  /// No description provided for @moduleControle.
  ///
  /// In fr, this message translates to:
  /// **'Contrôle garde-côtes'**
  String get moduleControle;

  /// No description provided for @moduleControleDetail.
  ///
  /// In fr, this message translates to:
  /// **'Inspection, maillage, échantillons, rapport'**
  String get moduleControleDetail;

  /// No description provided for @moduleGuide.
  ///
  /// In fr, this message translates to:
  /// **'Guide réglementaire'**
  String get moduleGuide;

  /// No description provided for @moduleGuideDetail.
  ///
  /// In fr, this message translates to:
  /// **'Code des pêches, FAO, ICCAT, UE-Mauritanie'**
  String get moduleGuideDetail;

  /// No description provided for @moduleEnvois.
  ///
  /// In fr, this message translates to:
  /// **'Envois en attente'**
  String get moduleEnvois;

  /// No description provided for @envoisLecture.
  ///
  /// In fr, this message translates to:
  /// **'Lecture de la base locale…'**
  String get envoisLecture;

  /// No description provided for @envoisToutSynchronise.
  ///
  /// In fr, this message translates to:
  /// **'Tout est synchronisé'**
  String get envoisToutSynchronise;

  /// No description provided for @envoisAEnvoyer.
  ///
  /// In fr, this message translates to:
  /// **'{n, plural, =1{1 saisie à envoyer au serveur} other{{n} saisies à envoyer au serveur}}'**
  String envoisAEnvoyer(int n);

  /// No description provided for @aucunNavire.
  ///
  /// In fr, this message translates to:
  /// **'Aucun navire avec licence dans la base locale.'**
  String get aucunNavire;

  /// No description provided for @annuler.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get annuler;

  /// No description provided for @ajouter.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get ajouter;

  /// No description provided for @suivant.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get suivant;

  /// No description provided for @retour.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get retour;

  /// No description provided for @fermer.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get fermer;

  /// No description provided for @signer.
  ///
  /// In fr, this message translates to:
  /// **'Signer'**
  String get signer;

  /// No description provided for @gpsRecherche.
  ///
  /// In fr, this message translates to:
  /// **'recherche du GPS…'**
  String get gpsRecherche;

  /// No description provided for @gpsNonMesuree.
  ///
  /// In fr, this message translates to:
  /// **'(non mesurée)'**
  String get gpsNonMesuree;

  /// No description provided for @echecEnregistrement.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'enregistrement : {erreur}'**
  String echecEnregistrement(String erreur);

  /// No description provided for @navire.
  ///
  /// In fr, this message translates to:
  /// **'Navire'**
  String get navire;

  /// No description provided for @immatriculation.
  ///
  /// In fr, this message translates to:
  /// **'Immatriculation'**
  String get immatriculation;

  /// No description provided for @pavillon.
  ///
  /// In fr, this message translates to:
  /// **'Pavillon'**
  String get pavillon;

  /// No description provided for @numeroImo.
  ///
  /// In fr, this message translates to:
  /// **'N° IMO'**
  String get numeroImo;

  /// No description provided for @licence.
  ///
  /// In fr, this message translates to:
  /// **'Licence'**
  String get licence;

  /// No description provided for @positionGps.
  ///
  /// In fr, this message translates to:
  /// **'Position GPS'**
  String get positionGps;

  /// No description provided for @espece.
  ///
  /// In fr, this message translates to:
  /// **'Espèce'**
  String get espece;

  /// No description provided for @numero.
  ///
  /// In fr, this message translates to:
  /// **'n° {id}'**
  String numero(String id);

  /// No description provided for @uniteKg.
  ///
  /// In fr, this message translates to:
  /// **'kg'**
  String get uniteKg;

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

  /// No description provided for @signerEtEnvoyer.
  ///
  /// In fr, this message translates to:
  /// **'Signer et envoyer'**
  String get signerEtEnvoyer;

  /// No description provided for @etapeNavire.
  ///
  /// In fr, this message translates to:
  /// **'Navire & licence'**
  String get etapeNavire;

  /// No description provided for @etapeEquipage.
  ///
  /// In fr, this message translates to:
  /// **'Équipage ({n})'**
  String etapeEquipage(int n);

  /// No description provided for @etapeCaptures.
  ///
  /// In fr, this message translates to:
  /// **'Captures ({n})'**
  String etapeCaptures(int n);

  /// No description provided for @etapeVerification.
  ///
  /// In fr, this message translates to:
  /// **'Vérification'**
  String get etapeVerification;

  /// No description provided for @enginUtilise.
  ///
  /// In fr, this message translates to:
  /// **'Engin utilisé'**
  String get enginUtilise;

  /// No description provided for @ajouterMembre.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un membre'**
  String get ajouterMembre;

  /// No description provided for @membreEquipage.
  ///
  /// In fr, this message translates to:
  /// **'Membre d\'équipage'**
  String get membreEquipage;

  /// No description provided for @nomComplet.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get nomComplet;

  /// No description provided for @fonction.
  ///
  /// In fr, this message translates to:
  /// **'Fonction'**
  String get fonction;

  /// No description provided for @fonctionParDefaut.
  ///
  /// In fr, this message translates to:
  /// **'Matelot'**
  String get fonctionParDefaut;

  /// No description provided for @nationalite.
  ///
  /// In fr, this message translates to:
  /// **'Nationalité'**
  String get nationalite;

  /// No description provided for @especeCible.
  ///
  /// In fr, this message translates to:
  /// **'Espèce cible'**
  String get especeCible;

  /// No description provided for @priseAccessoire.
  ///
  /// In fr, this message translates to:
  /// **'Prise accessoire'**
  String get priseAccessoire;

  /// No description provided for @ajouterCapture.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une capture'**
  String get ajouterCapture;

  /// No description provided for @capture.
  ///
  /// In fr, this message translates to:
  /// **'Capture'**
  String get capture;

  /// No description provided for @poidsKg.
  ///
  /// In fr, this message translates to:
  /// **'Poids (kg)'**
  String get poidsKg;

  /// No description provided for @poidsTotal.
  ///
  /// In fr, this message translates to:
  /// **'Poids total'**
  String get poidsTotal;

  /// No description provided for @prisesAccessoires.
  ///
  /// In fr, this message translates to:
  /// **'Prises accessoires'**
  String get prisesAccessoires;

  /// No description provided for @quota.
  ///
  /// In fr, this message translates to:
  /// **'Quota {espece}'**
  String quota(String espece);

  /// No description provided for @declarationEnregistree.
  ///
  /// In fr, this message translates to:
  /// **'Déclaration {id} enregistrée sur le téléphone — envoi à la prochaine connexion réseau.'**
  String declarationEnregistree(String id);

  /// No description provided for @sectionNavire.
  ///
  /// In fr, this message translates to:
  /// **'1. Navire'**
  String get sectionNavire;

  /// No description provided for @navireInspecte.
  ///
  /// In fr, this message translates to:
  /// **'Navire inspecté'**
  String get navireInspecte;

  /// No description provided for @detailsNavire.
  ///
  /// In fr, this message translates to:
  /// **'Pavillon : {pavillon} · {type} · {longueur} m · {puissance} kW'**
  String detailsNavire(
      String pavillon, String type, String longueur, String puissance);

  /// No description provided for @licenceNumero.
  ///
  /// In fr, this message translates to:
  /// **'Licence : {numero}'**
  String licenceNumero(String numero);

  /// No description provided for @positionValeur.
  ///
  /// In fr, this message translates to:
  /// **'Position : {position}'**
  String positionValeur(String position);

  /// No description provided for @pavillonConcordant.
  ///
  /// In fr, this message translates to:
  /// **'Pavillon et documents de bord concordants'**
  String get pavillonConcordant;

  /// No description provided for @marquageVisible.
  ///
  /// In fr, this message translates to:
  /// **'Marquage / immatriculation visible'**
  String get marquageVisible;

  /// No description provided for @sectionCertificats.
  ///
  /// In fr, this message translates to:
  /// **'2. Certificats'**
  String get sectionCertificats;

  /// No description provided for @certificatExpireLe.
  ///
  /// In fr, this message translates to:
  /// **'{numero} · expire le {date}'**
  String certificatExpireLe(String numero, String date);

  /// No description provided for @sectionEngin.
  ///
  /// In fr, this message translates to:
  /// **'3. Engin et maillage'**
  String get sectionEngin;

  /// No description provided for @enginABord.
  ///
  /// In fr, this message translates to:
  /// **'Engin à bord'**
  String get enginABord;

  /// No description provided for @maillageMinimum.
  ///
  /// In fr, this message translates to:
  /// **'Minimum : {min} mm (tolérance {tolerance} %)'**
  String maillageMinimum(String min, String tolerance);

  /// No description provided for @mesureMaille.
  ///
  /// In fr, this message translates to:
  /// **'Mesure d\'une maille (mm)'**
  String get mesureMaille;

  /// No description provided for @pasDeMaillage.
  ///
  /// In fr, this message translates to:
  /// **'Pas de maillage réglementé pour cet engin.'**
  String get pasDeMaillage;

  /// No description provided for @sectionEchantillons.
  ///
  /// In fr, this message translates to:
  /// **'4. Échantillons (tailles minimales)'**
  String get sectionEchantillons;

  /// No description provided for @especeMinimum.
  ///
  /// In fr, this message translates to:
  /// **'{espece} — min {min} {unite}'**
  String especeMinimum(String espece, String min, String unite);

  /// No description provided for @mesureUnite.
  ///
  /// In fr, this message translates to:
  /// **'Mesure ({unite})'**
  String mesureUnite(String unite);

  /// No description provided for @sectionStockage.
  ///
  /// In fr, this message translates to:
  /// **'5. Plan de stockage'**
  String get sectionStockage;

  /// No description provided for @calesConformes.
  ///
  /// In fr, this message translates to:
  /// **'Cales conformes au plan de stockage et au journal'**
  String get calesConformes;

  /// No description provided for @observations.
  ///
  /// In fr, this message translates to:
  /// **'Observations'**
  String get observations;

  /// No description provided for @genererRapport.
  ///
  /// In fr, this message translates to:
  /// **'Générer le rapport d\'inspection'**
  String get genererRapport;

  /// No description provided for @rapportGenere.
  ///
  /// In fr, this message translates to:
  /// **'Rapport généré'**
  String get rapportGenere;

  /// No description provided for @rapportLangue.
  ///
  /// In fr, this message translates to:
  /// **'Le rapport officiel est rédigé en français.'**
  String get rapportLangue;

  /// No description provided for @rapportEnregistre.
  ///
  /// In fr, this message translates to:
  /// **'Rapport {id} signé et enregistré — envoi à la prochaine connexion réseau.'**
  String rapportEnregistre(String id);

  /// No description provided for @rapportPdfTitre.
  ///
  /// In fr, this message translates to:
  /// **'Rapport d\'inspection (PDF)'**
  String get rapportPdfTitre;

  /// No description provided for @apercuIndisponible.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu indisponible sur cet appareil.\nUtilisez Partager ou Imprimer.\n({erreur})'**
  String apercuIndisponible(String erreur);

  /// No description provided for @conforme.
  ///
  /// In fr, this message translates to:
  /// **'Conforme'**
  String get conforme;

  /// No description provided for @aucuneNonConformite.
  ///
  /// In fr, this message translates to:
  /// **'Aucune non-conformité détectée.'**
  String get aucuneNonConformite;

  /// No description provided for @nonConformites.
  ///
  /// In fr, this message translates to:
  /// **'{n, plural, =1{1 non-conformité} other{{n} non-conformités}}'**
  String nonConformites(int n);

  /// No description provided for @amendeIndicative.
  ///
  /// In fr, this message translates to:
  /// **'Amende indicative : {min} à {max} MRU'**
  String amendeIndicative(String min, String max);

  /// No description provided for @envoyerMaintenant.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer maintenant'**
  String get envoyerMaintenant;

  /// No description provided for @toutEnvoye.
  ///
  /// In fr, this message translates to:
  /// **'Tout a été envoyé.'**
  String get toutEnvoye;

  /// No description provided for @saisiesStockees.
  ///
  /// In fr, this message translates to:
  /// **'{n, plural, =1{1 saisie stockée sur le téléphone} other{{n} saisies stockées sur le téléphone}}'**
  String saisiesStockees(int n);

  /// No description provided for @retourReseau.
  ///
  /// In fr, this message translates to:
  /// **'Elles partiront automatiquement au retour du réseau.'**
  String get retourReseau;

  /// No description provided for @echecs.
  ///
  /// In fr, this message translates to:
  /// **'{n, plural, =1{1 échec} other{{n} échecs}}'**
  String echecs(int n);

  /// No description provided for @typeDeclaration.
  ///
  /// In fr, this message translates to:
  /// **'Déclaration'**
  String get typeDeclaration;

  /// No description provided for @typeControle.
  ///
  /// In fr, this message translates to:
  /// **'Contrôle'**
  String get typeControle;

  /// No description provided for @pasDePdf.
  ///
  /// In fr, this message translates to:
  /// **'Pas de PDF pour ce contrôle (version antérieure).'**
  String get pasDePdf;

  /// No description provided for @serveurNonConfigure.
  ///
  /// In fr, this message translates to:
  /// **'Serveur non configuré : les saisies restent sur le téléphone (paramètre API_URL).'**
  String get serveurNonConfigure;

  /// No description provided for @envoiDejaEnCours.
  ///
  /// In fr, this message translates to:
  /// **'Envoi déjà en cours.'**
  String get envoiDejaEnCours;

  /// No description provided for @resultatEnvoi.
  ///
  /// In fr, this message translates to:
  /// **'{envoyes} envoyé(s), {echecs} échec(s)'**
  String resultatEnvoi(int envoyes, int echecs);

  /// No description provided for @valeursDemo.
  ///
  /// In fr, this message translates to:
  /// **'Valeurs de démonstration'**
  String get valeursDemo;

  /// No description provided for @valeursDemoDetail.
  ///
  /// In fr, this message translates to:
  /// **'Les seuils affichés doivent être validés avec les textes officiels avant toute utilisation.'**
  String get valeursDemoDetail;

  /// No description provided for @texteCodeTitre.
  ///
  /// In fr, this message translates to:
  /// **'Code des pêches maritimes (Mauritanie)'**
  String get texteCodeTitre;

  /// No description provided for @texteCodeResume.
  ///
  /// In fr, this message translates to:
  /// **'Loi n° 2015-017 et ses décrets/arrêtés d\'application : licences, zones, engins, tailles minimales, infractions et sanctions.'**
  String get texteCodeResume;

  /// No description provided for @textePsmaTitre.
  ///
  /// In fr, this message translates to:
  /// **'FAO — Accord sur les mesures du ressort de l\'État du port (PSMA)'**
  String get textePsmaTitre;

  /// No description provided for @textePsmaResume.
  ///
  /// In fr, this message translates to:
  /// **'Lutte contre la pêche INN : contrôle au port des navires étrangers, refus d\'accès, échange d\'informations.'**
  String get textePsmaResume;

  /// No description provided for @texteConduiteTitre.
  ///
  /// In fr, this message translates to:
  /// **'FAO — Code de conduite pour une pêche responsable'**
  String get texteConduiteTitre;

  /// No description provided for @texteConduiteResume.
  ///
  /// In fr, this message translates to:
  /// **'Principes de gestion durable, sélectivité des engins, réduction des prises accessoires.'**
  String get texteConduiteResume;

  /// No description provided for @texteIccatTitre.
  ///
  /// In fr, this message translates to:
  /// **'ICCAT'**
  String get texteIccatTitre;

  /// No description provided for @texteIccatResume.
  ///
  /// In fr, this message translates to:
  /// **'Recommandations sur les thonidés de l\'Atlantique : tailles minimales, quotas, déclaration des captures, observateurs.'**
  String get texteIccatResume;

  /// No description provided for @texteUeTitre.
  ///
  /// In fr, this message translates to:
  /// **'Accord de partenariat UE-Mauritanie (APPD)'**
  String get texteUeTitre;

  /// No description provided for @texteUeResume.
  ///
  /// In fr, this message translates to:
  /// **'Protocole en vigueur : catégories de pêche, possibilités de pêche, débarquements, embarquement de marins mauritaniens, VMS / ERS.'**
  String get texteUeResume;

  /// No description provided for @taillesMinimales.
  ///
  /// In fr, this message translates to:
  /// **'Tailles minimales ({version})'**
  String taillesMinimales(String version);

  /// No description provided for @maillagesEtPrises.
  ///
  /// In fr, this message translates to:
  /// **'Maillages et prises accessoires'**
  String get maillagesEtPrises;

  /// No description provided for @prisesAccessoiresMax.
  ///
  /// In fr, this message translates to:
  /// **'Prises accessoires max : {pct} %'**
  String prisesAccessoiresMax(String pct);

  /// No description provided for @organismeCodePeches.
  ///
  /// In fr, this message translates to:
  /// **'Code des pêches (MRT)'**
  String get organismeCodePeches;

  /// No description provided for @engin.
  ///
  /// In fr, this message translates to:
  /// **'{engin, select, ligne{Ligne / palangre} filetMaillant{Filet maillant} casier{Casier / pot à poulpe} chalutDemersal{Chalut de fond} chalutPelagique{Chalut pélagique} senneTournante{Senne tournante} drague{Drague} other{{engin}}}'**
  String engin(String engin);

  /// No description provided for @typeNavire.
  ///
  /// In fr, this message translates to:
  /// **'{type, select, pirogue{Pirogue} chalutier{Chalutier} senneur{Senneur} dragueur{Dragueur} other{{type}}}'**
  String typeNavire(String type);

  /// No description provided for @segment.
  ///
  /// In fr, this message translates to:
  /// **'{segment, select, artisanale{Pêche artisanale} cotiere{Pêche côtière} hauturiere{Pêche hauturière} other{{segment}}}'**
  String segment(String segment);

  /// No description provided for @gravite.
  ///
  /// In fr, this message translates to:
  /// **'{gravite, select, mineure{Mineure} grave{Grave} tresGrave{Très grave} other{{gravite}}}'**
  String gravite(String gravite);

  /// No description provided for @certificat.
  ///
  /// In fr, this message translates to:
  /// **'{certificat, select, navigabilite{Certificat de navigabilité} jaugeage{Certificat de jaugeage} hygiene{Agrément sanitaire} radio{Licence radio / VMS} other{{certificat}}}'**
  String certificat(String certificat);

  /// No description provided for @especeNom.
  ///
  /// In fr, this message translates to:
  /// **'{code, select, OCC{Poulpe} CTC{Seiche} SAA{Sardinelle ronde} SOL{Sole} YFT{Albacore} BFT{Thon rouge} other{{code}}}'**
  String especeNom(String code);

  /// No description provided for @infLicenceInvalide.
  ///
  /// In fr, this message translates to:
  /// **'Licence {licence} non valide à cette date.'**
  String infLicenceInvalide(String licence);

  /// No description provided for @infEnginNonAutorise.
  ///
  /// In fr, this message translates to:
  /// **'Engin « {engin} » non autorisé par la licence.'**
  String infEnginNonAutorise(String engin);

  /// No description provided for @infCertificatExpire.
  ///
  /// In fr, this message translates to:
  /// **'{certificat} n° {numero} expiré.'**
  String infCertificatExpire(String certificat, String numero);

  /// No description provided for @infQuotaDepasse.
  ///
  /// In fr, this message translates to:
  /// **'Quota {espece} dépassé : {poids} kg pour {quota} kg autorisés.'**
  String infQuotaDepasse(String espece, String poids, String quota);

  /// No description provided for @infPrisesAccessoires.
  ///
  /// In fr, this message translates to:
  /// **'Prises accessoires {pct} % (max {max} % pour {engin}).'**
  String infPrisesAccessoires(String pct, String max, String engin);

  /// No description provided for @infPavillon.
  ///
  /// In fr, this message translates to:
  /// **'Pavillon / identification du navire non conforme.'**
  String get infPavillon;

  /// No description provided for @infMarquage.
  ///
  /// In fr, this message translates to:
  /// **'Marquage extérieur (immatriculation) absent ou illisible.'**
  String get infMarquage;

  /// No description provided for @infStockage.
  ///
  /// In fr, this message translates to:
  /// **'Plan de stockage en cale non conforme à la déclaration.'**
  String get infStockage;

  /// No description provided for @infMaillage.
  ///
  /// In fr, this message translates to:
  /// **'Maillage moyen {moyenne} mm < {min} mm requis ({engin}).'**
  String infMaillage(String moyenne, String min, String engin);

  /// No description provided for @infTailleMin.
  ///
  /// In fr, this message translates to:
  /// **'{espece} : {sous}/{total} individus sous {min} {unite} ({organisme}).'**
  String infTailleMin(String espece, String sous, String total, String min,
      String unite, String organisme);

  /// No description provided for @connexionSousTitre.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous avec votre compte'**
  String get connexionSousTitre;

  /// No description provided for @identifiant.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant'**
  String get identifiant;

  /// No description provided for @motDePasse.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get motDePasse;

  /// No description provided for @seConnecter.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get seConnecter;

  /// No description provided for @connexionChampsVides.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre identifiant et votre mot de passe.'**
  String get connexionChampsVides;

  /// No description provided for @connexionIdentifiants.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant ou mot de passe incorrect.'**
  String get connexionIdentifiants;

  /// No description provided for @connexionReseau.
  ///
  /// In fr, this message translates to:
  /// **'Pas de réseau : la première connexion doit se faire à terre.'**
  String get connexionReseau;

  /// No description provided for @connexionServeur.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur de connexion ne répond pas. Réessayez plus tard.'**
  String get connexionServeur;

  /// No description provided for @deconnexion.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get deconnexion;

  /// No description provided for @compte.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get compte;

  /// No description provided for @aucunModule.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte n\'a pas de rôle de saisie (capitaine ou agent).'**
  String get aucunModule;

  /// No description provided for @referentielMisAJour.
  ///
  /// In fr, this message translates to:
  /// **'Référentiel des navires mis à jour'**
  String get referentielMisAJour;

  /// No description provided for @moduleAdministration.
  ///
  /// In fr, this message translates to:
  /// **'Navires et licences'**
  String get moduleAdministration;

  /// No description provided for @moduleAdministrationDetail.
  ///
  /// In fr, this message translates to:
  /// **'Gérer le référentiel central (administrateur)'**
  String get moduleAdministrationDetail;

  /// No description provided for @ongletNavires.
  ///
  /// In fr, this message translates to:
  /// **'Navires'**
  String get ongletNavires;

  /// No description provided for @ongletLicences.
  ///
  /// In fr, this message translates to:
  /// **'Licences'**
  String get ongletLicences;

  /// No description provided for @ajouterNavire.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un navire'**
  String get ajouterNavire;

  /// No description provided for @ajouterLicence.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une licence'**
  String get ajouterLicence;

  /// No description provided for @modifierNavire.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le navire'**
  String get modifierNavire;

  /// No description provided for @modifierLicence.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la licence'**
  String get modifierLicence;

  /// No description provided for @actualiser.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get actualiser;

  /// No description provided for @champIdentifiant.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant (ex. N4)'**
  String get champIdentifiant;

  /// No description provided for @champNom.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get champNom;

  /// No description provided for @champImmatriculation.
  ///
  /// In fr, this message translates to:
  /// **'Immatriculation'**
  String get champImmatriculation;

  /// No description provided for @champPavillon.
  ///
  /// In fr, this message translates to:
  /// **'Pavillon (code à 3 lettres, ex. MRT)'**
  String get champPavillon;

  /// No description provided for @champTypeNavire.
  ///
  /// In fr, this message translates to:
  /// **'Type de navire'**
  String get champTypeNavire;

  /// No description provided for @champLongueur.
  ///
  /// In fr, this message translates to:
  /// **'Longueur (m)'**
  String get champLongueur;

  /// No description provided for @champPuissance.
  ///
  /// In fr, this message translates to:
  /// **'Puissance (kW)'**
  String get champPuissance;

  /// No description provided for @champImo.
  ///
  /// In fr, this message translates to:
  /// **'Numéro OMI (facultatif, 7 chiffres)'**
  String get champImo;

  /// No description provided for @certificats.
  ///
  /// In fr, this message translates to:
  /// **'Certificats'**
  String get certificats;

  /// No description provided for @ajouterCertificat.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un certificat'**
  String get ajouterCertificat;

  /// No description provided for @champNumero.
  ///
  /// In fr, this message translates to:
  /// **'Numéro'**
  String get champNumero;

  /// No description provided for @champExpiration.
  ///
  /// In fr, this message translates to:
  /// **'Expiration'**
  String get champExpiration;

  /// No description provided for @champNumeroLicence.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de licence'**
  String get champNumeroLicence;

  /// No description provided for @champNavire.
  ///
  /// In fr, this message translates to:
  /// **'Navire'**
  String get champNavire;

  /// No description provided for @champSegment.
  ///
  /// In fr, this message translates to:
  /// **'Segment'**
  String get champSegment;

  /// No description provided for @enginsAutorises.
  ///
  /// In fr, this message translates to:
  /// **'Engins autorisés'**
  String get enginsAutorises;

  /// No description provided for @champEspeces.
  ///
  /// In fr, this message translates to:
  /// **'Espèces ciblées (codes FAO séparés par des virgules)'**
  String get champEspeces;

  /// No description provided for @champDebut.
  ///
  /// In fr, this message translates to:
  /// **'Début'**
  String get champDebut;

  /// No description provided for @champFin.
  ///
  /// In fr, this message translates to:
  /// **'Fin'**
  String get champFin;

  /// No description provided for @quotas.
  ///
  /// In fr, this message translates to:
  /// **'Quotas (kg)'**
  String get quotas;

  /// No description provided for @ajouterQuota.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un quota'**
  String get ajouterQuota;

  /// No description provided for @champEspece.
  ///
  /// In fr, this message translates to:
  /// **'Espèce (code FAO)'**
  String get champEspece;

  /// No description provided for @champKg.
  ///
  /// In fr, this message translates to:
  /// **'kg'**
  String get champKg;

  /// No description provided for @supprimer.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get supprimer;

  /// No description provided for @enregistrer.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get enregistrer;

  /// No description provided for @navireEnregistre.
  ///
  /// In fr, this message translates to:
  /// **'Navire enregistré'**
  String get navireEnregistre;

  /// No description provided for @licenceEnregistree.
  ///
  /// In fr, this message translates to:
  /// **'Licence enregistrée'**
  String get licenceEnregistree;

  /// No description provided for @champObligatoire.
  ///
  /// In fr, this message translates to:
  /// **'Obligatoire'**
  String get champObligatoire;

  /// No description provided for @nombreInvalide.
  ///
  /// In fr, this message translates to:
  /// **'Nombre invalide'**
  String get nombreInvalide;

  /// No description provided for @choisirDate.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une date'**
  String get choisirDate;

  /// No description provided for @aucunElement.
  ///
  /// In fr, this message translates to:
  /// **'Aucun élément pour l\'instant'**
  String get aucunElement;

  /// No description provided for @adminRefus.
  ///
  /// In fr, this message translates to:
  /// **'Refusé par le serveur : {message}'**
  String adminRefus(String message);

  /// No description provided for @adminChargement.
  ///
  /// In fr, this message translates to:
  /// **'Chargement impossible : {message}'**
  String adminChargement(String message);

  /// No description provided for @licenceDe.
  ///
  /// In fr, this message translates to:
  /// **'{numero} — navire {navire}'**
  String licenceDe(String numero, String navire);

  /// No description provided for @confirmerSuppression.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer « {nom} » ?'**
  String confirmerSuppression(String nom);

  /// No description provided for @suppressionExplication.
  ///
  /// In fr, this message translates to:
  /// **'Il disparaîtra des listes et des téléphones à la prochaine synchronisation. Les déclarations et contrôles déjà faits sont conservés.'**
  String get suppressionExplication;

  /// No description provided for @navireSupprime.
  ///
  /// In fr, this message translates to:
  /// **'Navire supprimé'**
  String get navireSupprime;

  /// No description provided for @licenceSupprimee.
  ///
  /// In fr, this message translates to:
  /// **'Licence supprimée'**
  String get licenceSupprimee;
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
