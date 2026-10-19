import 'package:flutter/material.dart';

/// Couleurs de Pêche Conforme : bleu marine et bleu océan des garde-côtes,
/// orange de sauvetage pour les actions, vert et or du drapeau mauritanien.
abstract final class CouleursPeche {
  static const marine = Color(0xFF0B3D5C);
  static const ocean = Color(0xFF0B5E8A);
  static const sauvetage = Color(0xFFF28C28);
  static const vertMauritanie = Color(0xFF00A95C);
  static const or = Color(0xFFFFC400);

  /// Bandeau d'en-tête de l'accueil (dégradé marine → océan).
  static const degradeEntete = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [marine, ocean],
  );
}

/// Police de l'app. À répéter dans chaque `textStyle` de bouton : il
/// remplace tout le style du texte (sinon retour à la police par défaut).
const _police = TextStyle(
  fontFamily: 'NotoSans',
  fontFamilyFallback: ['NotoSansArabic'],
);

/// Thème commun (clair et sombre). Police latine Noto Sans, et Noto Sans
/// Arabic pour les caractères arabes (même famille de dessin).
ThemeData themePeche(Brightness luminosite) {
  final sombre = luminosite == Brightness.dark;
  final couleurs = ColorScheme.fromSeed(
    seedColor: CouleursPeche.ocean,
    brightness: luminosite,
    secondary: CouleursPeche.sauvetage,
    onSecondary: Colors.black,
    tertiary: CouleursPeche.vertMauritanie,
    onTertiary: Colors.white,
  );
  final arrondi = BorderRadius.circular(12);

  return ThemeData(
    useMaterial3: true,
    colorScheme: couleurs,
    fontFamily: 'NotoSans',
    fontFamilyFallback: const ['NotoSansArabic'],
    scaffoldBackgroundColor:
        sombre ? const Color(0xFF0A1620) : const Color(0xFFF3F7FA),
    // Barre de titre marine dans les deux thèmes : identité visuelle.
    appBarTheme: const AppBarThemeData(
      backgroundColor: CouleursPeche.marine,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      titleTextStyle: TextStyle(
        fontFamily: 'NotoSans',
        fontFamilyFallback: ['NotoSansArabic'],
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorColor: CouleursPeche.sauvetage,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: couleurs.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: couleurs.outlineVariant),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: couleurs.primary,
      shape: RoundedRectangleBorder(borderRadius: arrondi),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(borderRadius: arrondi),
        textStyle: _police.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(borderRadius: arrondi),
      ),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: couleurs.surfaceContainerHighest.withValues(alpha: 0.5),
      border: OutlineInputBorder(borderRadius: arrondi),
      enabledBorder: OutlineInputBorder(
        borderRadius: arrondi,
        borderSide: BorderSide(color: couleurs.outlineVariant),
      ),
    ),
    chipTheme: const ChipThemeData(shape: StadiumBorder()),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: CouleursPeche.sauvetage,
      foregroundColor: Colors.black,
    ),
  );
}
