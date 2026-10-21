import 'package:flutter/material.dart';
import 'package:peche_regles/peche_regles.dart';

import 'l10n/libelles.dart';

/// Moteur de calcul partagé avec Pêche Conforme : l'inspecteur obtient le
/// même résultat que l'agent qui fait le contrôle dans l'autre application.
const _ref = referentielDemo;
const _calcul = CalculReglementaire(_ref);

/// Calculateurs de l'inspecteur : maillage et tailles minimales.
///
/// L'inspecteur saisit ses mesures ; le calculateur indique la règle
/// appliquée, le résultat, la gravité et l'amende indicative, ainsi que le
/// texte d'où vient la règle.
class CalculateursScreen extends StatelessWidget {
  const CalculateursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.moduleCalculateurs),
          bottom: TabBar(tabs: [
            Tab(text: l10n.ongletMaillage),
            Tab(text: l10n.ongletTailles),
          ]),
        ),
        body: const TabBarView(children: [_Maillage(), _Tailles()]),
      ),
    );
  }
}

/// Maillage : moyenne des mailles mesurées comparée au minimum de l'engin,
/// diminué de la tolérance.
class _Maillage extends StatefulWidget {
  const _Maillage();

  @override
  State<_Maillage> createState() => _MaillageState();
}

class _MaillageState extends State<_Maillage> {
  TypeEngin _engin = TypeEngin.chalutDemersal;
  final _mesures = <double>[];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final regle = _ref.engin(_engin);
    final reglemente = regle != null && regle.maillageMinMm > 0;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<TypeEngin>(
          isExpanded: true,
          initialValue: _engin,
          decoration: InputDecoration(labelText: l10n.enginLabel),
          items: [
            for (final e in TypeEngin.values)
              DropdownMenuItem(value: e, child: Text(l10n.libelleEngin(e))),
          ],
          onChanged: (e) => setState(() {
            _engin = e!;
            _mesures.clear();
          }),
        ),
        const SizedBox(height: 16),
        if (!reglemente)
          Text(l10n.pasDeMaillage)
        else ...[
          Text(l10n.maillageMinimum(
            formaterMontant(regle.maillageMinMm),
            formaterMontant(_ref.toleranceMaillagePct),
          )),
          Text(l10n.seuilRetenu(
              (regle.maillageMinMm * (1 - _ref.toleranceMaillagePct / 100))
                  .toStringAsFixed(1))),
          const SizedBox(height: 12),
          _Mesures(
            libelle: l10n.mesureMaille,
            mesures: _mesures,
            onChange: () => setState(() {}),
          ),
          const SizedBox(height: 12),
          if (_mesures.isNotEmpty) ...[
            Text(l10n.moyenneMesuree(
                (_mesures.reduce((a, b) => a + b) / _mesures.length)
                    .toStringAsFixed(1))),
            const SizedBox(height: 8),
            _Verdict(ResultatVerification(
              _calcul.verifierMaillage(_engin, _mesures),
              _ref.bareme,
            )),
          ],
        ],
      ],
    );
  }
}

/// Tailles minimales : chaque individu mesuré est comparé au minimum de son
/// espèce ; la gravité dépend de la part d'individus trop petits.
class _Tailles extends StatefulWidget {
  const _Tailles();

  @override
  State<_Tailles> createState() => _TaillesState();
}

