/// Formats d'affichage partagés (écrans, rapport texte, PDF).
library;

/// Espace insécable. Comme séparateur de milliers, elle garde les chiffres
/// d'un nombre ensemble dans un texte arabe (de droite à gauche) : avec une
/// espace ordinaire, « 1 200 000 » s'afficherait « 000 200 1 ».
const espaceInsecable = '\u00A0';

/// Montant entier avec séparateur de milliers : 1400000 -> « 1 400 000 ».
String formaterMontant(double montant) => montant
    .toStringAsFixed(0)
    .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => espaceInsecable);

/// Isole un texte qui se lit toujours de gauche à droite (coordonnées GPS,
/// références) pour qu'il ne soit pas réordonné dans une phrase arabe.
/// Les caractères ajoutés (U+2066 / U+2069) sont invisibles.
String isolerGaucheDroite(String texte) => '\u2066$texte\u2069';
