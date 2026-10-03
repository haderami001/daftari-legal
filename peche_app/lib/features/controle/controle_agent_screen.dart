import 'package:flutter/material.dart';

import '../../core/data/donnees_demo.dart';
import '../../core/models/declaration.dart';
import '../../core/models/enums.dart';
import '../../core/models/navire.dart';
import '../../core/regulation/calcul_reglementaire.dart';
import '../../core/regulation/rapport.dart';
import '../../core/regulation/referentiel.dart';
import '../../core/widgets/resultat_card.dart';

/// Prototype : fiche d'inspection de l'agent garde-côtes.
///
/// Le résultat réglementaire est recalculé en direct à chaque saisie,
/// puis un rapport est généré automatiquement.
class ControleAgentScreen extends StatefulWidget {
  const ControleAgentScreen({super.key});

  @override
  State<ControleAgentScreen> createState() => _ControleAgentScreenState();
}

class _ControleAgentScreenState extends State<ControleAgentScreen> {
  final _calcul = const CalculReglementaire(referentielDemo);
  late Controle _controle = _nouveauControle(naviresDemo[1]);

  final _maillageCtrl = TextEditingController();
  final _echantillonCtrl = TextEditingController();
  String _especeEchantillon = referentielDemo.especes.keys.first;

  Controle _nouveauControle(Navire n) => Controle(
        navire: n,
        agent: 'Agent GCM-0427', // en production : utilisateur connecté
        date: DateTime.now(),
        position: PositionGps(20.62, -17.30, DateTime.now()),
        engin: licencesDemo[n.id]!.enginsAutorises.first,
      );

  Licence get _licence => licencesDemo[_controle.navire.id]!;

