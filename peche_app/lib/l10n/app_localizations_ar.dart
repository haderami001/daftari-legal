import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'الصيد المطابق';

  @override
  String get langue => 'اللغة';

  @override
  String get langueSysteme => 'لغة الهاتف';

  @override
  String get langueFrancais => 'Français';

  @override
  String get langueArabe => 'العربية';

  @override
  String get moduleDeclaration => 'تصريح الربّان';

  @override
  String get moduleDeclarationDetail => 'السفينة، الرخصة، الطاقم، المصيد';

  @override
  String get moduleControle => 'تفتيش خفر السواحل';

  @override
  String get moduleControleDetail => 'المعاينة، مقاس الشباك، العينات، التقرير';

  @override
  String get moduleGuide => 'الدليل التنظيمي';

  @override
  String get moduleGuideDetail =>
      'مدونة الصيد، الفاو، إيكات، الاتحاد الأوروبي - موريتانيا';

  @override
  String get moduleEnvois => 'الإرسالات المعلّقة';

  @override
  String get envoisLecture => 'جارٍ قراءة القاعدة المحلية…';

  @override
  String get envoisToutSynchronise => 'تمت مزامنة كل شيء';

  @override
  String envoisAEnvoyer(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n إدخال في انتظار الإرسال',
      many: '$n إدخالًا في انتظار الإرسال',
      few: '$n إدخالات في انتظار الإرسال',
      two: 'إدخالان في انتظار الإرسال',
      one: 'إدخال واحد في انتظار الإرسال',
    );
    return '$_temp0';
  }

  @override
  String get aucunNavire => 'لا توجد سفينة مرخّصة في القاعدة المحلية.';

  @override
  String get annuler => 'إلغاء';

  @override
  String get ajouter => 'إضافة';

  @override
  String get suivant => 'التالي';

  @override
  String get retour => 'رجوع';

  @override
  String get fermer => 'إغلاق';

  @override
  String get signer => 'توقيع';

  @override
  String get gpsRecherche => 'جارٍ البحث عن إشارة GPS…';

  @override
  String get gpsNonMesuree => '(غير مقيسة)';

  @override
  String echecEnregistrement(String erreur) {
    return 'فشل الحفظ: $erreur';
  }

  @override
  String get navire => 'السفينة';

  @override
  String get immatriculation => 'رقم التسجيل';

  @override
  String get pavillon => 'العلم';

  @override
  String get numeroImo => 'رقم IMO';

  @override
  String get licence => 'الرخصة';

  @override
  String get positionGps => 'موقع GPS';

  @override
  String get espece => 'النوع';

  @override
  String numero(String id) {
    return 'رقم $id';
  }

  @override
  String get uniteKg => 'كغ';

  @override
  String get uniteMm => 'مم';

  @override
  String get uniteCm => 'سم';

  @override
  String get uniteG => 'غ';

  @override
  String get signerEtEnvoyer => 'توقيع وإرسال';

  @override
  String get etapeNavire => 'السفينة والرخصة';

  @override
  String etapeEquipage(int n) {
    return 'الطاقم ($n)';
  }

  @override
  String etapeCaptures(int n) {
    return 'المصيد ($n)';
  }

  @override
  String get etapeVerification => 'التحقق';

  @override
  String get enginUtilise => 'أداة الصيد المستعملة';

  @override
  String get ajouterMembre => 'إضافة فرد';

  @override
  String get membreEquipage => 'فرد من الطاقم';

  @override
  String get nomComplet => 'الاسم الكامل';

  @override
  String get fonction => 'الوظيفة';

  @override
  String get fonctionParDefaut => 'بحّار';

  @override
  String get nationalite => 'الجنسية';

  @override
  String get especeCible => 'نوع مستهدف';

  @override
  String get priseAccessoire => 'مصيد عرضي';

  @override
  String get ajouterCapture => 'إضافة مصيد';

  @override
  String get capture => 'مصيد';

  @override
  String get poidsKg => 'الوزن (كغ)';

  @override
  String get poidsTotal => 'الوزن الإجمالي';

  @override
  String get prisesAccessoires => 'المصيد العرضي';

  @override
  String quota(String espece) {
    return 'حصة $espece';
  }

  @override
  String declarationEnregistree(String id) {
    return 'تم حفظ التصريح $id على الهاتف، وسيُرسل عند عودة الاتصال بالشبكة.';
  }

  @override
  String get sectionNavire => '1. السفينة';

  @override
  String get navireInspecte => 'السفينة الخاضعة للتفتيش';

  @override
  String detailsNavire(
      String pavillon, String type, String longueur, String puissance) {
    return 'العلم: $pavillon · $type · $longueur م · $puissance كيلوواط';
  }

  @override
  String licenceNumero(String numero) {
    return 'الرخصة: $numero';
  }

  @override
  String positionValeur(String position) {
    return 'الموقع: $position';
  }

  @override
  String get pavillonConcordant => 'العلم ووثائق السفينة متطابقة';

  @override
  String get marquageVisible => 'العلامات ورقم التسجيل ظاهرة';

  @override
  String get sectionCertificats => '2. الشهادات';

  @override
  String certificatExpireLe(String numero, String date) {
    return '$numero · تنتهي صلاحيتها في $date';
  }

  @override
  String get sectionEngin => '3. أداة الصيد ومقاس العين';

  @override
  String get enginABord => 'أداة الصيد على متن السفينة';

  @override
  String maillageMinimum(String min, String tolerance) {
    return 'الحد الأدنى: $min مم (هامش التسامح $tolerance٪)';
  }

  @override
  String get mesureMaille => 'قياس عين الشبكة (مم)';

  @override
  String get pasDeMaillage => 'لا يوجد مقاس عين منظَّم لهذه الأداة.';

  @override
  String get sectionEchantillons => '4. العينات (الأحجام الدنيا)';

  @override
  String especeMinimum(String espece, String min, String unite) {
    return '$espece - الحد الأدنى $min $unite';
  }

  @override
  String mesureUnite(String unite) {
    return 'القياس ($unite)';
  }

  @override
  String get sectionStockage => '5. مخطط التخزين';

  @override
  String get calesConformes => 'العنابر مطابقة لمخطط التخزين ولسجل الصيد';

  @override
  String get observations => 'ملاحظات';

  @override
  String get genererRapport => 'إنشاء تقرير التفتيش';

  @override
  String get rapportGenere => 'تم إنشاء التقرير';

  @override
  String get rapportLangue => 'التقرير الرسمي محرَّر باللغة الفرنسية.';

  @override
  String rapportEnregistre(String id) {
    return 'تم توقيع التقرير $id وحفظه، وسيُرسل عند عودة الاتصال بالشبكة.';
  }

  @override
  String get rapportPdfTitre => 'تقرير التفتيش (PDF)';

  @override
  String apercuIndisponible(String erreur) {
    return 'المعاينة غير متاحة على هذا الجهاز.\nاستعمل المشاركة أو الطباعة.\n($erreur)';
  }

  @override
  String get conforme => 'مطابق';

  @override
  String get aucuneNonConformite => 'لم تُرصد أي مخالفة.';

  @override
  String nonConformites(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n مخالفة',
      many: '$n مخالفة',
      few: '$n مخالفات',
      two: 'مخالفتان',
      one: 'مخالفة واحدة',
    );
    return '$_temp0';
  }

  @override
  String amendeIndicative(String min, String max) {
    return 'الغرامة التقديرية: من $min إلى $max أوقية (MRU)';
  }

  @override
  String get envoyerMaintenant => 'إرسال الآن';

  @override
  String get toutEnvoye => 'تم إرسال كل شيء.';

  @override
  String saisiesStockees(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n إدخال محفوظ على الهاتف',
      many: '$n إدخالًا محفوظًا على الهاتف',
      few: '$n إدخالات محفوظة على الهاتف',
      two: 'إدخالان محفوظان على الهاتف',
      one: 'إدخال واحد محفوظ على الهاتف',
    );
    return '$_temp0';
  }

  @override
  String get retourReseau => 'ستُرسل تلقائيًا عند عودة الشبكة.';

  @override
  String echecs(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n محاولة فاشلة',
      many: '$n محاولة فاشلة',
      few: '$n محاولات فاشلة',
      two: 'محاولتان فاشلتان',
      one: 'محاولة فاشلة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get typeDeclaration => 'تصريح';

  @override
  String get typeControle => 'تفتيش';

  @override
  String get pasDePdf => 'لا يوجد ملف PDF لهذا التفتيش (إصدار سابق).';

  @override
  String get serveurNonConfigure =>
      'الخادم غير مُعَدّ: تبقى الإدخالات على الهاتف (المعامل API_URL).';

  @override
  String get envoiDejaEnCours => 'الإرسال جارٍ بالفعل.';

  @override
  String resultatEnvoi(int envoyes, int echecs) {
    return 'أُرسل: $envoyes، فشل: $echecs';
  }

  @override
  String get valeursDemo => 'قيم تجريبية';

  @override
  String get valeursDemoDetail =>
      'يجب التحقق من الحدود المعروضة مقارنةً بالنصوص الرسمية قبل أي استعمال.';

  @override
  String get texteCodeTitre => 'مدونة الصيد البحري (موريتانيا)';

  @override
  String get texteCodeResume =>
      'القانون رقم 2015-017 ومراسيمه وقراراته التطبيقية: الرخص، المناطق، أدوات الصيد، الأحجام الدنيا، المخالفات والعقوبات.';

  @override
  String get textePsmaTitre => 'الفاو - اتفاق تدابير دولة الميناء (PSMA)';

  @override
  String get textePsmaResume =>
      'مكافحة الصيد غير القانوني وغير المبلَّغ عنه وغير المنظَّم: تفتيش السفن الأجنبية في الميناء، رفض الدخول، تبادل المعلومات.';

  @override
  String get texteConduiteTitre => 'الفاو - مدونة السلوك بشأن الصيد الرشيد';

  @override
  String get texteConduiteResume =>
      'مبادئ الإدارة المستدامة، انتقائية أدوات الصيد، الحد من المصيد العرضي.';

  @override
  String get texteIccatTitre => 'إيكات (ICCAT)';

  @override
  String get texteIccatResume =>
      'توصيات بشأن أسماك التونة في المحيط الأطلسي: الأحجام الدنيا، الحصص، التصريح بالمصيد، المراقبون.';

  @override
  String get texteUeTitre =>
      'اتفاق الشراكة في مجال الصيد المستدام بين الاتحاد الأوروبي وموريتانيا';

  @override
  String get texteUeResume =>
      'البروتوكول الساري: فئات الصيد، إمكانيات الصيد، الإنزال، تشغيل البحّارة الموريتانيين، نظاما VMS / ERS.';

  @override
  String taillesMinimales(String version) {
    return 'الأحجام الدنيا ($version)';
  }

  @override
  String get maillagesEtPrises => 'مقاسات العيون والمصيد العرضي';

  @override
  String prisesAccessoiresMax(String pct) {
    return 'الحد الأقصى للمصيد العرضي: $pct٪';
  }

  @override
  String get organismeCodePeches => 'مدونة الصيد (موريتانيا)';

  @override
  String engin(String engin) {
    String _temp0 = intl.Intl.selectLogic(
      engin,
      {
        'ligne': 'صنارة / خيوط طويلة',
        'filetMaillant': 'شباك خيشومية',
        'casier': 'أفخاخ / أواني الأخطبوط',
        'chalutDemersal': 'شباك الجر القاعية',
        'chalutPelagique': 'شباك الجر السطحية',
        'senneTournante': 'الشباك الدوّارة (الكيسية)',
        'drague': 'الجرّافة',
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
        'pirogue': 'زورق تقليدي (بيروغ)',
        'chalutier': 'سفينة جر',
        'senneur': 'سفينة الشباك الدوّارة',
        'dragueur': 'سفينة جرف',
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
        'artisanale': 'الصيد التقليدي',
        'cotiere': 'الصيد الساحلي',
        'hauturiere': 'الصيد في أعالي البحار',
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
        'mineure': 'بسيطة',
        'grave': 'جسيمة',
        'tresGrave': 'جسيمة جدًا',
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
        'navigabilite': 'شهادة صلاحية الإبحار',
        'jaugeage': 'شهادة الحمولة',
        'hygiene': 'الاعتماد الصحي',
        'radio': 'رخصة الراديو / VMS',
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
        'OCC': 'الأخطبوط',
        'CTC': 'الحبّار (السيبيا)',
        'SAA': 'السردينيلا المستديرة',
        'SOL': 'سمك موسى',
        'YFT': 'التونة صفراء الزعانف',
        'BFT': 'التونة الحمراء',
        'other': '$code',
      },
    );
    return '$_temp0';
  }

  @override
  String infLicenceInvalide(String licence) {
    return 'الرخصة $licence غير صالحة في هذا التاريخ.';
  }

  @override
  String infEnginNonAutorise(String engin) {
    return 'أداة الصيد «$engin» غير مرخَّصة بموجب الرخصة.';
  }

  @override
  String infCertificatExpire(String certificat, String numero) {
    return '$certificat رقم $numero منتهي الصلاحية.';
  }

  @override
  String infQuotaDepasse(String espece, String poids, String quota) {
    return 'تجاوز حصة $espece: $poids كغ مقابل $quota كغ مسموح بها.';
  }

  @override
  String infPrisesAccessoires(String pct, String max, String engin) {
    return 'المصيد العرضي $pct٪ (الحد الأقصى $max٪ لأداة $engin).';
  }

  @override
  String get infPavillon => 'العلم أو تعريف السفينة غير مطابق.';

  @override
  String get infMarquage =>
      'العلامات الخارجية (رقم التسجيل) غائبة أو غير مقروءة.';

  @override
  String get infStockage => 'مخطط التخزين في العنابر غير مطابق للتصريح.';

  @override
  String infMaillage(String moyenne, String min, String engin) {
    return 'متوسط مقاس العين $moyenne مم أقل من $min مم المطلوبة ($engin).';
  }

  @override
  String infTailleMin(String espece, String sous, String total, String min,
      String unite, String organisme) {
    return '$espece: $sous من $total دون $min $unite ($organisme).';
  }

  @override
  String get connexionSousTitre => 'سجّل الدخول بحسابك';

  @override
  String get identifiant => 'اسم المستخدم';

  @override
  String get motDePasse => 'كلمة المرور';

  @override
  String get seConnecter => 'تسجيل الدخول';

  @override
  String get connexionChampsVides => 'أدخل اسم المستخدم وكلمة المرور.';

  @override
  String get connexionIdentifiants => 'اسم المستخدم أو كلمة المرور غير صحيحة.';

  @override
  String get connexionReseau =>
      'لا توجد شبكة: يجب أن يتم تسجيل الدخول الأول على اليابسة.';

  @override
  String get connexionServeur =>
      'خادم تسجيل الدخول لا يستجيب. أعد المحاولة لاحقًا.';

  @override
  String get deconnexion => 'تسجيل الخروج';

  @override
  String get compte => 'الحساب';

  @override
  String get aucunModule => 'ليس لحسابك دور إدخال (ربّان أو عون).';

  @override
  String get referentielMisAJour => 'تم تحديث سجل السفن';

  @override
  String get moduleAdministration => 'السفن والتراخيص';

  @override
  String get moduleAdministrationDetail => 'إدارة السجل المركزي (المسؤول)';

  @override
  String get ongletNavires => 'السفن';

  @override
  String get ongletLicences => 'التراخيص';

  @override
  String get ajouterNavire => 'إضافة سفينة';

  @override
  String get ajouterLicence => 'إضافة ترخيص';

  @override
  String get modifierNavire => 'تعديل السفينة';

  @override
  String get modifierLicence => 'تعديل الترخيص';

  @override
  String get actualiser => 'تحديث';

  @override
  String get champIdentifiant => 'المعرّف (مثال N4)';

  @override
  String get champNom => 'الاسم';

  @override
  String get champImmatriculation => 'رقم التسجيل';

  @override
  String get champPavillon => 'العلم (رمز من 3 أحرف، مثال MRT)';

  @override
  String get champTypeNavire => 'نوع السفينة';

  @override
  String get champLongueur => 'الطول (م)';

  @override
  String get champPuissance => 'القدرة (كيلوواط)';

  @override
  String get champImo => 'رقم المنظمة البحرية الدولية (اختياري، 7 أرقام)';

  @override
  String get certificats => 'الشهادات';

  @override
  String get ajouterCertificat => 'إضافة شهادة';

  @override
  String get champNumero => 'الرقم';

  @override
  String get champExpiration => 'تاريخ الانتهاء';

  @override
  String get champNumeroLicence => 'رقم الترخيص';

  @override
  String get champNavire => 'السفينة';

  @override
  String get champSegment => 'القطاع';

  @override
  String get enginsAutorises => 'المعدات المرخّصة';

  @override
  String get champEspeces => 'الأنواع المستهدفة (رموز الفاو مفصولة بفواصل)';

  @override
  String get champDebut => 'البداية';

  @override
  String get champFin => 'النهاية';

  @override
  String get quotas => 'الحصص (كغ)';

  @override
  String get ajouterQuota => 'إضافة حصة';

  @override
  String get champEspece => 'النوع (رمز الفاو)';

  @override
  String get champKg => 'كغ';

  @override
  String get supprimer => 'حذف';

  @override
  String get enregistrer => 'حفظ';

  @override
  String get navireEnregistre => 'تم حفظ السفينة';

  @override
  String get licenceEnregistree => 'تم حفظ الترخيص';

  @override
  String get champObligatoire => 'إلزامي';

  @override
  String get nombreInvalide => 'رقم غير صالح';

  @override
  String get choisirDate => 'اختيار تاريخ';

  @override
  String get aucunElement => 'لا توجد عناصر حالياً';

  @override
  String adminRefus(String message) {
    return 'رفض الخادم: $message';
  }

  @override
  String adminChargement(String message) {
    return 'تعذّر التحميل: $message';
  }

  @override
  String licenceDe(String numero, String navire) {
    return '$numero — السفينة $navire';
  }

  @override
  String confirmerSuppression(String nom) {
    return 'حذف «$nom»؟';
  }

  @override
  String get suppressionExplication =>
      'سيختفي من القوائم ومن الهواتف عند المزامنة التالية. يتم الاحتفاظ بالتصريحات وعمليات المراقبة السابقة.';

  @override
  String get navireSupprime => 'تم حذف السفينة';

  @override
  String get licenceSupprimee => 'تم حذف الترخيص';

  @override
  String get moduleSupervision => 'لوحة المتابعة';

  @override
  String get moduleSupervisionDetail =>
      'التصريحات وعمليات المراقبة المستلمة، تقارير PDF (المشرف)';

  @override
  String get ongletDeclarations => 'التصريحات';

  @override
  String get ongletControles => 'عمليات المراقبة';

  @override
  String navireLe(String navire, String date) {
    return 'السفينة $navire — $date';
  }

  @override
  String nbInfractions(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n مخالفة',
      many: '$n مخالفةً',
      few: '$n مخالفات',
      two: 'مخالفتان',
      one: 'مخالفة واحدة',
      zero: 'لا توجد مخالفة',
    );
    return '$_temp0';
  }

  @override
  String envoyePar(String compte) {
    return 'أرسله $compte';
  }

  @override
  String get avecInfraction => 'بها مخالفات';
}
