import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/services/services.dart';
import '../../core/data/depots/flotte_depot.dart';
import '../../core/format.dart';
import '../../core/models/declaration.dart';
import '../../core/models/enums.dart';
import '../../core/models/navire.dart';
import '../../core/models/ports.dart';
import '../../core/regulation/calcul_reglementaire.dart';
import '../../core/regulation/rapport.dart';
import '../../core/regulation/rapport_pdf.dart';
import '../../core/regulation/referentiel.dart';
import '../../core/widgets/resultat_card.dart';
import '../../l10n/libelles.dart';
import 'rapport_pdf_screen.dart';
import 'scanner_licence_screen.dart';

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
  late Services _services;

  /// `null` tant que la flotte n'est pas chargée depuis la base locale.
  List<NavireLicence>? _flotte;
  late NavireLicence _choix;
  late Controle _controle;

  final _maillageCtrl = TextEditingController();
  final _echantillonCtrl = TextEditingController();
  String _especeEchantillon = referentielDemo.especes.keys.first;

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

  void _nouveauControle(NavireLicence choix) {
    _choix = choix;
    _controle = Controle(
      navire: choix.navire,
      // Nom de l'agent connecté (compte Keycloak).
      agent: _services.session.profil?.nomComplet ?? '?',
      date: DateTime.now(),
      position: _positionAffichee,
      engin: choix.licence.enginsAutorises.first,
    );
  }

  Licence get _licence => _choix.licence;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_chargementLance) {
      _chargementLance = true;
      _services = ServicesScope.of(context);
      _chargerFlotte();
      _attendrePosition().then((p) {
        if (!mounted) return;
        setState(() {
          if (_flotte?.isNotEmpty ?? false) _controle.position = p;
        });
      });
    }
  }

  Future<void> _chargerFlotte() async {
    final flotte = await _services.flotte.naviresAvecLicence();
    if (!mounted) return;
    setState(() {
      _flotte = flotte;
      if (flotte.isNotEmpty) _nouveauControle(flotte.first);
    });
  }

  @override
  void dispose() {
    _maillageCtrl.dispose();
    _echantillonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final flotte = _flotte;
    if (flotte == null || flotte.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.moduleControle)),
        body: Center(
          child: flotte == null
              ? const CircularProgressIndicator()
              : Text(l10n.aucunNavire),
        ),
      );
    }
    final c = _controle;
    final resultat = _calcul.verifierControle(c, licence: _licence);
    final regleEngin = referentielDemo.engin(c.engin);
    final regleEspece = referentielDemo.espece(_especeEchantillon)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.moduleControle),
        actions: [
          IconButton(
            tooltip: l10n.scannerQr,
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scannerLicence,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- 1. Identification du navire ----------
          _Section(
            titre: l10n.sectionNavire,
            icone: Icons.directions_boat,
            children: [
              DropdownButtonFormField<String>(
                isExpanded: true,
                key: ValueKey(c.navire.id),
                initialValue: c.navire.id,
                decoration: InputDecoration(labelText: l10n.navireInspecte),
                items: [
                  for (final (:navire, licence: _) in flotte)
                    DropdownMenuItem(
                        value: navire.id,
                        child:
                            Text('${navire.nom} (${navire.immatriculation})')),
                ],
                onChanged: (id) => setState(() => _nouveauControle(
                    flotte.firstWhere((x) => x.navire.id == id))),
              ),
              Text(l10n.detailsNavire(
                c.navire.pavillon,
                l10n.libelleTypeNavire(c.navire.type),
                formaterMontant(c.navire.longueurM),
                formaterMontant(c.navire.puissanceKw),
              )),
              Text(l10n.licenceNumero(_licence.numero)),
              Text(l10n.positionValeur(
                  '${_position == null ? l10n.gpsRecherche : isolerGaucheDroite('${c.position}')}'
                  '${_position?.demonstration ?? false ? ' ${l10n.gpsNonMesuree}' : ''}')),
              DropdownButtonFormField<String?>(
                isExpanded: true,
                key: ValueKey('lieu-${c.portDebarquement}'),
                initialValue: c.portDebarquement,
                decoration: InputDecoration(labelText: l10n.lieuControle),
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.enMer)),
                  for (final code in portsDebarquement.keys)
                    DropdownMenuItem(
                        value: code,
                        child: Text(l10n.aQuai(l10n.nomPort(code)))),
                ],
                onChanged: (p) => setState(() => c.portDebarquement = p),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.pavillonConcordant),
                value: c.pavillonConforme,
                onChanged: (v) => setState(() => c.pavillonConforme = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.marquageVisible),
                value: c.marquageConforme,
                onChanged: (v) => setState(() => c.marquageConforme = v),
              ),
            ],
          ),

          // ---------- 2. Certificats ----------
          _Section(
            titre: l10n.sectionCertificats,
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
                  title: Text(l10n.libelleCertificat(cert.type)),
                  subtitle: Text(l10n.certificatExpireLe(cert.numero,
                      cert.dateExpiration.toIso8601String().substring(0, 10))),
                ),
            ],
          ),

          // ---------- 3. Engin & maillage ----------
          _Section(
            titre: l10n.sectionEngin,
            icone: Icons.grid_on,
            children: [
              DropdownButtonFormField<TypeEngin>(
                isExpanded: true,
                key: ValueKey(c.engin),
                initialValue: c.engin,
                decoration: InputDecoration(labelText: l10n.enginABord),
                items: [
                  for (final e in TypeEngin.values)
                    DropdownMenuItem(
                        value: e, child: Text(l10n.libelleEngin(e))),
                ],
                onChanged: (e) => setState(() => c.engin = e!),
              ),
              if (regleEngin != null && regleEngin.maillageMinMm > 0) ...[
                Text(l10n.maillageMinimum(
                    formaterMontant(regleEngin.maillageMinMm),
                    formaterMontant(referentielDemo.toleranceMaillagePct))),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _maillageCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.mesureMaille),
                      onSubmitted: (_) => _ajouterMaillage(),
                    ),
                  ),
                  IconButton.filled(
                      onPressed: _ajouterMaillage, icon: const Icon(Icons.add)),
                ]),
                Wrap(spacing: 6, children: [
                  for (final (i, m) in c.maillagesMm.indexed)
                    InputChip(
                      label: Text('$m ${l10n.uniteMm}'),
                      onDeleted: () =>
                          setState(() => c.maillagesMm.removeAt(i)),
                    ),
                ]),
              ] else
                Text(l10n.pasDeMaillage),
            ],
          ),

          // ---------- 4. Échantillons ----------
          _Section(
            titre: l10n.sectionEchantillons,
            icone: Icons.straighten,
            children: [
              DropdownButtonFormField<String>(
                isExpanded: true,
                key: ValueKey(_especeEchantillon),
                initialValue: _especeEchantillon,
                decoration: InputDecoration(labelText: l10n.espece),
                items: [
                  for (final r in referentielDemo.especes.values)
                    DropdownMenuItem(
                      value: r.code,
                      child: Text(l10n.especeMinimum(l10n.nomEspece(r.code),
                          formaterMontant(r.minimum), l10n.unite(r.unite))),
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
                        labelText:
                            l10n.mesureUnite(l10n.unite(regleEspece.unite))),
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
                            ? Colors.red.withValues(alpha: 0.2)
                            : null,
                    label: Text('${e.especeCode} ${e.valeur}'),
                    onDeleted: () => setState(() => c.echantillons.removeAt(i)),
                  ),
              ]),
            ],
          ),

          // ---------- 5. Stockage ----------
          _Section(
            titre: l10n.sectionStockage,
            icone: Icons.inventory_2,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.calesConformes),
                value: c.planStockageConforme,
                onChanged: (v) => setState(() => c.planStockageConforme = v),
              ),
              TextField(
                decoration: InputDecoration(labelText: l10n.observations),
                maxLines: 2,
                onChanged: (v) => c.observations = v,
              ),
            ],
          ),

          // ---------- 6. Photos de preuve ----------
          _Section(
            titre: l10n.sectionPhotos,
            icone: Icons.photo_camera,
            children: [
              if (c.photos.isEmpty)
                Text(l10n.aucunePhoto)
              else
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final (i, photo) in c.photos.indexed)
                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(photo,
                            width: 96, height: 96, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton.filledTonal(
                          visualDensity: VisualDensity.compact,
                          tooltip: l10n.supprimerPhoto,
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () => setState(() => c.photos.removeAt(i)),
                        ),
                      ),
                    ]),
                ]),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.add_a_photo),
                label: Text(c.photos.length < Controle.maxPhotos
                    ? l10n.prendrePhoto
                    : l10n.photosMax(Controle.maxPhotos)),
                onPressed:
                    c.photos.length < Controle.maxPhotos ? _prendrePhoto : null,
              ),
            ],
          ),

          const SizedBox(height: 8),
          ResultatCard(resultat: resultat),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: Text(l10n.genererRapport),
            onPressed: () => _afficherRapport(resultat),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _prendrePhoto() async {
    final messager = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      final photo = await _services.photo.prendrePhoto();
      if (photo == null || !mounted) return;
      setState(() => _controle.photos.add(photo));
    } catch (e) {
      // Permission refusée, pas d'appareil photo…
      messager
          .showSnackBar(SnackBar(content: Text(l10n.photoIndisponible('$e'))));
    }
  }

  /// Le capitaine présente le QR code de sa licence : on sélectionne le
  /// navire et on affiche tout de suite si la licence est valide.
  Future<void> _scannerLicence() async {
    final numero = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => const ScannerLicenceScreen()));
    if (numero == null || !mounted) return;
    final l10n = context.l10n;
    final trouve = _flotte!
        .where((x) => x.licence.numero.toUpperCase() == numero.toUpperCase())
        .firstOrNull;
    final messager = ScaffoldMessenger.of(context);
    if (trouve == null) {
      messager
          .showSnackBar(SnackBar(content: Text(l10n.qrLicenceAbsente(numero))));
      return;
    }
    setState(() => _nouveauControle(trouve));
    final fin = MaterialLocalizations.of(context)
        .formatShortDate(trouve.licence.dateFin);
    final valide = trouve.licence.estValideLe(DateTime.now());
    messager.showSnackBar(SnackBar(
      backgroundColor: valide ? Colors.green.shade700 : Colors.red.shade700,
      content: Text(valide
          ? l10n.qrLicenceValide(trouve.licence.numero, fin)
          : l10n.qrLicenceExpiree(trouve.licence.numero, fin)),
    ));
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

  Future<void> _afficherRapport(ResultatVerification r) async {
    // Le rapport doit porter la position mesurée : on attend le GPS.
    _controle.position = await _attendrePosition();
    if (!mounted) return;
    final texte = genererRapportControle(_controle, r);
    final l10n = context.l10n;
    final signe = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.rapportGenere),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Le rapport officiel reste en français (comme le PDF) ; en
              // arabe, on le précise à l'agent.
              if (Localizations.localeOf(ctx).languageCode != 'fr') ...[
                Text(l10n.rapportLangue,
                    style: Theme.of(ctx).textTheme.bodySmall),
                const SizedBox(height: 8),
              ],
              // Texte français : toujours de gauche à droite.
              Directionality(
                textDirection: TextDirection.ltr,
                child: SelectableText(texte,
                    style:
                        const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.fermer)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.signer),
          ),
        ],
      ),
    );
    if (signe != true || !mounted) return;

    // Le rapport signé (texte + PDF) est figé dans la base locale, puis mis
    // en file d'envoi vers le serveur.
    final id = _services.saisies.nouvelIdentifiant();
    final Uint8List pdf;
    try {
      pdf = await genererRapportPdf(_controle, r,
          licence: _licence, identifiant: id.substring(0, 8));
      await _services.saisies.enregistrerControle(_controle, r, texte,
          identifiant: id, rapportPdf: pdf);
    } catch (e) {
      // Rien n'a été écrit (transaction annulée) : l'agent peut réessayer.
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.echecEnregistrement('$e'))));
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.rapportEnregistre(id.substring(0, 8)))));
    // On remplace la fiche de contrôle par l'aperçu du PDF signé.
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => RapportPdfScreen(
        pdf: pdf,
        nomFichier: 'rapport_${_controle.navire.immatriculation}_'
            '${id.substring(0, 8)}.pdf',
      ),
    ));
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
