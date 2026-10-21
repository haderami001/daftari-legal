import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'accueil_screen.dart';
import 'l10n/app_localizations.dart';
import 'l10n/libelles.dart';
import 'theme.dart';

void main() => runApp(const InspecteurApp());

/// Assistant de l'inspecteur des pêches : textes juridiques, calculs
/// réglementaires et nouveautés du ministère.
///
/// Les règles et les calculs viennent du paquet partagé `peche_regles`,
/// le même que Pêche Conforme : les deux applications donnent toujours le
/// même résultat.
class InspecteurApp extends StatefulWidget {
  const InspecteurApp({super.key});

  /// Change la langue de l'interface (`null` = langue du téléphone).
  static void choisirLangue(BuildContext context, Locale? langue) =>
      context.findAncestorStateOfType<_InspecteurAppState>()!._choisir(langue);

  /// Langue choisie par l'utilisateur (`null` = langue du téléphone).
  static Locale? langueChoisie(BuildContext context) =>
      context.findAncestorStateOfType<_InspecteurAppState>()?._langue;

  @override
  State<InspecteurApp> createState() => _InspecteurAppState();
}

class _InspecteurAppState extends State<InspecteurApp> {
  Locale? _langue;

  void _choisir(Locale? langue) => setState(() => _langue = langue);

  @override
  Widget build(BuildContext context) => MaterialApp(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        // Français et arabe (de droite à gauche). Si le téléphone est dans
        // une autre langue : français, la première de la liste.
        locale: _langue,
        supportedLocales: const [Locale('fr'), Locale('ar')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: themePeche(Brightness.light),
        darkTheme: themePeche(Brightness.dark),
        home: const AccueilScreen(),
      );
}
