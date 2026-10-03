import 'package:flutter/material.dart';

import 'core/data/base/base_de_donnees.dart';
import 'core/data/depots/depots.dart';
import 'features/accueil/accueil_screen.dart';

void main() {
  runApp(PecheApp(depots: Depots(BaseDeDonnees())));
}

class PecheApp extends StatelessWidget {
  const PecheApp({super.key, required this.depots});

  final Depots depots;

  @override
  Widget build(BuildContext context) {
    return DepotsScope(
      depots: depots,
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
