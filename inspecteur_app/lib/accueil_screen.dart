import 'package:flutter/material.dart';
import 'package:peche_regles/peche_regles.dart';

import 'calculateurs_screen.dart';
import 'l10n/libelles.dart';
import 'main.dart';
import 'theme.dart';

/// Accueil : les modules de l'assistant de l'inspecteur.
class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // (icône, couleur, titre, détail, écran) ; écran `null` = pas encore prêt.
    final modules = <(IconData, Color, String, String, Widget?)>[
      (
        Icons.calculate,
        CouleursPeche.ocean,
        l10n.moduleCalculateurs,
        l10n.moduleCalculateursDetail,
        const CalculateursScreen(),
      ),
      (
        Icons.menu_book,
        CouleursPeche.sauvetage,
        l10n.moduleBibliotheque,
        l10n.moduleBibliothequeDetail,
        null,
      ),
      (
        Icons.campaign,
        CouleursPeche.vertMauritanie,
        l10n.moduleNouveautes,
        l10n.moduleNouveautesDetail,
        null,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [_ChoixLangue()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Entete(),
          const SizedBox(height: 12),
          // Rappel permanent : les seuils ne sont pas encore officiels.
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.valeursDemoVersion(referentielDemo.version)),
              subtitle: Text(l10n.valeursDemoDetail),
            ),
          ),
          for (final (icone, couleur, titre, detail, ecran) in modules)
            Card(
              child: ListTile(
                enabled: ecran != null,
                contentPadding: const EdgeInsets.all(12),
                leading: _IconeModule(icone, couleur),
                title: Text(titre),
                subtitle: Text(detail),
                trailing: ecran == null
                    ? Chip(label: Text(l10n.bientot))
                    : const Icon(Icons.chevron_right),
                onTap: ecran == null
                    ? null
                    : () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => ecran)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Bandeau d'accueil (même style que Pêche Conforme).
class _Entete extends StatelessWidget {
  const _Entete();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final texte = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: CouleursPeche.degradeEntete,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child:
              const Icon(Icons.policy, color: CouleursPeche.marine, size: 36),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.appTitle,
                  style: texte.headlineSmall?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(l10n.accueilSousTitre,
                  style: texte.bodyMedium?.copyWith(color: Colors.white70)),
              const SizedBox(height: 8),
              // Bande aux couleurs du drapeau mauritanien.
              Row(children: [
                for (final c in const [
                  Color(0xFFD01C1F),
                  CouleursPeche.vertMauritanie,
                  CouleursPeche.or,
                  CouleursPeche.vertMauritanie,
                  Color(0xFFD01C1F),
                ])
                  Container(width: 18, height: 4, color: c),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}

/// Icône de module dans un carré arrondi coloré.
class _IconeModule extends StatelessWidget {
  const _IconeModule(this.icone, this.couleur);

  final IconData icone;
  final Color couleur;

  @override
  Widget build(BuildContext context) => Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: couleur.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icone, color: couleur, size: 30),
      );
}

/// Menu « Langue » : langue du téléphone, français ou arabe.
class _ChoixLangue extends StatelessWidget {
  const _ChoixLangue();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actuelle = InspecteurApp.langueChoisie(context)?.languageCode;
    return PopupMenuButton<String>(
      tooltip: l10n.langue,
      icon: const Icon(Icons.translate),
      initialValue: actuelle ?? 'systeme',
      onSelected: (code) => InspecteurApp.choisirLangue(
          context, code == 'systeme' ? null : Locale(code)),
      itemBuilder: (_) => [
        PopupMenuItem(value: 'systeme', child: Text(l10n.langueSysteme)),
        PopupMenuItem(value: 'fr', child: Text(l10n.langueFrancais)),
        PopupMenuItem(value: 'ar', child: Text(l10n.langueArabe)),
      ],
    );
  }
}
