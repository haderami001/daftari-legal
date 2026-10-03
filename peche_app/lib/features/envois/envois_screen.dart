import 'package:flutter/material.dart';

import '../../core/data/base/base_de_donnees.dart';
import '../../core/data/base/tables.dart';
import '../../core/services/services.dart';
import '../controle/rapport_pdf_screen.dart';

/// Liste des saisies enregistrées sur le téléphone et pas encore reçues
/// par le serveur (file d'envoi).
class EnvoisScreen extends StatefulWidget {
  const EnvoisScreen({super.key});

  @override
  State<EnvoisScreen> createState() => _EnvoisScreenState();
}

class _EnvoisScreenState extends State<EnvoisScreen> {
  Future<List<EnvoiLigne>>? _envois;
  bool _envoiEnCours = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _envois ??= ServicesScope.of(context).envois.enAttente();
  }

  Future<void> _ouvrirPdf(String controleId) async {
    final pdf = await ServicesScope.of(context).saisies.rapportPdf(controleId);
    if (!mounted) return;
    if (pdf == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Pas de PDF pour ce contrôle (version antérieure).')));
      return;
    }
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RapportPdfScreen(
          pdf: pdf, nomFichier: 'rapport_${controleId.substring(0, 8)}.pdf'),
    ));
  }

  /// Tente d'envoyer toute la file au serveur, puis rafraîchit la liste.
  Future<void> _envoyerMaintenant() async {
    final services = ServicesScope.of(context);
    setState(() => _envoiEnCours = true);
    final resultat = await services.synchro.synchroniser();
    if (!mounted) return;
    setState(() {
      _envoiEnCours = false;
      _envois = services.envois.enAttente();
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(resultat.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envois en attente'),
        actions: [
          IconButton(
            tooltip: 'Envoyer maintenant',
            onPressed: _envoiEnCours ? null : _envoyerMaintenant,
            icon: _envoiEnCours
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.cloud_upload),
          ),
        ],
      ),
      body: FutureBuilder<List<EnvoiLigne>>(
        future: _envois,
        builder: (context, snapshot) {
          final envois = snapshot.data;
          if (envois == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (envois.isEmpty) {
            return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.cloud_done, size: 48, color: Colors.green),
                SizedBox(height: 8),
                Text('Tout a été envoyé.'),
              ]),
            );
          }
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_off),
                title: Text('${envois.length} saisie(s) stockée(s) '
                    'sur le téléphone'),
                subtitle: const Text('Elles partiront automatiquement au '
                    'retour du réseau.'),
              ),
              const Divider(),
              for (final e in envois)
                ListTile(
                  leading: Icon(switch (e.type) {
                    TypeEnvoi.declaration => Icons.sailing,
                    TypeEnvoi.controle => Icons.shield,
                  }),
                  title: Text(e.resume),
                  subtitle: Text(
                    '${e.creeLe.toIso8601String().substring(0, 16).replaceFirst('T', ' ')}'
                    ' · n° ${e.entiteId.substring(0, 8)}'
                    '${e.tentatives > 0 ? ' · ${e.tentatives} échec(s)' : ''}'
                    '${e.derniereErreur == null ? '' : '\n${e.derniereErreur}'}',
                  ),
                  trailing: e.type == TypeEnvoi.controle
                      ? const Icon(Icons.picture_as_pdf)
                      : null,
                  onTap: e.type == TypeEnvoi.controle
                      ? () => _ouvrirPdf(e.entiteId)
                      : null,
                ),
            ],
          );
        },
      ),
    );
  }
}
