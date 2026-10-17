import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/qr_licence.dart';
import '../../l10n/libelles.dart';

/// Lecture du QR code de la licence présenté par le capitaine.
///
/// Renvoie le numéro de licence lu (ou saisi à la main si la caméra ne
/// marche pas), ou `null` si l'agent revient en arrière.
class ScannerLicenceScreen extends StatefulWidget {
  const ScannerLicenceScreen({super.key});

  @override
  State<ScannerLicenceScreen> createState() => _ScannerLicenceScreenState();
}

class _ScannerLicenceScreenState extends State<ScannerLicenceScreen> {
  bool _termine = false;
  String? _dernierInconnu;

  void _detecte(BarcodeCapture capture) {
    if (_termine) return;
    for (final code in capture.barcodes) {
      final brut = code.rawValue;
      if (brut == null) continue;
      final qr = lireQrLicence(brut);
      if (qr != null) {
        _termine = true;
        Navigator.of(context).pop(qr.numero);
        return;
      }
      // Autre QR code (site web, autre application) : on le signale une
      // seule fois et on continue de viser.
      if (brut != _dernierInconnu) {
        _dernierInconnu = brut;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.qrInconnu)));
      }
    }
  }

  Future<void> _saisieManuelle() async {
    final l10n = context.l10n;
    final champ = TextEditingController();
    final numero = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.qrSaisieManuelle),
        content: TextField(
          controller: champ,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(labelText: l10n.licence),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l10n.annuler)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, champ.text),
              child: Text(l10n.valider)),
        ],
      ),
    );
    champ.dispose();
    if (!mounted || numero == null || numero.trim().isEmpty) return;
    _termine = true;
    Navigator.of(context).pop(numero.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scannerQr),
        actions: [
          IconButton(
            tooltip: l10n.qrSaisieManuelle,
            icon: const Icon(Icons.keyboard),
            onPressed: _saisieManuelle,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(onDetect: _detecte),
          // Cadre de visée.
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(l10n.qrViser,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.keyboard),
                  label: Text(l10n.qrSaisieManuelle),
                  onPressed: _saisieManuelle,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
