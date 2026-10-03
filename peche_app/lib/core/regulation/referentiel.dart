/// ⚠️ RÉFÉRENTIEL D'EXEMPLE ⚠️
///
/// Les valeurs ci-dessous servent uniquement à faire fonctionner le
/// prototype. Elles DOIVENT être remplacées par les valeurs officielles
/// (Code des pêches maritimes, décrets d'application, arrêtés, recommandations
/// ICCAT, protocole UE-Mauritanie) validées par le ministère.
///
/// En production, ce référentiel est téléchargé depuis l'API
/// (`GET /referentiel?version=...`) et stocké localement, pour pouvoir
/// mettre à jour les règles SANS republier l'application.
library;

import '../models/enums.dart';

enum UniteMesure {
  longueurCm('cm'),
  poidsG('g');

  const UniteMesure(this.symbole);
  final String symbole;
}

class RegleEspece {
  const RegleEspece({
    required this.code,
    required this.nomCommun,
    required this.nomScientifique,
    required this.unite,
    required this.minimum,
    this.organisme = 'Code des pêches (MRT)',
  });

  /// Code FAO ASFIS à 3 lettres.
  final String code;
  final String nomCommun;
  final String nomScientifique;
  final UniteMesure unite;

  /// Taille ou poids minimal de capture.
  final double minimum;

  /// Texte / organisme d'où provient la règle.
  final String organisme;
}

class RegleEngin {
  const RegleEngin({
    required this.engin,
    required this.maillageMinMm,
    required this.prisesAccessoiresMaxPct,
  });

  final TypeEngin engin;

  /// Maillage minimal (maille étirée), en mm. 0 = non applicable.
  final double maillageMinMm;

  /// Part maximale de prises accessoires tolérée, en % du poids total.
  final double prisesAccessoiresMaxPct;
}

/// Fourchette d'amende par gravité (en MRU).
class BaremeSanction {
  const BaremeSanction(this.gravite, this.amendeMin, this.amendeMax);

  final Gravite gravite;
  final double amendeMin;
  final double amendeMax;
}

class Referentiel {
  const Referentiel({
    required this.version,
    required this.especes,
    required this.engins,
    required this.bareme,
    this.toleranceMaillagePct = 0,
  });

  final String version;
  final Map<String, RegleEspece> especes;
  final Map<TypeEngin, RegleEngin> engins;
  final Map<Gravite, BaremeSanction> bareme;

  /// Tolérance de mesure accordée sur le maillage (en %).
  final double toleranceMaillagePct;

  RegleEspece? espece(String code) => especes[code];
  RegleEngin? engin(TypeEngin e) => engins[e];
}

/// Référentiel de démonstration (valeurs FICTIVES à valider).
const referentielDemo = Referentiel(
  version: 'demo-2026.10',
  toleranceMaillagePct: 5,
  especes: {
    'OCC': RegleEspece(
      code: 'OCC',
      nomCommun: 'Poulpe',
      nomScientifique: 'Octopus vulgaris',
      unite: UniteMesure.poidsG,
      minimum: 500,
    ),
    'CTC': RegleEspece(
      code: 'CTC',
      nomCommun: 'Seiche',
      nomScientifique: 'Sepia officinalis',
      unite: UniteMesure.longueurCm,
      minimum: 13,
    ),
    'SAA': RegleEspece(
      code: 'SAA',
      nomCommun: 'Sardinelle ronde',
      nomScientifique: 'Sardinella aurita',
      unite: UniteMesure.longueurCm,
      minimum: 18,
    ),
    'SOL': RegleEspece(
      code: 'SOL',
      nomCommun: 'Sole',
      nomScientifique: 'Solea solea',
      unite: UniteMesure.longueurCm,
      minimum: 24,
    ),
    'YFT': RegleEspece(
      code: 'YFT',
      nomCommun: 'Albacore',
      nomScientifique: 'Thunnus albacares',
      unite: UniteMesure.longueurCm,
      minimum: 60,
      organisme: 'ICCAT',
    ),
    'BFT': RegleEspece(
      code: 'BFT',
      nomCommun: 'Thon rouge',
      nomScientifique: 'Thunnus thynnus',
      unite: UniteMesure.longueurCm,
      minimum: 115,
      organisme: 'ICCAT',
    ),
  },
  engins: {
    TypeEngin.ligne: RegleEngin(
        engin: TypeEngin.ligne, maillageMinMm: 0, prisesAccessoiresMaxPct: 10),
    TypeEngin.filetMaillant: RegleEngin(
        engin: TypeEngin.filetMaillant,
        maillageMinMm: 100,
        prisesAccessoiresMaxPct: 15),
    TypeEngin.casier: RegleEngin(
        engin: TypeEngin.casier, maillageMinMm: 0, prisesAccessoiresMaxPct: 5),
    TypeEngin.chalutDemersal: RegleEngin(
        engin: TypeEngin.chalutDemersal,
        maillageMinMm: 70,
        prisesAccessoiresMaxPct: 20),
    TypeEngin.chalutPelagique: RegleEngin(
        engin: TypeEngin.chalutPelagique,
        maillageMinMm: 40,
        prisesAccessoiresMaxPct: 3),
    TypeEngin.senneTournante: RegleEngin(
        engin: TypeEngin.senneTournante,
        maillageMinMm: 20,
        prisesAccessoiresMaxPct: 5),
    TypeEngin.drague: RegleEngin(
        engin: TypeEngin.drague, maillageMinMm: 80, prisesAccessoiresMaxPct: 10),
  },
  bareme: {
    Gravite.mineure: BaremeSanction(Gravite.mineure, 50000, 200000),
    Gravite.grave: BaremeSanction(Gravite.grave, 200000, 1000000),
    Gravite.tresGrave: BaremeSanction(Gravite.tresGrave, 1000000, 5000000),
  },
);
