import 'dart:convert';

import 'package:serveur_peche/serveur_peche.dart';
import 'package:test/test.dart';

import 'exemples.dart';

void main() {
  final jpeg = base64Encode([0xFF, 0xD8, 0xFF, 0xE0, 0, 0x10]);
  final png = base64Encode([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0]);

  List<String> verifier(Map<String, Object?> extra) => verifierSaisie(
      TypeSaisie.controle, idControle, {...controle(), ...extra});

  test('photos JPEG et PNG et port de débarquement acceptés', () {
    expect(
        verifier({
          'photos_base64': [jpeg, png],
          'port_debarquement': 'NDB',
        }),
        isEmpty);
  });

  test('photos invalides refusées', () {
    expect(verifier({'photos_base64': 'pas une liste'}),
        contains('photos_base64 : doit être une liste'));
    expect(
        verifier({
          'photos_base64': [base64Encode(utf8.encode('texte'))],
        }),
        contains('photos_base64[0] : n\'est pas une image JPEG ou PNG'));
    expect(
        verifier({
          'photos_base64': ['%%%'],
        }),
        contains('photos_base64[0] : base64 invalide'));
    expect(
        verifier({
          'photos_base64': [for (var i = 0; i <= maxPhotos; i++) jpeg],
        }),
        contains('photos_base64 : $maxPhotos photos au maximum'));
  });

  test('port de débarquement vide refusé', () {
    expect(
        verifierSaisie(TypeSaisie.declaration, idDeclaration,
            {...declaration(), 'port_debarquement': ' '}),
        contains('port_debarquement : ne doit pas être vide'));
  });

  test('les listes renvoient la position et le port', () async {
    final s = StockageMemoire();
    await s.enregistrer(TypeSaisie.declaration, idDeclaration,
        {...declaration(), 'port_debarquement': 'NKC'});
    final json = (await s.lister(TypeSaisie.declaration)).single.versJson();
    expect(json['position'], {'lat': 20.85, 'lon': -17.45});
    expect(json['port_debarquement'], 'NKC');
  });
}
