import 'enums.dart';
import 'navire.dart';

class PositionGps {
  const PositionGps(
    this.latitude,
    this.longitude,
    this.horodatage, {
    this.demonstration = false,
  });

  final double latitude;
  final double longitude;
  final DateTime horodatage;

  /// `true` si ce n'est pas une vraie mesure GPS (GPS refusé, indisponible,
  /// ou démo dans un navigateur) : l'écran l'indique clairement.
  final bool demonstration;

  @override
  String toString() =>
      '${latitude.toStringAsFixed(4)}°, ${longitude.toStringAsFixed(4)}°';
}

class MembreEquipage {
  const MembreEquipage({
    required this.nom,
    required this.fonction,
    required this.nationalite,
  });

  final String nom;
  final String fonction;
  final String nationalite;
}

/// Une ligne de capture déclarée (espèce + poids).
class Capture {
  const Capture({required this.especeCode, required this.poidsKg});

  final String especeCode;
  final double poidsKg;
}

/// Déclaration du capitaine (journal de pêche / log-book).
class DeclarationCapitaine {
  DeclarationCapitaine({
    required this.navire,
    required this.licence,
    required this.engin,
    required this.position,
    List<MembreEquipage>? equipage,
    List<Capture>? captures,
  })  : equipage = equipage ?? [],
        captures = captures ?? [];

  final Navire navire;
  final Licence licence;
  final TypeEngin engin;
  final PositionGps position;
  final List<MembreEquipage> equipage;
  final List<Capture> captures;

  double get poidsTotalKg => captures.fold(0, (s, c) => s + c.poidsKg);
}

/// Mesure physique faite par l'agent lors d'un contrôle.
///
/// [valeur] est exprimée dans l'unité définie par le référentiel de
/// l'espèce (longueur en cm, ou poids en g pour le poulpe par exemple).
class Echantillon {
  const Echantillon({required this.especeCode, required this.valeur});

  final String especeCode;
  final double valeur;
}

/// Rapport de contrôle d'un agent garde-côtes.
class Controle {
  Controle({
    required this.navire,
    required this.agent,
    required this.date,
    required this.position,
    required this.engin,
    this.pavillonConforme = true,
    this.marquageConforme = true,
    this.planStockageConforme = true,
    List<double>? maillagesMm,
    List<Echantillon>? echantillons,
    this.observations = '',
  })  : maillagesMm = maillagesMm ?? [],
        echantillons = echantillons ?? [];

  final Navire navire;
  final String agent;
  final DateTime date;

  /// Mise à jour quand la mesure GPS arrive (elle peut prendre quelques
  /// secondes en mer).
  PositionGps position;
  TypeEngin engin;
  bool pavillonConforme;
  bool marquageConforme;
  bool planStockageConforme;
  final List<double> maillagesMm;
  final List<Echantillon> echantillons;
  String observations;
}
