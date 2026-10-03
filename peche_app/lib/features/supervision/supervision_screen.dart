import 'package:flutter/material.dart';

import '../../core/services/services.dart';
import '../../core/services/supervision.dart';
import '../../l10n/libelles.dart';
import '../controle/rapport_pdf_screen.dart';

/// Tableau de bord du superviseur : ce que le serveur central a reçu.
///
/// Chiffres clés, dernières déclarations et derniers contrôles (avec le
/// compte qui les a envoyés), et rapport PDF signé de chaque contrôle.
class SupervisionScreen extends StatefulWidget {
  const SupervisionScreen({super.key});

  @override
  State<SupervisionScreen> createState() => _SupervisionScreenState();
}

typedef _Donnees = ({
  Map<String, int> stats,
  List<SaisieRecue> declarations,
  List<SaisieRecue> controles,
});

class _SupervisionScreenState extends State<SupervisionScreen> {
  Future<_Donnees>? _donnees;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _donnees ??= _charger();
  }

  Future<_Donnees> _charger() async {
    final api = ServicesScope.of(context).supervision!;
    final (stats, declarations, controles) = await (
      api.statistiques(),
      api.lister('declarations'),
      api.lister('controles'),
    ).wait;
    return (stats: stats, declarations: declarations, controles: controles);
  }

  Future<void> _actualiser() async {
    final f = _charger();
    setState(() {
      _donnees = f;
    });
    await f.catchError((_) => (
          stats: const <String, int>{},
          declarations: const <SaisieRecue>[],
          controles: const <SaisieRecue>[],
        ));
  }

  Future<void> _ouvrirRapport(SaisieRecue c) async {
    final api = ServicesScope.of(context).supervision!;
    final messager = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      final pdf = await api.rapportPdf(c.id);
      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => RapportPdfScreen(
            pdf: pdf, nomFichier: 'rapport_${c.id.substring(0, 8)}.pdf'),
      ));
    } catch (e) {
      messager
          .showSnackBar(SnackBar(content: Text(l10n.adminChargement('$e'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.moduleSupervision),
          actions: [
            IconButton(
              tooltip: l10n.actualiser,
              onPressed: _actualiser,
              icon: const Icon(Icons.refresh),
            ),
          ],
          bottom: TabBar(tabs: [
            Tab(text: l10n.ongletDeclarations),
            Tab(text: l10n.ongletControles),
          ]),
        ),
        body: FutureBuilder(
          future: _donnees,
          builder: (context, etat) {
            if (etat.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l10n.adminChargement('${etat.error}'),
                      textAlign: TextAlign.center),
                ),
              );
            }
            if (!etat.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final d = etat.data!;
            Widget liste(List<SaisieRecue> saisies, {bool rapport = false}) =>
                RefreshIndicator(
                  onRefresh: _actualiser,
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      _Chiffres(d.stats, saisies),
                      if (saisies.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(l10n.aucunElement,
                              textAlign: TextAlign.center),
                        ),
                      for (final s in saisies)
                        Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: s.nbInfractions == 0
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              child: Text('${s.nbInfractions}'),
                            ),
                            title: Text(l10n.navireLe(
                                s.navireId, _date(context, s.date))),
                            subtitle: Text([
                              l10n.nbInfractions(s.nbInfractions),
                              if (s.envoyePar != null)
                                l10n.envoyePar(s.envoyePar!),
                            ].join(' · ')),
                            trailing: rapport
                                ? const Icon(Icons.picture_as_pdf)
                                : null,
                            onTap: rapport ? () => _ouvrirRapport(s) : null,
                          ),
                        ),
                    ],
                  ),
                );
            return TabBarView(children: [
              liste(d.declarations),
              liste(d.controles, rapport: true),
            ]);
          },
        ),
      ),
    );
  }

  static String _date(BuildContext context, DateTime d) =>
      MaterialLocalizations.of(context).formatShortDate(d);
}

/// Chiffres clés en tête de liste.
class _Chiffres extends StatelessWidget {
  const _Chiffres(this.stats, this.saisies);

  final Map<String, int> stats;
  final List<SaisieRecue> saisies;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final avecInfraction = saisies.where((s) => s.nbInfractions > 0).length;
    Widget tuile(String valeur, String libelle) => Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                Text(valeur, style: Theme.of(context).textTheme.headlineSmall),
                Text(libelle, textAlign: TextAlign.center),
              ]),
            ),
          ),
        );
    // Même hauteur pour les trois cartes.
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        tuile('${stats['declarations'] ?? 0}', l10n.ongletDeclarations),
        tuile('${stats['controles'] ?? 0}', l10n.ongletControles),
        tuile('$avecInfraction', l10n.avecInfraction),
      ]),
    );
  }
}
