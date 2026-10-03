import 'package:flutter_test/flutter_test.dart';
import 'package:peche_app/core/data/donnees_demo.dart';
import 'package:peche_app/core/models/declaration.dart';
import 'package:peche_app/core/models/enums.dart';
import 'package:peche_app/core/regulation/calcul_reglementaire.dart';
import 'package:peche_app/core/regulation/referentiel.dart';

void main() {
  const calcul = CalculReglementaire(referentielDemo);
  final pirogue = naviresDemo[0];
  final licencePirogue = licencesDemo['N1']!;
  final jour = DateTime(2026, 10, 3);

  DeclarationCapitaine declaration(List<Capture> captures,
          {TypeEngin engin = TypeEngin.casier}) =>
      DeclarationCapitaine(
        navire: pirogue,
        licence: licencePirogue,
        engin: engin,
        position: PositionGps(20.85, -17.45, jour),
        captures: captures,
      );

  test('déclaration conforme', () {
    final r = calcul.verifierDeclaration(
        declaration([const Capture(especeCode: 'OCC', poidsKg: 200)]));
    expect(r.conforme, isTrue);
    expect(r.amendeMin, 0);
  });

  test('engin non autorisé par la licence', () {
    final r = calcul.verifierDeclaration(declaration(
        [const Capture(especeCode: 'OCC', poidsKg: 200)],
        engin: TypeEngin.chalutDemersal));
    expect(r.infractions.map((i) => i.code), ['ENGIN_NON_AUTORISE']);
  });

  test('quota dépassé', () {
    final r = calcul.verifierDeclaration(declaration([
      const Capture(especeCode: 'OCC', poidsKg: 2000),
      const Capture(especeCode: 'OCC', poidsKg: 1500),
    ]));
    expect(r.infractions.single.code, 'QUOTA_DEPASSE');
  });

  test('prises accessoires au-delà du seuil de l\'engin', () {
    // casier : 5 % max ; ici 10 % de seiche (non cible).
    const captures = [
      Capture(especeCode: 'OCC', poidsKg: 90),
      Capture(especeCode: 'CTC', poidsKg: 10),
    ];
    expect(calcul.pourcentagePrisesAccessoires(licencePirogue, captures),
        closeTo(10, 0.001));
    final r = calcul.verifierDeclaration(declaration(captures));
    expect(r.infractions.single.code, 'PRISES_ACCESSOIRES');
  });

  test('licence expirée et certificat expiré', () {
    final chalutier = naviresDemo[1];
    final r = calcul.verifierDeclaration(
      DeclarationCapitaine(
        navire: chalutier,
        licence: licencesDemo['N2']!,
        engin: TypeEngin.chalutDemersal,
        position: PositionGps(20, -17.5, DateTime(2027, 2, 1)),
      ),
    );
    expect(r.infractions.map((i) => i.code),
        containsAll(['LIC_INVALIDE', 'CERT_EXPIRE']));
  });

  group('contrôle', () {
    test('maillage : tolérance appliquée', () {
      // chalut de fond : 70 mm, tolérance 5 % -> seuil 66,5 mm.
      expect(
          calcul.verifierMaillage(TypeEngin.chalutDemersal, [67, 68]), isEmpty);
      expect(
          calcul
              .verifierMaillage(TypeEngin.chalutDemersal, [60, 62])
              .single
              .code,
          'MAILLAGE');
    });

    test('tailles minimales : gravité selon la proportion', () {
      final mineure = calcul.verifierTailles(const [
        Echantillon(especeCode: 'SAA', valeur: 15),
        Echantillon(especeCode: 'SAA', valeur: 20),
        Echantillon(especeCode: 'SAA', valeur: 21),
      ]);
      expect(mineure.single.gravite, Gravite.mineure);

      final grave = calcul.verifierTailles(const [
        Echantillon(especeCode: 'OCC', valeur: 300),
        Echantillon(especeCode: 'OCC', valeur: 400),
      ]);
      expect(grave.single.gravite, Gravite.grave);
    });

    test('cumul des amendes', () {
      final c = Controle(
        navire: naviresDemo[2],
        agent: 'test',
        date: jour,
        position: PositionGps(20, -17, jour),
        engin: TypeEngin.senneTournante,
        marquageConforme: false,
        planStockageConforme: false,
      );
      final r = calcul.verifierControle(c, licence: licencesDemo['N3']);
      expect(r.infractions.length, 2);
      expect(r.amendeMin, 2 * 50000);
      expect(r.amendeMax, 2 * 200000);
    });
  });
}
