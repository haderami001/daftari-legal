import 'package:flutter/material.dart';

import '../../core/data/donnees_demo.dart';
import '../../core/models/declaration.dart';
import '../../core/models/enums.dart';
import '../../core/models/navire.dart';
import '../../core/regulation/calcul_reglementaire.dart';
import '../../core/regulation/referentiel.dart';
import '../../core/widgets/resultat_card.dart';

/// Prototype : déclaration du capitaine en 4 étapes (Stepper).
///
/// 1. Navire & licence   2. Équipage   3. Captures   4. Vérification & envoi
class DeclarationCapitaineScreen extends StatefulWidget {
  const DeclarationCapitaineScreen({super.key});

  @override
  State<DeclarationCapitaineScreen> createState() =>
      _DeclarationCapitaineScreenState();
}

class _DeclarationCapitaineScreenState
    extends State<DeclarationCapitaineScreen> {
  final _calcul = const CalculReglementaire(referentielDemo);

  int _etape = 0;
  Navire _navire = naviresDemo.first;
  late TypeEngin _engin = licencesDemo[_navire.id]!.enginsAutorises.first;
  final _equipage = <MembreEquipage>[];
  final _captures = <Capture>[];

  // Position fictive au large de Nouadhibou. En production : package
  // `geolocator` + horodatage, et contrôle de cohérence avec le VMS.
  final _position = PositionGps(20.85, -17.45, DateTime.now());

  Licence get _licence => licencesDemo[_navire.id]!;

  DeclarationCapitaine get _declaration => DeclarationCapitaine(
        navire: _navire,
        licence: _licence,
        engin: _engin,
        position: _position,
        equipage: _equipage,
        captures: _captures,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Déclaration du capitaine')),
      body: Stepper(
        currentStep: _etape,
        onStepTapped: (i) => setState(() => _etape = i),
        onStepContinue: _etape < 3
            ? () => setState(() => _etape++)
            : _envoyer,
        onStepCancel: _etape > 0 ? () => setState(() => _etape--) : null,
        controlsBuilder: (context, details) => Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            FilledButton(
              onPressed: details.onStepContinue,
              child: Text(_etape < 3 ? 'Suivant' : 'Signer et envoyer'),
            ),
            if (_etape > 0)
              TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Retour')),
          ]),
        ),
        steps: [
          Step(
            title: const Text('Navire & licence'),
            isActive: _etape >= 0,
            content: _etapeNavire(),
          ),
          Step(
            title: Text('Équipage (${_equipage.length})'),
            isActive: _etape >= 1,
            content: _etapeEquipage(),
          ),
          Step(
            title: Text('Captures (${_captures.length})'),
            isActive: _etape >= 2,
            content: _etapeCaptures(),
          ),
          Step(
            title: const Text('Vérification'),
            isActive: _etape >= 3,
            content: _etapeVerification(),
          ),
        ],
      ),
    );
  }

  // ---------------- Étape 1 ----------------
  Widget _etapeNavire() {
    final aujourdHui = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<Navire>(
          isExpanded: true,
          value: _navire,
          decoration: const InputDecoration(labelText: 'Navire'),
          items: [
            for (final n in naviresDemo)
              DropdownMenuItem(
                value: n,
                child: Text('${n.nom} — ${n.type.libelle}'),
              ),
          ],
          onChanged: (n) => setState(() {
            _navire = n!;
            _engin = _licence.enginsAutorises.first;
            _captures.clear();
          }),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TypeEngin>(
          isExpanded: true,
          value: _engin,
          decoration: const InputDecoration(labelText: 'Engin utilisé'),
          items: [
            for (final e in TypeEngin.values)
              DropdownMenuItem(value: e, child: Text(e.libelle)),
          ],
          onChanged: (e) => setState(() => _engin = e!),
        ),
        const SizedBox(height: 12),
        _ligne('Immatriculation', _navire.immatriculation),
        _ligne('Pavillon', _navire.pavillon),
        if (_navire.numeroImo != null) _ligne('N° IMO', _navire.numeroImo!),
        _ligne('Licence', '${_licence.numero} (${_licence.segment.libelle})'),
        _ligne('Position GPS', _position.toString()),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final c in _navire.certificats)
              Chip(
                avatar: Icon(
                  c.estValideLe(aujourdHui) ? Icons.check_circle : Icons.error,
                  color: c.estValideLe(aujourdHui) ? Colors.green : Colors.red,
                  size: 18,
                ),
                label: Text(c.type.libelle),
              ),
          ],
        ),
      ],
    );
  }

  // ---------------- Étape 2 ----------------
  Widget _etapeEquipage() {
    return Column(
      children: [
        for (final (i, m) in _equipage.indexed)
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(m.nom),
            subtitle: Text('${m.fonction} · ${m.nationalite}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => setState(() => _equipage.removeAt(i)),
            ),
          ),
        OutlinedButton.icon(
          icon: const Icon(Icons.person_add),
          label: const Text('Ajouter un membre'),
          onPressed: _ajouterMembre,
        ),
      ],
    );
  }

  Future<void> _ajouterMembre() async {
    final nom = TextEditingController();
    final fonction = TextEditingController(text: 'Matelot');
    final nationalite = TextEditingController(text: 'MRT');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Membre d\'équipage'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: nom,
              decoration: const InputDecoration(labelText: 'Nom complet')),
          TextField(
              controller: fonction,
              decoration: const InputDecoration(labelText: 'Fonction')),
          TextField(
              controller: nationalite,
              decoration: const InputDecoration(labelText: 'Nationalité')),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Ajouter')),
        ],
      ),
    );
    if (ok == true && nom.text.trim().isNotEmpty) {
      setState(() => _equipage.add(MembreEquipage(
            nom: nom.text.trim(),
            fonction: fonction.text.trim(),
            nationalite: nationalite.text.trim(),
          )));
    }
  }

  // ---------------- Étape 3 ----------------
  Widget _etapeCaptures() {
    return Column(
      children: [
        for (final (i, c) in _captures.indexed)
          ListTile(
            leading: Icon(
              _licence.especesCibles.contains(c.especeCode)
                  ? Icons.set_meal
                  : Icons.report_gmailerrorred,
            ),
            title: Text(
                '${referentielDemo.espece(c.especeCode)?.nomCommun ?? c.especeCode}'
                ' — ${c.poidsKg.toStringAsFixed(0)} kg'),
            subtitle: Text(_licence.especesCibles.contains(c.especeCode)
                ? 'Espèce cible'
                : 'Prise accessoire'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => setState(() => _captures.removeAt(i)),
            ),
          ),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Ajouter une capture'),
          onPressed: _ajouterCapture,
        ),
      ],
    );
  }

  Future<void> _ajouterCapture() async {
    var espece = _licence.especesCibles.first;
    final poids = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Capture'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: espece,
            decoration: const InputDecoration(labelText: 'Espèce'),
            items: [
              for (final r in referentielDemo.especes.values)
                DropdownMenuItem(
                    value: r.code, child: Text('${r.nomCommun} (${r.code})')),
            ],
            onChanged: (v) => espece = v!,
          ),
          TextField(
            controller: poids,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Poids (kg)'),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Ajouter')),
        ],
      ),
    );
    final kg = double.tryParse(poids.text.replaceAll(',', '.'));
    if (ok == true && kg != null && kg > 0) {
      setState(() => _captures.add(Capture(especeCode: espece, poidsKg: kg)));
    }
  }

  // ---------------- Étape 4 ----------------
  Widget _etapeVerification() {
    final d = _declaration;
    final resultat = _calcul.verifierDeclaration(d);
    final pctAcc =
        _calcul.pourcentagePrisesAccessoires(d.licence, d.captures);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ligne('Poids total', '${d.poidsTotalKg.toStringAsFixed(0)} kg'),
        _ligne('Prises accessoires', '${pctAcc.toStringAsFixed(1)} %'),
        for (final MapEntry(key: code, value: quota)
            in d.licence.quotasKg.entries)
          _ligne(
            'Quota $code',
            '${(CalculReglementaire.cumulParEspece(d.captures)[code] ?? 0).toStringAsFixed(0)}'
                ' / ${quota.toStringAsFixed(0)} kg',
          ),
        const SizedBox(height: 8),
        ResultatCard(resultat: resultat),
      ],
    );
  }

  void _envoyer() {
    // En production : enregistrement dans la file d'attente locale (Drift),
    // signature, puis synchronisation automatique dès qu'il y a du réseau.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Déclaration enregistrée — envoi à la prochaine '
          'connexion réseau.'),
    ));
    Navigator.of(context).pop();
  }

  Widget _ligne(String label, String valeur) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          SizedBox(
              width: 140,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(valeur)),
        ]),
      );
}
