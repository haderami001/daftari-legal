import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:peche_app/core/data/donnees_demo.dart';
import 'package:peche_app/core/models/declaration.dart';
import 'package:peche_app/core/models/enums.dart';
import 'package:peche_app/core/regulation/calcul_reglementaire.dart';
import 'package:peche_app/core/regulation/rapport_pdf.dart';
import 'package:peche_app/core/regulation/referentiel.dart';

void main() {
  test('le rapport PDF est un document PDF valide', () async {
    final chalutier = naviresDemo[1];
    final licence = licencesDemo['N2']!;
    final c = Controle(
      navire: chalutier,
      agent: 'Agent GCM-0427',
      date: DateTime(2026, 10, 3, 9, 30),
      position: PositionGps(20.62, -17.30, DateTime(2026, 10, 3, 9, 30)),
      engin: TypeEngin.chalutDemersal,
      maillagesMm: [62, 64.5],
      echantillons: const [
        Echantillon(especeCode: 'SOL', valeur: 22),
        Echantillon(especeCode: 'SOL', valeur: 26),
      ],
      observations: 'Cale arrière non déclarée.',
    );
    final r = const CalculReglementaire(referentielDemo)
        .verifierControle(c, licence: licence);
    expect(r.conforme, isFalse);

    final pdf = await genererRapportPdf(c, r,
        licence: licence, identifiant: 'ab12cd34');

    expect(String.fromCharCodes(pdf.take(5)), '%PDF-');
    expect(pdf.length, greaterThan(2000));

    // Permet d'ouvrir le PDF à la main : RAPPORT_PDF=/tmp/x.pdf flutter test
    final sortie = Platform.environment['RAPPORT_PDF'];
    if (sortie != null) File(sortie).writeAsBytesSync(pdf);
  });
}
