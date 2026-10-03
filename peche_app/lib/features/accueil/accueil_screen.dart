import 'package:flutter/material.dart';

import '../../core/data/depots/depots.dart';
import '../controle/controle_agent_screen.dart';
import '../declaration/declaration_capitaine_screen.dart';
import '../envois/envois_screen.dart';
import '../guide/guide_reglementaire_screen.dart';

/// Écran d'accueil : chaque profil (capitaine, agent) accède à son module.
/// En production, les tuiles visibles dépendent du rôle de l'utilisateur
/// connecté (contrôle d'accès basé sur les rôles côté API).
class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  int? _enAttente;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_enAttente == null) _compterEnvois();
  }

  Future<void> _compterEnvois() async {
    final n = await DepotsScope.of(context).envois.nombreEnAttente();
    if (mounted) setState(() => _enAttente = n);
  }

  /// Ouvre un module puis, au retour, met à jour le compteur d'envois.
  Future<void> _ouvrir(Widget ecran) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ecran));
    if (mounted) await _compterEnvois();
  }

  @override
  Widget build(BuildContext context) {
    final modules = <(IconData, String, String, Widget)>[
      (
        Icons.sailing,
        'Déclaration du capitaine',
        'Navire, licence, équipage, captures',
        const DeclarationCapitaineScreen(),
      ),
      (
        Icons.shield,
        'Contrôle garde-côtes',
        'Inspection, maillage, échantillons, rapport',
        const ControleAgentScreen(),
      ),
      (
        Icons.menu_book,
        'Guide réglementaire',
        'Code des pêches, FAO, ICCAT, UE-Mauritanie',
        const GuideReglementaireScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pêche Conforme')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final (icone, titre, sousTitre, ecran) in modules)
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Icon(icone, size: 36),
                title: Text(titre),
                subtitle: Text(sousTitre),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _ouvrir(ecran),
              ),
            ),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Badge(
                isLabelVisible: (_enAttente ?? 0) > 0,
                label: Text('${_enAttente ?? 0}'),
                child: const Icon(Icons.cloud_upload, size: 36),
              ),
              title: const Text('Envois en attente'),
              subtitle: Text(switch (_enAttente) {
                null => 'Lecture de la base locale…',
                0 => 'Tout est synchronisé',
                final n => '$n saisie(s) à envoyer au serveur',
              }),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _ouvrir(const EnvoisScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