  @override
  void dispose() {
    _maillageCtrl.dispose();
    _echantillonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controle;
    final resultat = _calcul.verifierControle(c, licence: _licence);
    final regleEngin = referentielDemo.engin(c.engin);
    final regleEspece = referentielDemo.espece(_especeEchantillon)!;

    return Scaffold(
      appBar: AppBar(title: const Text('Contrôle garde-côtes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- 1. Identification du navire ----------
          _Section(
            titre: '1. Navire',
            icone: Icons.directions_boat,
            children: [
              DropdownButtonFormField<Navire>(
                isExpanded: true,
                value: c.navire,
                decoration: const InputDecoration(labelText: 'Navire inspecté'),
                items: [
                  for (final n in naviresDemo)
                    DropdownMenuItem(
                        value: n,
                        child: Text('${n.nom} (${n.immatriculation})')),
                ],
                onChanged: (n) =>
                    setState(() => _controle = _nouveauControle(n!)),
              ),
              Text('Pavillon : ${c.navire.pavillon} · '
                  '${c.navire.type.libelle} · ${c.navire.longueurM} m · '
                  '${c.navire.puissanceKw} kW'),
              Text('Licence : ${_licence.numero}'),
              Text('Position : ${c.position}'),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Pavillon et documents de bord concordants'),
                value: c.pavillonConforme,
                onChanged: (v) => setState(() => c.pavillonConforme = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Marquage / immatriculation visible'),
                value: c.marquageConforme,
                onChanged: (v) => setState(() => c.marquageConforme = v),
              ),
            ],
          ),

          // ---------- 2. Certificats ----------
          _Section(
            titre: '2. Certificats',
            icone: Icons.description,
            children: [
              for (final cert in c.navire.certificats)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    cert.estValideLe(c.date)
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: cert.estValideLe(c.date) ? Colors.green : Colors.red,
                  ),
                  title: Text(cert.type.libelle),
                  subtitle: Text('${cert.numero} · expire le '
                      '${cert.dateExpiration.toIso8601String().substring(0, 10)}'),
                ),
            ],
          ),

          // ---------- 3. Engin & maillage ----------
          _Section(
            titre: '3. Engin et maillage',
            icone: Icons.grid_on,
            children: [
              DropdownButtonFormField<TypeEngin>(
                isExpanded: true,
                value: c.engin,
                decoration: const InputDecoration(labelText: 'Engin à bord'),
                items: [
                  for (final e in TypeEngin.values)
                    DropdownMenuItem(value: e, child: Text(e.libelle)),
                ],
                onChanged: (e) => setState(() => c.engin = e!),
              ),
              if (regleEngin != null && regleEngin.maillageMinMm > 0) ...[
                Text('Minimum : ${regleEngin.maillageMinMm} mm '
                    '(tolérance ${referentielDemo.toleranceMaillagePct} %)'),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _maillageCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Mesure d\'une maille (mm)'),
                      onSubmitted: (_) => _ajouterMaillage(),
                    ),
                  ),
                  IconButton.filled(
                      onPressed: _ajouterMaillage, icon: const Icon(Icons.add)),
                ]),
                Wrap(spacing: 6, children: [
                  for (final (i, m) in c.maillagesMm.indexed)
                    InputChip(
                      label: Text('$m mm'),
                      onDeleted: () =>
                          setState(() => c.maillagesMm.removeAt(i)),
                    ),
                ]),
              ] else
                const Text('Pas de maillage réglementé pour cet engin.'),
            ],
          ),

          // ---------- 4. Échantillons ----------
          _Section(
            titre: '4. Échantillons (tailles minimales)',
            icone: Icons.straighten,
            children: [
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _especeEchantillon,
                decoration: const InputDecoration(labelText: 'Espèce'),
                items: [
                  for (final r in referentielDemo.especes.values)
                    DropdownMenuItem(
                      value: r.code,
                      child: Text('${r.nomCommun} — min ${r.minimum} '
                          '${r.unite.symbole}'),
                    ),
                ],
                onChanged: (v) => setState(() => _especeEchantillon = v!),
              ),
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _echantillonCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Mesure (${regleEspece.unite.symbole})'),
                    onSubmitted: (_) => _ajouterEchantillon(),
                  ),
                ),
                IconButton.filled(
                    onPressed: _ajouterEchantillon,
                    icon: const Icon(Icons.add)),
              ]),
              Wrap(spacing: 6, children: [
                for (final (i, e) in c.echantillons.indexed)
                  InputChip(
                    backgroundColor:
                        e.valeur < referentielDemo.espece(e.especeCode)!.minimum
                            ? Colors.red.withOpacity(0.2)
                            : null,
                    label: Text('${e.especeCode} ${e.valeur}'),
                    onDeleted: () => setState(() => c.echantillons.removeAt(i)),
                  ),
              ]),
            ],
          ),

          // ---------- 5. Stockage ----------
          _Section(
            titre: '5. Plan de stockage',
            icone: Icons.inventory_2,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                    'Cales conformes au plan de stockage et au journal'),
                value: c.planStockageConforme,
                onChanged: (v) => setState(() => c.planStockageConforme = v),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Observations'),
                maxLines: 2,
                onChanged: (v) => c.observations = v,
              ),
            ],
          ),

          const SizedBox(height: 8),
          ResultatCard(resultat: resultat),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Générer le rapport d\'inspection'),
            onPressed: () => _afficherRapport(resultat),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _ajouterMaillage() {
    final v = double.tryParse(_maillageCtrl.text.replaceAll(',', '.'));
    if (v == null || v <= 0) return;
    setState(() => _controle.maillagesMm.add(v));
    _maillageCtrl.clear();
  }

  void _ajouterEchantillon() {
    final v = double.tryParse(_echantillonCtrl.text.replaceAll(',', '.'));
    if (v == null || v <= 0) return;
    setState(() => _controle.echantillons
        .add(Echantillon(especeCode: _especeEchantillon, valeur: v)));
    _echantillonCtrl.clear();
  }

  void _afficherRapport(ResultatVerification r) {
    final texte = genererRapportControle(_controle, r);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rapport généré'),
        content: SingleChildScrollView(
          child: SelectableText(texte,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Fermer')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Rapport signé et mis en file d\'envoi.')));
            },
            child: const Text('Signer'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(
      {required this.titre, required this.icone, required this.children});

  final String titre;
  final IconData icone;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icone),
              const SizedBox(width: 8),
              Expanded(
                child:
                    Text(titre, style: Theme.of(context).textTheme.titleMedium),
              ),
            ]),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
