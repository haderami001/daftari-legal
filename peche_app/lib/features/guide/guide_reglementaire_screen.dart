import 'package:flutter/material.dart';

import '../../core/regulation/referentiel.dart';

/// Guide réglementaire consultable hors ligne.
///
/// En production, le contenu (textes, articles, fiches espèces, modules de
/// formation des garde-côtes) est servi par l'API et mis en cache local.
class GuideReglementaireScreen extends StatelessWidget {
  const GuideReglementaireScreen({super.key});

  static const _textes = <(String, String)>[
    (
      'Code des pêches maritimes (Mauritanie)',
      'Loi n° 2015-017 et ses décrets/arrêtés d\'application : licences, '
          'zones, engins, tailles minimales, infractions et sanctions.',
    ),
    (
      'FAO — Accord sur les mesures du ressort de l\'État du port (PSMA)',
      'Lutte contre la pêche INN : contrôle au port des navires étrangers, '
          'refus d\'accès, échange d\'informations.',
    ),
    (
      'FAO — Code de conduite pour une pêche responsable',
      'Principes de gestion durable, sélectivité des engins, réduction '
          'des prises accessoires.',
    ),
    (
      'ICCAT',
      'Recommandations sur les thonidés de l\'Atlantique : tailles '
          'minimales, quotas, déclaration des captures, observateurs.',
    ),
    (
      'Accord de partenariat UE-Mauritanie (APPD)',
      'Protocole en vigueur : catégories de pêche, possibilités de pêche, '
          'débarquements, embarquement de marins mauritaniens, VMS / ERS.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guide réglementaire')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Valeurs de démonstration'),
            subtitle: Text('Les seuils affichés doivent être validés '
                'avec les textes officiels avant toute utilisation.'),
          ),
          for (final (titre, resume) in _textes)
            ExpansionTile(
              leading: const Icon(Icons.gavel),
              title: Text(titre),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(resume),
                ),
              ],
            ),
          ExpansionTile(
            leading: const Icon(Icons.straighten),
            title: Text('Tailles minimales (${referentielDemo.version})'),
            children: [
              for (final r in referentielDemo.especes.values)
                ListTile(
                  title: Text('${r.nomCommun} (${r.code})'),
                  subtitle: Text('${r.nomScientifique} · ${r.organisme}'),
                  trailing: Text('${r.minimum.toStringAsFixed(0)} '
                      '${r.unite.symbole}'),
                ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.grid_on),
            title: const Text('Maillages et prises accessoires'),
            children: [
              for (final r in referentielDemo.engins.values)
                ListTile(
                  title: Text(r.engin.libelle),
                  subtitle: Text('Prises accessoires max : '
                      '${r.prisesAccessoiresMaxPct.toStringAsFixed(0)} %'),
                  trailing: Text(r.maillageMinMm == 0
                      ? '—'
                      : '${r.maillageMinMm.toStringAsFixed(0)} mm'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
