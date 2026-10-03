import 'dart:convert';

/// Saisies d'exemple au format exact envoyé par l'application
/// (`SaisieDepot.exporterDeclaration` / `exporterControle`).
const idDeclaration = '0f8fad5b-d9cb-469f-a165-70867728950e';
const idControle = '7c9e6679-7425-40de-944b-e07fc1f90ae7';
const jetonTest = 'jeton-de-test-1234567890';

Map<String, Object?> declaration({String id = idDeclaration}) => {
      'id': id,
      'navire_id': 'N1',
      'licence_numero': 'LIC-ART-2026-0091',
      'engin': 'casier',
      'position': {'lat': 20.85, 'lon': -17.45},
      'horodatage': '2026-10-03T08:00:00.000Z',
      'nb_infractions': 0,
      'equipage': [
        {'nom': 'Ahmed', 'fonction': 'Patron', 'nationalite': 'MRT'},
      ],
      'captures': [
        {'espece': 'OCC', 'poids_kg': 120.0},
        {'espece': 'CTC', 'poids_kg': 4.5},
      ],
    };

final pdfMinimal = utf8.encode('%PDF-1.4\n% test\n%%EOF');

Map<String, Object?> controle({String id = idControle}) => {
      'id': id,
      'navire_id': 'N2',
      'agent': 'Agent GCM-0427',
      'date': '2026-10-03T09:30:00.000Z',
      'position': {'lat': 20.62, 'lon': -17.3},
      'engin': 'chalutDemersal',
      'pavillon_conforme': true,
      'marquage_conforme': false,
      'stockage_conforme': true,
      'observations': 'Cale arrière non déclarée.',
      'nb_infractions': 2,
      'amende_min_mru': 250000.0,
      'amende_max_mru': 1200000.0,
      'maillages_mm': [62.0, 64.0],
      'echantillons': [
        {'espece': 'SOL', 'valeur': 22.0},
      ],
      'rapport': 'RAPPORT D\'INSPECTION EN MER\n...',
      'rapport_pdf_base64': base64Encode(pdfMinimal),
    };
