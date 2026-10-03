import 'package:flutter/material.dart';

import '../../core/regulation/referentiel.dart';
import '../../l10n/libelles.dart';

/// Guide réglementaire consultable hors ligne.
///
/// En production, le contenu (textes, articles, fiches espèces, modules de
/// formation des garde-côtes) est servi par l'API et mis en cache local.
class GuideReglementaireScreen extends StatelessWidget {
  const GuideReglementaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textes = <(String, String)>[
      (l10n.texteCodeTitre, l10n.texteCodeResume),
      (l10n.textePsmaTitre, l10n.textePsmaResume),
      (l10n.texteConduiteTitre, l10n.texteConduiteResume),
      (l10n.texteIccatTitre, l10n.texteIccatResume),
      (l10n.texteUeTitre, l10n.texteUeResume),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moduleGuide)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.valeursDemo),
            subtitle: Text(l10n.valeursDemoDetail),
          ),
          for (final (titre, resume) in textes)
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
            title: Text(l10n.taillesMinimales(referentielDemo.version)),
            children: [
              for (final r in referentielDemo.especes.values)
                ListTile(
                  title: Text('${l10n.nomEspece(r.code)} (${r.code})'),
                  subtitle: Text(
                      '${r.nomScientifique} · ${l10n.organisme(r.organisme)}'),
                  trailing: Text('${r.minimum.toStringAsFixed(0)} '
                      '${l10n.unite(r.unite)}'),
                ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.grid_on),
            title: Text(l10n.maillagesEtPrises),
            children: [
              for (final r in referentielDemo.engins.values)
                ListTile(
                  title: Text(l10n.libelleEngin(r.engin)),
                  subtitle: Text(l10n.prisesAccessoiresMax(
                      r.prisesAccessoiresMaxPct.toStringAsFixed(0))),
                  trailing: Text(r.maillageMinMm == 0
                      ? '—'
                      : '${r.maillageMinMm.toStringAsFixed(0)} '
                          '${l10n.uniteMm}'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
