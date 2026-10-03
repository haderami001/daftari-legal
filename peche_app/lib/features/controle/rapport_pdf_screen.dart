import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

/// Affiche un rapport PDF déjà généré, avec les boutons Imprimer et
/// Partager (WhatsApp, e-mail, enregistrement dans les fichiers...).
class RapportPdfScreen extends StatelessWidget {
  const RapportPdfScreen({
    super.key,
    required this.pdf,
    required this.nomFichier,
  });

  final Uint8List pdf;
  final String nomFichier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rapport d\'inspection (PDF)')),
      body: PdfPreview(
        build: (_) async => pdf,
        pdfFileName: nomFichier,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        loadingWidget: const CircularProgressIndicator(),
        onError: (context, erreur) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Aperçu indisponible sur cet appareil.\n'
                'Utilisez Partager ou Imprimer.\n($erreur)'),
          ),
        ),
      ),
    );
  }
}
