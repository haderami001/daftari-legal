/// Formats d'affichage partagés (écrans, rapport texte, PDF).
library;

/// Montant entier avec séparateur de milliers : 1400000 -> « 1 400 000 ».
String formaterMontant(double montant) => montant
    .toStringAsFixed(0)
    .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ' ');
