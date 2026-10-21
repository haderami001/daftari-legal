// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get langue => 'اللغة';

  @override
  String get langueSysteme => 'لغة الهاتف';

  @override
  String get langueFrancais => 'Français';

  @override
  String get langueArabe => 'العربية';

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
        'GPW': 'الهامور الأبيض',
        'MGR': 'الكوربين',
        'MUF': 'البوري',
        'SOP': 'الروبيان الوردي',
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
        'mineure': 'بسيطة',
        'grave': 'جسيمة',
        'tresGrave': 'جسيمة جدًا',
        'other': '$gravite',
      },
    );
    return '$_temp0';
  }

  @override
  String get uniteMm => 'مم';

  @override
  String get uniteCm => 'سم';

  @override
  String get uniteG => 'غ';

  @override
  String get organismeCodePeches => 'مدونة الصيد (موريتانيا)';

  @override
  String get valeursDemoDetail =>
      'يجب التحقق من الحدود المعروضة مقارنةً بالنصوص الرسمية قبل أي استعمال.';

  @override
  String amendeIndicative(String min, String max) {
    return 'الغرامة التقديرية: من $min إلى $max أوقية (MRU)';
  }

  @override
  String get conforme => 'مطابق';

  @override
  String get ajouter => 'إضافة';

  @override
  String get mesureMaille => 'قياس عين الشبكة (مم)';

  @override
  String get espece => 'النوع';

  @override
  String maillageMinimum(String min, String tolerance) {
    return 'الحد الأدنى: $min مم (هامش التسامح $tolerance٪)';
  }

  @override
  String get appTitle => 'مفتش الصيد';

  @override
  String get accueilSousTitre => 'النصوص والحسابات والمستجدات لمراقبة الصيد';

  @override
  String get moduleCalculateurs => 'الحاسبات';

  @override
  String get moduleCalculateursDetail =>
      'مقاس الشباك، الأحجام الدنيا، الغرامات';

  @override
  String get moduleBibliotheque => 'المكتبة القانونية';

  @override
  String get moduleBibliothequeDetail => 'مدونة الصيد، المراسيم، القرارات';

  @override
  String get moduleNouveautes => 'المستجدات التنظيمية';

  @override
  String get moduleNouveautesDetail => 'مراسيم الوزارة وتعميماتها';

  @override
  String get bientot => 'قريبًا';

  @override
  String valeursDemoVersion(String version) {
    return 'قيم تجريبية ($version)';
  }

  @override
  String get ongletMaillage => 'مقاس الشباك';

  @override
  String get ongletTailles => 'الأحجام الدنيا';

  @override
  String get enginLabel => 'أداة الصيد';

  @override
  String mesureEchantillon(String unite) {
    return 'القياس ($unite)';
  }

  @override
  String mesuresSaisies(String liste) {
    return 'القياسات: $liste';
  }

  @override
  String get effacerMesures => 'مسح القياسات';

  @override
  String get aucuneMesure => 'أضف قياسًا واحدًا أو أكثر.';

  @override
  String get pasDeMaillage => 'لا يوجد مقاس شباك منظَّم لهذه الأداة.';

  @override
  String seuilRetenu(String seuil) {
    return 'الحد المعتمد بعد التسامح: $seuil مم';
  }

  @override
  String moyenneMesuree(String moyenne) {
    return 'المتوسط المقيس: $moyenne مم';
  }

  @override
  String tailleMinimale(String min, String unite) {
    return 'الحد الأدنى: $min $unite';
  }

  @override
  String sousTaille(String sous, String total) {
    return '$sous من $total دون الحد الأدنى';
  }

  @override
  String nonConforme(String gravite) {
    return 'غير مطابق · $gravite';
  }

  @override
  String source(String organisme, String version) {
    return 'المصدر: $organisme · المرجع $version';
  }
}
