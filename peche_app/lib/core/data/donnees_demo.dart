import '../models/enums.dart';
import '../models/navire.dart';

/// Données fictives pour la démo. En production : base SQLite locale
/// (Drift) synchronisée avec l'API centrale.
final naviresDemo = <Navire>[
  Navire(
    id: 'N1',
    nom: 'Imraguen 12',
    immatriculation: 'NDB-PA-1234',
    pavillon: 'MRT',
    type: TypeNavire.pirogue,
    longueurM: 14,
    puissanceKw: 30,
    certificats: [
      Certificat(
        type: TypeCertificat.navigabilite,
        numero: 'NAV-2025-118',
        dateExpiration: DateTime(2027, 3, 31),
      ),
    ],
  ),
  Navire(
    id: 'N2',
    nom: 'Atlantic Star',
    immatriculation: 'NKT-CH-0456',
    pavillon: 'ESP',
    type: TypeNavire.chalutier,
    longueurM: 42,
    puissanceKw: 1100,
    numeroImo: '9123456',
    certificats: [
      Certificat(
        type: TypeCertificat.navigabilite,
        numero: 'NAV-ES-7781',
        dateExpiration: DateTime(2027, 1, 15),
      ),
      Certificat(
        type: TypeCertificat.hygiene,
        numero: 'SAN-2024-33',
        dateExpiration: DateTime(2026, 6, 30), // expiré : déclenche une alerte
      ),
      Certificat(
        type: TypeCertificat.radio,
        numero: 'VMS-ES-0091',
        dateExpiration: DateTime(2027, 12, 31),
      ),
    ],
  ),
  Navire(
    id: 'N3',
    nom: 'Banc d\'Arguin',
    immatriculation: 'NDB-SE-0789',
    pavillon: 'MRT',
    type: TypeNavire.senneur,
    longueurM: 28,
    puissanceKw: 450,
    certificats: [
      Certificat(
        type: TypeCertificat.navigabilite,
        numero: 'NAV-2026-020',
        dateExpiration: DateTime(2028, 2, 1),
      ),
    ],
  ),
];

final licencesDemo = <String, Licence>{
  'N1': Licence(
    numero: 'LIC-ART-2026-0091',
    navireId: 'N1',
    segment: TypePeche.artisanale,
    enginsAutorises: {TypeEngin.casier, TypeEngin.ligne},
    especesCibles: {'OCC'},
    dateDebut: DateTime(2026, 1, 1),
    dateFin: DateTime(2026, 12, 31),
    quotasKg: {'OCC': 3000},
  ),
  'N2': Licence(
    numero: 'LIC-UE-2026-0012',
    navireId: 'N2',
    segment: TypePeche.hauturiere,
    enginsAutorises: {TypeEngin.chalutDemersal},
    especesCibles: {'SOL', 'CTC'},
    dateDebut: DateTime(2026, 7, 1),
    dateFin: DateTime(2026, 12, 31),
    quotasKg: {'SOL': 20000, 'CTC': 15000},
  ),
  'N3': Licence(
    numero: 'LIC-COT-2026-0340',
    navireId: 'N3',
    segment: TypePeche.cotiere,
    enginsAutorises: {TypeEngin.senneTournante},
    especesCibles: {'SAA'},
    dateDebut: DateTime(2026, 1, 1),
    dateFin: DateTime(2026, 12, 31),
    quotasKg: {'SAA': 150000},
  ),
};
