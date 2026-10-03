import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peche_app/core/format.dart';

/// Dans une phrase arabe (de droite à gauche), les nombres doivent rester
/// lisibles de gauche à droite. On mesure la position réelle des morceaux
/// avec le moteur de texte de Flutter (le même que sur le téléphone).
bool seLitDeGaucheADroite(String phrase, List<String> morceaux) {
  final tp = TextPainter(
    text: TextSpan(text: phrase, style: const TextStyle(fontSize: 20)),
    textDirection: TextDirection.rtl,
  )..layout();
  final positions = [
    for (final m in morceaux)
      tp
          .getBoxesForSelection(TextSelection(
              baseOffset: phrase.indexOf(m),
              extentOffset: phrase.indexOf(m) + 1))
          .first
          .left,
  ];
  for (var i = 1; i < positions.length; i++) {
    if (positions[i] <= positions[i - 1]) return false;
  }
  return true;
}

void main() {
  test('un montant reste « 1 200 000 » dans une phrase arabe', () {
    final montant = formaterMontant(1200000);
    expect(montant, '1${espaceInsecable}200${espaceInsecable}000');
    expect(
        seLitDeGaucheADroite(
            'من $montant أوقية', ['1$espaceInsecable', '200', '000 ']),
        isTrue);

    // Contre-exemple : avec des espaces ordinaires, l'ordre est inversé.
    expect(seLitDeGaucheADroite('من 1 200 000 أوقية', ['1 ', '200', '000 ']),
        isFalse);
  });

  test('des coordonnées GPS isolées gardent leur ordre', () {
    const gps = '20.9310°, -17.0347°';
    expect(
        seLitDeGaucheADroite(
            'الموقع: ${isolerGaucheDroite(gps)}', ['20.', '-17']),
        isTrue);
    expect(seLitDeGaucheADroite('الموقع: $gps', ['20.', '-17']), isFalse);
  });
}
