import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/data/base/base_de_donnees.dart';
import 'core/data/depots/reglages_depot.dart';
import 'core/services/administration.dart';
import 'core/services/services.dart';
import 'core/services/session.dart';
import 'core/services/supervision.dart';
import 'core/services/synchronisation.dart';
import 'features/accueil/accueil_screen.dart';
import 'features/connexion/connexion_screen.dart';
import 'l10n/libelles.dart';

/// Adresse du serveur central (dossier `serveur/` du dépôt) et jeton
/// d'accès, donnés au lancement :
///     flutter run --dart-define=API_URL=https://api.exemple.mr \
///                 --dart-define=API_JETON=le-jeton-du-serveur
/// Vide = pas de serveur : tout reste sur le téléphone, en file d'envoi.
const _apiUrl = String.fromEnvironment('API_URL');
const _apiJeton = String.fromEnvironment('API_JETON');

/// Comptes Keycloak (voir keycloak/realm-peche.json) :
///     --dart-define=OIDC_EMETTEUR=https://auth.exemple.mr/realms/peche
/// Vide = mode démonstration, sans écran de connexion.
const _oidcEmetteur = String.fromEnvironment('OIDC_EMETTEUR');

void main() {
  final Session session = _oidcEmetteur.isEmpty
      ? SessionDemo(jetonPartage: _apiJeton.isEmpty ? null : _apiJeton)
      : SessionKeycloak(emetteur: Uri.parse(_oidcEmetteur));
  runApp(PecheApp(
    services: Services(
      BaseDeDonnees(),
      session: session,
      api: _apiUrl.isEmpty
          ? null
          : ApiHttp(Uri.parse(_apiUrl), jeton: session.jetonAcces),
      administration: _apiUrl.isEmpty
          ? null
          : ApiAdministration(Uri.parse(_apiUrl), jeton: session.jetonAcces),
      supervision: _apiUrl.isEmpty
          ? null
          : ApiSupervision(Uri.parse(_apiUrl), jeton: session.jetonAcces),
    ),
  ));
}

class PecheApp extends StatefulWidget {
  const PecheApp({super.key, required this.services});

  final Services services;

  /// Change la langue de l'application depuis n'importe quel écran.
  /// `null` = langue du téléphone.
  static Future<void> choisirLangue(BuildContext context, Locale? langue) =>
      context.findAncestorStateOfType<_PecheAppState>()!._choisirLangue(langue);

  /// Langue choisie par l'utilisateur (`null` = langue du téléphone).
  static Locale? langueChoisie(BuildContext context) =>
      context.findAncestorStateOfType<_PecheAppState>()?._langue;

  @override
  State<PecheApp> createState() => _PecheAppState();
}

class _PecheAppState extends State<PecheApp> {
  Locale? _langue;

  @override
  void initState() {
    super.initState();
    // Session gardée sur le téléphone : pas besoin de se reconnecter (ni
    // de réseau) à chaque lancement.
    widget.services.session.restaurer();
    // La langue choisie est gardée dans la base locale.
    widget.services.reglages.lire(ReglagesDepot.cleLangue).then((code) {
      if (code != null && mounted) setState(() => _langue = Locale(code));
    });
  }

  Future<void> _choisirLangue(Locale? langue) async {
    setState(() => _langue = langue);
    await widget.services.reglages
        .ecrire(ReglagesDepot.cleLangue, langue?.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return ServicesScope(
      services: widget.services,
      child: MaterialApp(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        // Français et arabe. L'arabe s'affiche automatiquement de droite à
        // gauche. Si le téléphone est dans une autre langue : français
        // (première langue de la liste).
        locale: _langue,
        supportedLocales: const [Locale('fr'), Locale('ar')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: _theme(Brightness.light),
        darkTheme: _theme(Brightness.dark),
        // Écran de connexion tant qu'aucun compte n'est connecté.
        home: ListenableBuilder(
          listenable: widget.services.session,
          builder: (context, _) {
            final s = widget.services.session;
            return s.exigeConnexion && s.profil == null
                ? const ConnexionScreen()
                : const AccueilScreen();
          },
        ),
      ),
    );
  }
}

/// Thème commun. Police latine Noto Sans, et Noto Sans Arabic pour les
/// caractères arabes (même famille de dessin, rendu cohérent).
ThemeData _theme(Brightness luminosite) => ThemeData(
      colorSchemeSeed: const Color(0xFF0B5E8A),
      brightness: luminosite,
      useMaterial3: true,
      fontFamily: 'NotoSans',
      fontFamilyFallback: const ['NotoSansArabic'],
    );
