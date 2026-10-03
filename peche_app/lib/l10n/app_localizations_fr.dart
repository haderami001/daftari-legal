import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Pêche Conforme';

  @override
  String get langue => 'Langue';

  @override
  String get langueSysteme => 'Langue du téléphone';

  @override
  String get langueFrancais => 'Français';

  @override
  String get langueArabe => 'العربية';

  @override
  String get moduleDeclaration => 'Déclaration du capitaine';

  @override
  String get moduleDeclarationDetail => 'Navire, licence, équipage, captures';

  @override
  String get moduleControle => 'Contrôle garde-côtes';

  @override
  String get moduleControleDetail =>
      'Inspection, maillage, échantillons, rapport';

  @override
  String get moduleGuide => 'Guide réglementaire';

  @override
  String get moduleGuideDetail => 'Code des pêches, FAO, ICCAT, UE-Mauritanie';

  @override
  String get moduleEnvois => 'Envois en attente';

  @override
  String get envoisLecture => 'Lecture de la base locale…';

  @override
  String get envoisToutSynchronise => 'Tout est synchronisé';

  @override
  String envoisAEnvoyer(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n saisies à envoyer au serveur',
      one: '1 saisie à envoyer au serveur',
    );
    return '$_temp0';
  }

  @override
  String get aucunNavire => 'Aucun navire avec licence dans la base locale.';

  @override
  String get annuler => 'Annuler';

  @override
  String get ajouter => 'Ajouter';

  @override
  String get suivant => 'Suivant';

  @override
  String get retour => 'Retour';

  @override
  String get fermer => 'Fermer';

  @override
  String get signer => 'Signer';

  @override
  String get gpsRecherche => 'recherche du GPS…';

  @override
  String get gpsNonMesuree => '(non mesurée)';

  @override
  String echecEnregistrement(String erreur) {
    return 'Échec de l\'enregistrement : $erreur';
  }

  @override
  String get navire => 'Navire';

  @override
  String get immatriculation => 'Immatriculation';

  @override
  String get pavillon => 'Pavillon';

  @override
  String get numeroImo => 'N° IMO';

  @override
  String get licence => 'Licence';

  @override
  String get positionGps => 'Position GPS';

  @override
  String get espece => 'Espèce';

  @override
  String numero(String id) {
    return 'n° $id';
  }

  @override
  String get uniteKg => 'kg';

  @override
  String get uniteMm => 'mm';

  @override
  String get uniteCm => 'cm';

  @override
  String get uniteG => 'g';

  @override
  String get signerEtEnvoyer => 'Signer et envoyer';

  @override
  String get etapeNavire => 'Navire & licence';

  @override
  String etapeEquipage(int n) {
    return 'Équipage ($n)';
  }

  @override
  String etapeCaptures(int n) {
    return 'Captures ($n)';
  }

  @override
  String get etapeVerification => 'Vérification';

  @override
  String get enginUtilise => 'Engin utilisé';

  @override
  String get ajouterMembre => 'Ajouter un membre';

  @override
  String get membreEquipage => 'Membre d\'équipage';

  @override
  String get nomComplet => 'Nom complet';

  @override
  String get fonction => 'Fonction';

  @override
  String get fonctionParDefaut => 'Matelot';

  @override
  String get nationalite => 'Nationalité';

  @override
  String get especeCible => 'Espèce cible';

  @override
  String get priseAccessoire => 'Prise accessoire';

  @override
  String get ajouterCapture => 'Ajouter une capture';

  @override
  String get capture => 'Capture';

  @override
  String get poidsKg => 'Poids (kg)';

  @override
  String get poidsTotal => 'Poids total';

  @override
  String get prisesAccessoires => 'Prises accessoires';

  @override
  String quota(String espece) {
    return 'Quota $espece';
  }

  @override
  String declarationEnregistree(String id) {
    return 'Déclaration $id enregistrée sur le téléphone — envoi à la prochaine connexion réseau.';
  }

  @override
  String get sectionNavire => '1. Navire';

  @override
  String get navireInspecte => 'Navire inspecté';

  @override
  String detailsNavire(
      String pavillon, String type, String longueur, String puissance) {
    return 'Pavillon : $pavillon · $type · $longueur m · $puissance kW';
  }

  @override
  String licenceNumero(String numero) {
    return 'Licence : $numero';
  }

  @override
  String positionValeur(String position) {
    return 'Position : $position';
  }

  @override
  String get pavillonConcordant => 'Pavillon et documents de bord concordants';

  @override
  String get marquageVisible => 'Marquage / immatriculation visible';

  @override
  String get sectionCertificats => '2. Certificats';

  @override
  String certificatExpireLe(String numero, String date) {
    return '$numero · expire le $date';
  }

  @override
  String get sectionEngin => '3. Engin et maillage';

  @override
  String get enginABord => 'Engin à bord';

  @override
  String maillageMinimum(String min, String tolerance) {
    return 'Minimum : $min mm (tolérance $tolerance %)';
  }

  @override
  String get mesureMaille => 'Mesure d\'une maille (mm)';

  @override
  String get pasDeMaillage => 'Pas de maillage réglementé pour cet engin.';

  @override
  String get sectionEchantillons => '4. Échantillons (tailles minimales)';

  @override
  String especeMinimum(String espece, String min, String unite) {
    return '$espece — min $min $unite';
  }

  @override
  String mesureUnite(String unite) {
    return 'Mesure ($unite)';
  }

  @override
  String get sectionStockage => '5. Plan de stockage';

  @override
  String get calesConformes =>
      'Cales conformes au plan de stockage et au journal';

  @override
  String get observations => 'Observations';

  @override
  String get genererRapport => 'Générer le rapport d\'inspection';

  @override
  String get rapportGenere => 'Rapport généré';

  @override
  String get rapportLangue => 'Le rapport officiel est rédigé en français.';

  @override
  String rapportEnregistre(String id) {
    return 'Rapport $id signé et enregistré — envoi à la prochaine connexion réseau.';
  }

  @override
  String get rapportPdfTitre => 'Rapport d\'inspection (PDF)';

  @override
  String apercuIndisponible(String erreur) {
    return 'Aperçu indisponible sur cet appareil.\nUtilisez Partager ou Imprimer.\n($erreur)';
  }

  @override
  String get conforme => 'Conforme';

  @override
  String get aucuneNonConformite => 'Aucune non-conformité détectée.';

  @override
  String nonConformites(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n non-conformités',
      one: '1 non-conformité',
    );
    return '$_temp0';
  }

  @override
  String amendeIndicative(String min, String max) {
    return 'Amende indicative : $min à $max MRU';
  }

  @override
  String get envoyerMaintenant => 'Envoyer maintenant';

  @override
  String get toutEnvoye => 'Tout a été envoyé.';

  @override
  String saisiesStockees(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n saisies stockées sur le téléphone',
      one: '1 saisie stockée sur le téléphone',
    );
    return '$_temp0';
  }

  @override
  String get retourReseau =>
      'Elles partiront automatiquement au retour du réseau.';

  @override
  String echecs(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n échecs',
      one: '1 échec',
    );
    return '$_temp0';
  }

  @override
  String get typeDeclaration => 'Déclaration';

  @override
  String get typeControle => 'Contrôle';

  @override
  String get pasDePdf => 'Pas de PDF pour ce contrôle (version antérieure).';

  @override
  String get serveurNonConfigure =>
      'Serveur non configuré : les saisies restent sur le téléphone (paramètre API_URL).';

  @override
  String get envoiDejaEnCours => 'Envoi déjà en cours.';

  @override
  String resultatEnvoi(int envoyes, int echecs) {
    return '$envoyes envoyé(s), $echecs échec(s)';
  }

  @override
  String get valeursDemo => 'Valeurs de démonstration';

  @override
  String get valeursDemoDetail =>
      'Les seuils affichés doivent être validés avec les textes officiels avant toute utilisation.';

  @override
  String get texteCodeTitre => 'Code des pêches maritimes (Mauritanie)';

  @override
  String get texteCodeResume =>
      'Loi n° 2015-017 et ses décrets/arrêtés d\'application : licences, zones, engins, tailles minimales, infractions et sanctions.';

  @override
  String get textePsmaTitre =>
      'FAO — Accord sur les mesures du ressort de l\'État du port (PSMA)';

  @override
  String get textePsmaResume =>
      'Lutte contre la pêche INN : contrôle au port des navires étrangers, refus d\'accès, échange d\'informations.';

  @override
  String get texteConduiteTitre =>
      'FAO — Code de conduite pour une pêche responsable';

  @override
  String get texteConduiteResume =>
      'Principes de gestion durable, sélectivité des engins, réduction des prises accessoires.';

  @override
  String get texteIccatTitre => 'ICCAT';

  @override
  String get texteIccatResume =>
      'Recommandations sur les thonidés de l\'Atlantique : tailles minimales, quotas, déclaration des captures, observateurs.';

  @override
  String get texteUeTitre => 'Accord de partenariat UE-Mauritanie (APPD)';

  @override
  String get texteUeResume =>
      'Protocole en vigueur : catégories de pêche, possibilités de pêche, débarquements, embarquement de marins mauritaniens, VMS / ERS.';

  @override
  String taillesMinimales(String version) {
    return 'Tailles minimales ($version)';
  }

  @override
  String get maillagesEtPrises => 'Maillages et prises accessoires';

  @override
  String prisesAccessoiresMax(String pct) {
    return 'Prises accessoires max : $pct %';
  }

  @override
  String get organismeCodePeches => 'Code des pêches (MRT)';

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
  String typeNavire(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'pirogue': 'Pirogue',
        'chalutier': 'Chalutier',
        'senneur': 'Senneur',
        'dragueur': 'Dragueur',
        'other': '$type',
      },
    );
    return '$_temp0';
  }

  @override
  String segment(String segment) {
    String _temp0 = intl.Intl.selectLogic(
      segment,
      {
        'artisanale': 'Pêche artisanale',
        'cotiere': 'Pêche côtière',
        'hauturiere': 'Pêche hauturière',
        'other': '$segment',
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
  String certificat(String certificat) {
    String _temp0 = intl.Intl.selectLogic(
      certificat,
      {
        'navigabilite': 'Certificat de navigabilité',
        'jaugeage': 'Certificat de jaugeage',
        'hygiene': 'Agrément sanitaire',
        'radio': 'Licence radio / VMS',
        'other': '$certificat',
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
        'other': '$code',
      },
    );
    return '$_temp0';
  }

  @override
  String infLicenceInvalide(String licence) {
    return 'Licence $licence non valide à cette date.';
  }

  @override
  String infEnginNonAutorise(String engin) {
    return 'Engin « $engin » non autorisé par la licence.';
  }

  @override
  String infCertificatExpire(String certificat, String numero) {
    return '$certificat n° $numero expiré.';
  }

  @override
  String infQuotaDepasse(String espece, String poids, String quota) {
    return 'Quota $espece dépassé : $poids kg pour $quota kg autorisés.';
  }

  @override
  String infPrisesAccessoires(String pct, String max, String engin) {
    return 'Prises accessoires $pct % (max $max % pour $engin).';
  }

  @override
  String get infPavillon => 'Pavillon / identification du navire non conforme.';

  @override
  String get infMarquage =>
      'Marquage extérieur (immatriculation) absent ou illisible.';

  @override
  String get infStockage =>
      'Plan de stockage en cale non conforme à la déclaration.';

  @override
  String infMaillage(String moyenne, String min, String engin) {
    return 'Maillage moyen $moyenne mm < $min mm requis ($engin).';
  }

  @override
  String infTailleMin(String espece, String sous, String total, String min,
      String unite, String organisme) {
    return '$espece : $sous/$total individus sous $min $unite ($organisme).';
  }

  @override
  String get connexionSousTitre => 'Connectez-vous avec votre compte';

  @override
  String get identifiant => 'Identifiant';

  @override
  String get motDePasse => 'Mot de passe';

  @override
  String get seConnecter => 'Se connecter';

  @override
  String get connexionChampsVides =>
      'Saisissez votre identifiant et votre mot de passe.';

  @override
  String get connexionIdentifiants => 'Identifiant ou mot de passe incorrect.';

  @override
  String get connexionReseau =>
      'Pas de réseau : la première connexion doit se faire à terre.';

  @override
  String get connexionServeur =>
      'Le serveur de connexion ne répond pas. Réessayez plus tard.';

  @override
  String get deconnexion => 'Se déconnecter';

  @override
  String get compte => 'Compte';

  @override
  String get aucunModule =>
      'Votre compte n\'a pas de rôle de saisie (capitaine ou agent).';

  @override
  String get referentielMisAJour => 'Référentiel des navires mis à jour';

  @override
  String get moduleAdministration => 'Navires et licences';

  @override
  String get moduleAdministrationDetail =>
      'Gérer le référentiel central (administrateur)';

  @override
  String get ongletNavires => 'Navires';

  @override
  String get ongletLicences => 'Licences';

  @override
  String get ajouterNavire => 'Ajouter un navire';

  @override
  String get ajouterLicence => 'Ajouter une licence';

  @override
  String get modifierNavire => 'Modifier le navire';

  @override
  String get modifierLicence => 'Modifier la licence';

  @override
  String get actualiser => 'Actualiser';

  @override
  String get champIdentifiant => 'Identifiant (ex. N4)';

  @override
  String get champNom => 'Nom';

  @override
  String get champImmatriculation => 'Immatriculation';

  @override
  String get champPavillon => 'Pavillon (code à 3 lettres, ex. MRT)';

  @override
  String get champTypeNavire => 'Type de navire';

  @override
  String get champLongueur => 'Longueur (m)';

  @override
  String get champPuissance => 'Puissance (kW)';

  @override
  String get champImo => 'Numéro OMI (facultatif, 7 chiffres)';

  @override
  String get certificats => 'Certificats';

  @override
  String get ajouterCertificat => 'Ajouter un certificat';

  @override
  String get champNumero => 'Numéro';

  @override
  String get champExpiration => 'Expiration';

  @override
  String get champNumeroLicence => 'Numéro de licence';

  @override
  String get champNavire => 'Navire';

  @override
  String get champSegment => 'Segment';

  @override
  String get enginsAutorises => 'Engins autorisés';

  @override
  String get champEspeces =>
      'Espèces ciblées (codes FAO séparés par des virgules)';

  @override
  String get champDebut => 'Début';

  @override
  String get champFin => 'Fin';

  @override
  String get quotas => 'Quotas (kg)';

  @override
  String get ajouterQuota => 'Ajouter un quota';

  @override
  String get champEspece => 'Espèce (code FAO)';

  @override
  String get champKg => 'kg';

  @override
  String get supprimer => 'Supprimer';

  @override
  String get enregistrer => 'Enregistrer';

  @override
  String get navireEnregistre => 'Navire enregistré';

  @override
  String get licenceEnregistree => 'Licence enregistrée';

  @override
  String get champObligatoire => 'Obligatoire';

  @override
  String get nombreInvalide => 'Nombre invalide';

  @override
  String get choisirDate => 'Choisir une date';

  @override
  String get aucunElement => 'Aucun élément pour l\'instant';

  @override
  String adminRefus(String message) {
    return 'Refusé par le serveur : $message';
  }

  @override
  String adminChargement(String message) {
    return 'Chargement impossible : $message';
  }

  @override
  String licenceDe(String numero, String navire) {
    return '$numero — navire $navire';
  }

  @override
  String confirmerSuppression(String nom) {
    return 'Supprimer « $nom » ?';
  }

  @override
  String get suppressionExplication =>
      'Il disparaîtra des listes et des téléphones à la prochaine synchronisation. Les déclarations et contrôles déjà faits sont conservés.';

  @override
  String get navireSupprime => 'Navire supprimé';

  @override
  String get licenceSupprimee => 'Licence supprimée';
}