class _TaillesState extends State<_Tailles> {
  String _espece = _ref.especes.keys.first;
  final _mesures = <double>[];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final regle = _ref.espece(_espece)!;
    final unite = l10n.unite(regle.unite);
    final sous = _mesures.where((m) => m < regle.minimum).length;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: _espece,
          decoration: InputDecoration(labelText: l10n.espece),
          items: [
            for (final r in _ref.especes.values)
              DropdownMenuItem(
                  value: r.code,
                  child: Text('${l10n.nomEspece(r.code)} (${r.code})')),
          ],
          onChanged: (code) => setState(() {
            _espece = code!;
            _mesures.clear();
          }),
        ),
        const SizedBox(height: 16),
        Text(l10n.tailleMinimale(formaterMontant(regle.minimum), unite)),
        Text(
          l10n.source(l10n.organisme(regle.organisme), _ref.version),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        _Mesures(
          libelle: l10n.mesureEchantillon(unite),
          mesures: _mesures,
          // Individu sous la taille : puce en rouge.
          horsNorme: (m) => m < regle.minimum,
          onChange: () => setState(() {}),
        ),
        const SizedBox(height: 12),
        if (_mesures.isNotEmpty) ...[
          Text(l10n.sousTaille('$sous', '${_mesures.length}')),
          const SizedBox(height: 8),
          _Verdict(ResultatVerification(
            _calcul.verifierTailles([
              for (final m in _mesures)
                Echantillon(especeCode: _espece, valeur: m),
            ]),
            _ref.bareme,
          )),
        ],
      ],
    );
  }
}

/// Saisie des mesures : un champ, un bouton « + », et les mesures déjà
/// saisies en puces (supprimables).
class _Mesures extends StatefulWidget {
  const _Mesures({
    required this.libelle,
    required this.mesures,
    required this.onChange,
    this.horsNorme,
  });

  final String libelle;
  final List<double> mesures;
  final VoidCallback onChange;
  final bool Function(double)? horsNorme;

  @override
  State<_Mesures> createState() => _MesuresState();
}

class _MesuresState extends State<_Mesures> {
  final _saisie = TextEditingController();

  @override
  void dispose() {
    _saisie.dispose();
    super.dispose();
  }

  void _ajouter() {
    // Virgule ou point décimal acceptés (65,5 ou 65.5).
    final v = double.tryParse(_saisie.text.trim().replaceAll(',', '.'));
    if (v == null || v <= 0) return;
    widget.mesures.add(v);
    _saisie.clear();
    widget.onChange();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final couleurs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          Expanded(
            child: TextField(
              controller: _saisie,
              decoration: InputDecoration(labelText: widget.libelle),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _ajouter(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            tooltip: l10n.ajouter,
            onPressed: _ajouter,
            icon: const Icon(Icons.add),
          ),
        ]),
        if (widget.mesures.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(l10n.aucuneMesure),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              for (final (i, m) in widget.mesures.indexed)
                InputChip(
                  label: Text(m.toStringAsFixed(m % 1 == 0 ? 0 : 1)),
                  backgroundColor: (widget.horsNorme?.call(m) ?? false)
                      ? couleurs.errorContainer
                      : null,
                  onDeleted: () {
                    widget.mesures.removeAt(i);
                    widget.onChange();
                  },
                ),
            ]),
          ),
      ],
    );
  }
}

/// Résultat d'un calcul : conforme, ou non conforme avec la gravité et
/// l'amende indicative du barème.
class _Verdict extends StatelessWidget {
  const _Verdict(this.resultat);

  final ResultatVerification resultat;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (resultat.conforme) {
      return Card(
        color: Colors.green.withValues(alpha: 0.15),
        child: ListTile(
          leading: const Icon(Icons.check_circle, color: Colors.green),
          title: Text(l10n.conforme),
        ),
      );
    }
    final gravite = resultat.infractions.first.gravite;
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: ListTile(
        leading: const Icon(Icons.warning_amber),
        title: Text(l10n.nonConforme(l10n.libelleGravite(gravite))),
        // Montants isolés : « 1 000 000 » garde son ordre dans une phrase
        // arabe, quel que soit le moteur de texte (téléphone ou web).
        subtitle: Text(l10n.amendeIndicative(
          isolerGaucheDroite(formaterMontant(resultat.amendeMin)),
          isolerGaucheDroite(formaterMontant(resultat.amendeMax)),
        )),
      ),
    );
  }
}
