import 'package:flutter/material.dart';

import '../controle/controle_agent_screen.dart';
import '../declaration/declaration_capitaine_screen.dart';
import '../guide/guide_reglementaire_screen.dart';

/// Écran d'accueil : chaque profil (capitaine, agent) accède à son module.
/// En production, les tuiles visibles dépendent du rôle de l'utilisateur
/// connecté (contrôle d'accès basé sur les rôles côté API).
class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

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
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ecran)),
              ),
            ),
        ],
      ),
    );
  }
}
