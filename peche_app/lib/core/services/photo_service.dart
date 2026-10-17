import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// Prise de photos de preuve (captures, filets, documents).
///
/// Interface abstraite, comme [ServicePosition] : les écrans ne dépendent
/// pas de l'appareil photo réel, ce qui permet de les tester avec
/// [PhotoFixe].
abstract class ServicePhoto {
  /// Renvoie la photo en JPEG, ou `null` si l'utilisateur a annulé.
  Future<Uint8List?> prendrePhoto();
}

/// Appareil photo du téléphone (package `image_picker`). Sur une plateforme
/// sans appareil photo (navigateur d'ordinateur, Mac), on choisit un
/// fichier image à la place.
class PhotoImagePicker implements ServicePhoto {
  const PhotoImagePicker();

  @override
  Future<Uint8List?> prendrePhoto() async {
    final picker = ImagePicker();
    final source = picker.supportsImageSource(ImageSource.camera)
        ? ImageSource.camera
        : ImageSource.gallery;
    // Photo réduite et compressée : assez nette pour une preuve, assez
    // légère pour la base locale et l'envoi au serveur (~200-400 Ko).
    final fichier = await picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 70,
    );
    return fichier?.readAsBytes();
  }
}

/// Photo toujours identique : tests, démonstration.
class PhotoFixe implements ServicePhoto {
  const PhotoFixe(this.octets);

  final Uint8List octets;

  @override
  Future<Uint8List?> prendrePhoto() async => octets;
}
