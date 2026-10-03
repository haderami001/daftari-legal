import 'package:flutter/material.dart';

import '../../core/services/services.dart';
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
  int? _enAttente;

  bool _demarre = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_demarre) {
      _demarre = true;
      _synchroniserPuisCompter();
    }
  }

  /// Si un serveur est configuré, envoie la file en arrière-plan (sans
  /// bloquer l'écran), puis met à jour le compteur.
  Future<void> _synchroniserPuisCompter() async {
    await _compterEnvois();
    if (!mounted) return;
    final synchro = ServicesScope.of(context).synchro;
    if (synchro.estConfigure) {
      await synchro.synchroniser();
      if (mounted) await _compterEnvois();
    }
  }

  Future<void> _compterEnvois() async {
    final n = await ServicesScope.of(context).envois.nombreEnAttente();
    if (mounted) setState(() => _enAttente = n);
  }

  /// Ouvre un module puis, au retour, met à jour le compteur d'envois.
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
    await _synchroniserPuisCompter();
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
          if (!profil.peutDeclarer &&
              !profil.peutControler &&
              !(profil.peutSuperviser && services.supervision != null))
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.aucunModule),
            ),
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
              title: Text(l10n.moduleEnvois),
              subtitle: Text(switch (_enAttente) {
                null => l10n.envoisLecture,
                0 => l10n.envoisToutSynchronise,
                final n => l10n.envoisAEnvoyer(n),
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
