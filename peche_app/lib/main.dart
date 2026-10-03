import 'package:flutter/material.dart';

import 'features/accueil/accueil_screen.dart';

void main() {
  runApp(const PecheApp());
}

class PecheApp extends StatelessWidget {
  const PecheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
