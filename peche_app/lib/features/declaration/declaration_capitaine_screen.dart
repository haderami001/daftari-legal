import 'package:flutter/material.dart';

import '../../core/services/services.dart';
import '../../core/data/depots/flotte_depot.dart';
import '../../core/format.dart';
import '../../core/models/declaration.dart';
import '../../core/models/enums.dart';
import '../../core/models/navire.dart';
import '../../core/regulation/calcul_reglementaire.dart';
import '../../core/regulation/referentiel.dart';
import '../../core/widgets/resultat_card.dart';
import '../../l10n/libelles.dart';

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

  late Services _services;

  /// `null` tant que la flotte n'est pas chargée depuis la base locale.
  List<NavireLicence>? _flotte;
  late NavireLicence _choix;
  late TypeEngin _engin;
  bool _enregistrementEnCours = false;

  int _etape = 0;
  final _equipage = <MembreEquipage>[];
  final _captures = <Capture>[];

  /// La mesure GPS peut prendre plusieurs secondes : l'écran s'affiche tout
  /// de suite et la position est mise à jour dès qu'elle arrive.
  PositionGps? _position;
  bool _chargementLance = false;

  /// Position utilisée tant que le GPS n'a pas répondu.
  PositionGps get _positionAffichee =>
      _position ??
      PositionGps(20.85, -17.45, DateTime.now(), demonstration: true);

  /// Une seule mesure GPS par écran, même si plusieurs parties l'attendent.
  Future<PositionGps>? _mesureGps;
  Future<PositionGps> _attendrePosition() => _mesureGps ??=
      _services.position.positionActuelle()..then((p) => _position = p);

  Navire get _navire => _choix.navire;
  Licence get _licence => _choix.licence;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // `context` n'est pas utilisable dans initState pour lire un
    // InheritedWidget : on le fait ici, une seule fois.
    if (!_chargementLance) {
      _chargementLance = true;
      _services = ServicesScope.of(context);
      _chargerFlotte();
      _attendrePosition().then((_) {
        if (mounted) setState(() {});
      });
    }
  }

  Future<void> _chargerFlotte() async {
    final flotte = await _services.flotte.naviresAvecLicence();
    if (!mounted) return;
    setState(() {
      _flotte = flotte;
      if (flotte.isNotEmpty) _choisir(flotte.first);
    });
  }

  void _choisir(NavireLicence choix) {
    _choix = choix;
    _engin = choix.licence.enginsAutorises.first;
    _captures.clear();
  }

  DeclarationCapitaine get _declaration => DeclarationCapitaine(
        navire: _navire,
        licence: _licence,
        engin: _engin,
        position: _positionAffichee,
        equipage: _equipage,
        captures: _captures,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final flotte = _flotte;
    if (flotte == null || flotte.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.moduleDeclaration)),
        body: Center(
          child: flotte == null
              ? const CircularProgressIndicator()
              : Text(l10n.aucunNavire),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moduleDeclaration)),
      body: Stepper(
        currentStep: _etape,
        onStepTapped: (i) => setState(() => _etape = i),
        onStepContinue: _etape < 3 ? () => setState(() => _etape++) : _envoyer,
        onStepCancel: _etape > 0 ? () => setState(() => _etape--) : null,
        controlsBuilder: (context, details) => Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            FilledButton(
              onPressed: _enregistrementEnCours ? null : details.onStepContinue,
              child: Text(_etape < 3 ? l10n.suivant : l10n.signerEtEnvoyer),
            ),
            if (_etape > 0)
              TextButton(
                  onPressed: details.onStepCancel, child: Text(l10n.retour)),
          ]),
        ),
        steps: [
          Step(
            title: Text(l10n.etapeNavire),
            isActive: _etape >= 0,
            content: _etapeNavire(),
          ),
          Step(
            title: Text(l10n.etapeEquipage(_equipage.length)),
            isActive: _etape >= 1,
            content: _etapeEquipage(),
          ),
          Step(
            title: Text(l10n.etapeCaptures(_captures.length)),
            isActive: _etape >= 2,
            content: _etapeCaptures(),
          ),
          Step(
            title: Text(l10n.etapeVerification),
            isActive: _etape >= 3,
            content: _etapeVerification(),
          ),
        ],
      ),
    );
  }

  // ---------------- Étape 1 ----------------
  Widget _etapeNavire() {
    final l10n = context.l10n;
    final aujourdHui = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: _navire.id,
          decoration: InputDecoration(labelText: l10n.navire),
          items: [
            for (final (:navire, licence: _) in _flotte!)
              DropdownMenuItem(
                value: navire.id,
                child: Text(
                    '${navire.nom} — ${l10n.libelleTypeNavire(navire.type)}'),
              ),
          ],
          onChanged: (id) => setState(
              () => _choisir(_flotte!.firstWhere((c) => c.navire.id == id))),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TypeEngin>(
          isExpanded: true,
          value: _engin,
          decoration: InputDecoration(labelText: l10n.enginUtilise),
          items: [
            for (final e in TypeEngin.values)
              DropdownMenuItem(value: e, child: Text(l10n.libelleEngin(e))),
          ],
          onChanged: (e) => setState(() => _engin = e!),
        ),
        const SizedBox(height: 12),
        _ligne(l10n.immatriculation, _navire.immatriculation),
        _ligne(l10n.pavillon, _navire.pavillon),
        if (_navire.numeroImo != null)
          _ligne(l10n.numeroImo, _navire.numeroImo!),
        _ligne(l10n.licence,
            '${_licence.numero} (${l10n.libelleSegment(_licence.segment)})'),
        _ligne(
          l10n.positionGps,
          _position == null
              ? l10n.gpsRecherche
              : '${isolerGaucheDroite('$_position')}'
                  '${_position!.demonstration ? ' ${l10n.gpsNonMesuree}' : ''}',
        ),
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
                label: Text(l10n.libelleCertificat(c.type)),
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
          label: Text(context.l10n.ajouterMembre),
          onPressed: _ajouterMembre,
        ),
      ],
    );
  }

  Future<void> _ajouterMembre() async {
    final l10n = context.l10n;
    final nom = TextEditingController();
    final fonction = TextEditingController(text: l10n.fonctionParDefaut);
    final nationalite = TextEditingController(text: 'MRT');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.membreEquipage),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: nom,
              decoration: InputDecoration(labelText: l10n.nomComplet)),
          TextField(
              controller: fonction,
              decoration: InputDecoration(labelText: l10n.fonction)),
          TextField(
              controller: nationalite,
              decoration: InputDecoration(labelText: l10n.nationalite)),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.annuler)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.ajouter)),
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
    final l10n = context.l10n;
    return Column(
      children: [
        for (final (i, c) in _captures.indexed)
          ListTile(
            leading: Icon(
              _licence.especesCibles.contains(c.especeCode)
                  ? Icons.set_meal
                  : Icons.report_gmailerrorred,
            ),
            title: Text('${l10n.nomEspece(c.especeCode)}'
                ' — ${formaterMontant(c.poidsKg)} ${l10n.uniteKg}'),
            subtitle: Text(_licence.especesCibles.contains(c.especeCode)
                ? l10n.especeCible
                : l10n.priseAccessoire),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => setState(() => _captures.removeAt(i)),
            ),
          ),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: Text(l10n.ajouterCapture),
          onPressed: _ajouterCapture,
        ),
      ],
    );
  }

  Future<void> _ajouterCapture() async {
    final l10n = context.l10n;
    var espece = _licence.especesCibles.first;
    final poids = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.capture),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: espece,
            decoration: InputDecoration(labelText: l10n.espece),
            items: [
              for (final r in referentielDemo.especes.values)
                DropdownMenuItem(
                    value: r.code,
                    child: Text('${l10n.nomEspece(r.code)} (${r.code})')),
            ],
            onChanged: (v) => espece = v!,
          ),
          TextField(
            controller: poids,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.poidsKg),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.annuler)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.ajouter)),
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
    final l10n = context.l10n;
    final d = _declaration;
    final resultat = _calcul.verifierDeclaration(d);
    final pctAcc = _calcul.pourcentagePrisesAccessoires(d.licence, d.captures);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ligne(l10n.poidsTotal,
            '${formaterMontant(d.poidsTotalKg)} ${l10n.uniteKg}'),
        _ligne(l10n.prisesAccessoires, '${pctAcc.toStringAsFixed(1)} %'),
        for (final MapEntry(key: code, value: quota)
            in d.licence.quotasKg.entries)
          _ligne(
            l10n.quota(l10n.nomEspece(code)),
            '${formaterMontant(CalculReglementaire.cumulParEspece(d.captures)[code] ?? 0)}'
            ' / ${formaterMontant(quota)} ${l10n.uniteKg}',
          ),
        const SizedBox(height: 8),
        ResultatCard(resultat: resultat),
      ],
    );
  }

  /// Enregistre la déclaration dans la base locale et la place dans la
  /// file d'envoi : elle partira vers le serveur au retour du réseau.
  Future<void> _envoyer() async {
    setState(() => _enregistrementEnCours = true);
    await _attendrePosition();
    final d = _declaration;
    final String id;
    try {
      id = await _services.saisies
          .enregistrerDeclaration(d, _calcul.verifierDeclaration(d));
    } catch (e) {
      // Rien n'a été écrit (transaction annulée) : on peut réessayer.
      if (!mounted) return;
      setState(() => _enregistrementEnCours = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.echecEnregistrement('$e'))));
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(context.l10n.declarationEnregistree(id.substring(0, 8))),
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
