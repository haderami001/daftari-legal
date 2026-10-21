import 'enums.dart';

/// Un navire de pêche (pirogue, chalutier, senneur...).
class Navire {
  const Navire({
    required this.id,
    required this.nom,
    required this.immatriculation,
    required this.pavillon,
    required this.type,
    required this.longueurM,
    required this.puissanceKw,
    this.numeroImo,
    this.certificats = const [],
  });

  final String id;
  final String nom;
  final String immatriculation;

  /// Code pays ISO 3166 alpha-3 (ex. « MRT », « ESP »).
  final String pavillon;
  final TypeNavire type;
  final double longueurM;
  final double puissanceKw;

  /// Obligatoire pour la pêche hauturière, absent pour les pirogues.
  final String? numeroImo;
  final List<Certificat> certificats;

  bool get estEtranger => pavillon != 'MRT';
}

class Certificat {
  const Certificat({
    required this.type,
    required this.numero,
    required this.dateExpiration,
  });

  final TypeCertificat type;
  final String numero;
  final DateTime dateExpiration;

  bool estValideLe(DateTime date) => !date.isAfter(dateExpiration);
}

/// Licence de pêche accordée à un navire.
class Licence {
  const Licence({
    required this.numero,
    required this.navireId,
    required this.segment,
    required this.enginsAutorises,
    required this.especesCibles,
    required this.dateDebut,
    required this.dateFin,
    this.quotasKg = const {},
  });

  final String numero;
  final String navireId;
  final TypePeche segment;
  final Set<TypeEngin> enginsAutorises;

  /// Codes FAO à 3 lettres des espèces cibles (ex. « OCC » = poulpe).
  final Set<String> especesCibles;
  final DateTime dateDebut;
  final DateTime dateFin;

  /// Quota restant par espèce (code FAO -> kg).
  final Map<String, double> quotasKg;

  bool estValideLe(DateTime date) =>
      !date.isBefore(dateDebut) && !date.isAfter(dateFin);
}
