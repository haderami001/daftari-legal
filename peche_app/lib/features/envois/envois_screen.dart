import 'package:flutter/material.dart';

import '../../core/data/base/base_de_donnees.dart';
import '../../core/data/base/tables.dart';
import '../../core/services/services.dart';
import '../../core/services/synchronisation.dart';
import '../../l10n/libelles.dart';
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.pasDePdf)));
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
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(switch (resultat.statut) {
      StatutSynchro.termine => [
          l10n.resultatEnvoi(resultat.envoyes, resultat.echecs),
          if (resultat.referentielVersion != null) l10n.referentielMisAJour,
        ].join(' · '),
      StatutSynchro.nonConfigure => l10n.serveurNonConfigure,
      StatutSynchro.dejaEnCours => l10n.envoiDejaEnCours,
    })));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.moduleEnvois),
        actions: [
          IconButton(
            tooltip: l10n.envoyerMaintenant,
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
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.cloud_done, size: 48, color: Colors.green),
                const SizedBox(height: 8),
                Text(l10n.toutEnvoye),
              ]),
            );
          }
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_off),
                title: Text(l10n.saisiesStockees(envois.length)),
                subtitle: Text(l10n.retourReseau),
              ),
              const Divider(),
              for (final e in envois)
                ListTile(
                  leading: Icon(switch (e.type) {
                    TypeEnvoi.declaration => Icons.sailing,
                    TypeEnvoi.controle => Icons.shield,
                  }),
                  title: Text('${switch (e.type) {
                    TypeEnvoi.declaration => l10n.typeDeclaration,
                    TypeEnvoi.controle => l10n.typeControle,
                  }} — ${e.resume}'),
                  subtitle: Text(
                    '${e.creeLe.toIso8601String().substring(0, 16).replaceFirst('T', ' ')}'
                    ' · ${l10n.numero(e.entiteId.substring(0, 8))}'
                    '${e.tentatives > 0 ? ' · ${l10n.echecs(e.tentatives)}' : ''}'
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
