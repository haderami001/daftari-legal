import 'package:flutter/material.dart';

import '../../core/services/services.dart';
import '../../core/theme.dart';
import '../../l10n/libelles.dart';
import '../../main.dart';
import '../administration/administration_screen.dart';
import '../controle/controle_agent_screen.dart';
import '../declaration/declaration_capitaine_screen.dart';
import '../envois/envois_screen.dart';
import '../guide/guide_reglementaire_screen.dart';
import '../supervision/supervision_screen.dart';

/// Écran d'accueil : chaque profil (capitaine, agent) accède à son module.
/// En production, les tuiles visibles dépendent du rôle de l'utilisateur
/// connecté (contrôle d'accès basé sur les rôles côté API).
class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  /// Nombre de saisies en attente, mis à jour tout seul par la base
  /// (Drift) : plus besoin de recompter après chaque écran. Créé une seule
  /// fois, comme le Future d'un FutureBuilder.
  Stream<int>? _enAttente;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_enAttente == null) {
      _enAttente = ServicesScope.of(context).envois.surveillerNombreEnAttente();
      _synchroniser();
    }
  }

  /// Si un serveur est configuré, envoie la file en arrière-plan (sans
  /// bloquer l'écran). Le compteur suit seul, grâce au flux.
  Future<void> _synchroniser() async {
    final synchro = ServicesScope.of(context).synchro;
    if (synchro.estConfigure) await synchro.synchroniser();
  }

  /// Ouvre un module puis, au retour, relance la synchronisation.
  ///
  /// `await push(...)` attend la fermeture de l'écran et reçoit la valeur
  /// passée à `Navigator.pop(context, valeur)` : l'administration renvoie
  /// le nombre de modifications enregistrées (les autres écrans, rien).
  Future<void> _ouvrir(Widget ecran) async {
    final resultat = await Navigator.of(context)
        .push<Object?>(MaterialPageRoute(builder: (_) => ecran));
    if (!mounted) return;
    if (resultat is int && resultat > 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar() // remplace « Navire enregistré » éventuel
        ..showSnackBar(SnackBar(
            content: Text(context.l10n.modificationsEnregistrees(resultat))));
    }
    await _synchroniser();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final services = ServicesScope.of(context);
    final session = services.session;
    final profil = session.profil!;
    // Chaque compte ne voit que les modules de son rôle.
    final modules = <(IconData, String, String, Widget)>[
      if (profil.peutDeclarer)
        (
          Icons.sailing,
          l10n.moduleDeclaration,
          l10n.moduleDeclarationDetail,
          const DeclarationCapitaineScreen(),
        ),
      if (profil.peutControler)
        (
          Icons.shield,
          l10n.moduleControle,
          l10n.moduleControleDetail,
          const ControleAgentScreen(),
        ),
      (
        Icons.menu_book,
        l10n.moduleGuide,
        l10n.moduleGuideDetail,
        const GuideReglementaireScreen(),
      ),
      // Tableau de bord : en ligne seulement (serveur configuré).
      if (profil.peutSuperviser && services.supervision != null)
        (
          Icons.dashboard,
          l10n.moduleSupervision,
          l10n.moduleSupervisionDetail,
          const SupervisionScreen(),
        ),
      // Administration : en ligne seulement (serveur configuré).
      if (profil.peutAdministrer && services.administration != null)
        (
          Icons.admin_panel_settings,
          l10n.moduleAdministration,
          l10n.moduleAdministrationDetail,
          const AdministrationScreen(),
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          const _ChoixLangue(),
          if (session.exigeConnexion)
            PopupMenuButton<void>(
              tooltip: l10n.compte,
              icon: const Icon(Icons.account_circle),
              itemBuilder: (_) => [
                PopupMenuItem(
                  enabled: false,
                  child: Text('${profil.nomComplet}\n${profil.identifiant}'),
                ),
                PopupMenuItem(
                  onTap: session.deconnecter,
                  child: Text(l10n.deconnexion),
                ),
              ],
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Entete(nom: profil.nomComplet),
          const SizedBox(height: 12),
          if (!profil.peutDeclarer &&
              !profil.peutControler &&
              !(profil.peutSuperviser && services.supervision != null))
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.aucunModule),
            ),
          for (final (i, (icone, titre, sousTitre, ecran)) in modules.indexed)
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: _IconeModule(icone, _couleursModules[i % 6]),
                title: Text(titre),
                subtitle: Text(sousTitre),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _ouvrir(ecran),
              ),
            ),
          // StreamBuilder : redessine la carte à chaque nouvelle valeur
          // du flux (comme FutureBuilder, mais pour plusieurs valeurs).
          StreamBuilder<int>(
            stream: _enAttente,
            builder: (context, etat) {
              final n = etat.data; // null tant que rien n'est arrivé
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Badge(
                    isLabelVisible: (n ?? 0) > 0,
                    label: Text('${n ?? 0}'),
                    child: const _IconeModule(
                        Icons.cloud_upload, CouleursPeche.vertMauritanie),
                  ),
                  title: Text(l10n.moduleEnvois),
                  subtitle: Text(switch (n) {
                    null => l10n.envoisLecture,
                    0 => l10n.envoisToutSynchronise,
                    final n => l10n.envoisAEnvoyer(n),
                  }),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _ouvrir(const EnvoisScreen()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Couleur de l'icône de chaque module, dans l'ordre de la liste.
const _couleursModules = [
  CouleursPeche.ocean,
  CouleursPeche.marine,
  CouleursPeche.sauvetage,
  CouleursPeche.vertMauritanie,
  Color(0xFF6A4C93),
  Color(0xFF00838F),
];

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

/// Bandeau d'accueil : nom de l'application, mission, compte connecté.
class _Entete extends StatelessWidget {
  const _Entete({required this.nom});

  final String nom;

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
              const Icon(Icons.anchor, color: CouleursPeche.marine, size: 36),
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
              Text(l10n.accueilMission,
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
              if (nom.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(l10n.connecteEnTantQue(nom),
                    style: texte.bodySmall?.copyWith(color: Colors.white)),
              ],
            ],
          ),
        ),
      ]),
    );
  }
}

/// Menu « Langue » : langue du téléphone, français ou arabe.
class _ChoixLangue extends StatelessWidget {
  const _ChoixLangue();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actuelle = PecheApp.langueChoisie(context)?.languageCode;
    return PopupMenuButton<String>(
      tooltip: l10n.langue,
      icon: const Icon(Icons.translate),
      initialValue: actuelle ?? 'systeme',
      onSelected: (code) => PecheApp.choisirLangue(
          context, code == 'systeme' ? null : Locale(code)),
      itemBuilder: (_) => [
        PopupMenuItem(value: 'systeme', child: Text(l10n.langueSysteme)),
        PopupMenuItem(value: 'fr', child: Text(l10n.langueFrancais)),
        PopupMenuItem(value: 'ar', child: Text(l10n.langueArabe)),
      ],
    );
  }
}
