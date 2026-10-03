import 'package:flutter/material.dart';

import 'core/data/base/base_de_donnees.dart';
import 'core/services/services.dart';
import 'core/services/synchronisation.dart';
import 'features/accueil/accueil_screen.dart';

/// Adresse du serveur central, donnée au lancement :
///     flutter run --dart-define=API_URL=https://api.exemple.mr
/// Vide = pas de serveur : tout reste sur le téléphone, en file d'envoi.
const _apiUrl = String.fromEnvironment('API_URL');

void main() {
  runApp(PecheApp(
    services: Services(
      BaseDeDonnees(),
      api: _apiUrl.isEmpty ? null : ApiHttp(Uri.parse(_apiUrl)),
    ),
  ));
}

class PecheApp extends StatelessWidget {
  const PecheApp({super.key, required this.services});

  final Services services;

  @override
  Widget build(BuildContext context) {
    return ServicesScope(
      services: services,
      child: MaterialApp(
        title: 'Pêche Conforme',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF0B5E8A),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: const Color(0xFF0B5E8A),
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const AccueilScreen(),
      ),
    );
  }
}
