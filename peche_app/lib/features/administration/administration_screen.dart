import 'package:flutter/material.dart';

import '../../core/models/enums.dart';
import '../../core/services/administration.dart';
import '../../core/services/services.dart';
import '../../l10n/libelles.dart';

/// Administration du référentiel central : navires et licences.
///
/// Réservé au rôle `admin` (le serveur le vérifie aussi). Les données sont
/// lues et écrites directement sur le serveur ; après chaque
/// enregistrement, la synchronisation met à jour la copie du téléphone.
class AdministrationScreen extends StatefulWidget {
  const AdministrationScreen({super.key});

  @override
  State<AdministrationScreen> createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
  Future<Map<String, Object?>>? _referentiel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _referentiel ??= _charger();
  }

  Future<Map<String, Object?>> _charger() =>
      ServicesScope.of(context).administration!.referentiel();

  void _actualiser() => setState(() {
        _referentiel = _charger();
      });

  Future<void> _ouvrir(Widget formulaire) async {
    final services = ServicesScope.of(context);
    final enregistre = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => formulaire));
    if (enregistre != true || !mounted) return;
    _actualiser();
    // Copie locale du référentiel (pour les écrans hors ligne).
    services.synchro.synchroniser();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.moduleAdministration),
          actions: [
            IconButton(
              tooltip: l10n.actualiser,
              onPressed: _actualiser,
              icon: const Icon(Icons.refresh),
            ),
          ],
          bottom: TabBar(tabs: [
            Tab(
                icon: const Icon(Icons.directions_boat),
                text: l10n.ongletNavires),
            Tab(icon: const Icon(Icons.badge), text: l10n.ongletLicences),
          ]),
        ),
        body: FutureBuilder(
          future: _referentiel,
          builder: (context, etat) {
            if (etat.hasError) {
              return _Message(
                  icone: Icons.cloud_off,
                  texte: l10n.adminChargement('${etat.error}'));
            }
            if (!etat.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final navires =
                (etat.data!['navires']! as List).cast<Map<String, Object?>>();
            final licences =
                (etat.data!['licences']! as List).cast<Map<String, Object?>>();
            return TabBarView(children: [
              _Liste(
                elements: navires,
                ajouter: l10n.ajouterNavire,
                onAjouter: () => _ouvrir(const NavireFormScreen()),
                ligne: (n) => ListTile(
                  leading: const Icon(Icons.directions_boat),
                  title: Text('${n['nom']}'),
                  subtitle: Text('${n['id']} · ${n['immatriculation']} · '
                      '${l10n.libelleTypeNavire(TypeNavire.values.byName('${n['type']}'))}'
                      ' · ${n['pavillon']}'),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _ouvrir(NavireFormScreen(navire: n)),
                ),
              ),
              _Liste(
                elements: licences,
                ajouter: l10n.ajouterLicence,
                onAjouter: () => _ouvrir(LicenceFormScreen(navires: navires)),
                ligne: (l) => ListTile(
                  leading: const Icon(Icons.badge),
                  title: Text(l10n.licenceDe('${l['numero']}',
                      '${navires.where((n) => n['id'] == l['navire_id']).firstOrNull?['nom'] ?? l['navire_id']}')),
                  subtitle: Text(
                      '${l10n.libelleSegment(TypePeche.values.byName('${l['segment']}'))}'
                      ' · ${l['date_debut']} → ${l['date_fin']}'),
                  trailing: const Icon(Icons.edit),
                  onTap: () =>
                      _ouvrir(LicenceFormScreen(licence: l, navires: navires)),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}

class _Liste extends StatelessWidget {
  const _Liste({
    required this.elements,
    required this.ajouter,
    required this.onAjouter,
    required this.ligne,
  });

  final List<Map<String, Object?>> elements;
  final String ajouter;
  final VoidCallback onAjouter;
  final Widget Function(Map<String, Object?>) ligne;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(12),
        children: [
          FilledButton.icon(
            onPressed: onAjouter,
            icon: const Icon(Icons.add),
            label: Text(ajouter),
          ),
          const SizedBox(height: 8),
          if (elements.isEmpty)
            _Message(icone: Icons.inbox, texte: context.l10n.aucunElement),
          for (final e in elements) Card(child: ligne(e)),
        ],
      );
}

class _Message extends StatelessWidget {
  const _Message({required this.icone, required this.texte});
  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icone, size: 48),
          const SizedBox(height: 12),
          Text(texte, textAlign: TextAlign.center),
        ]),
      );
}

// ---------------------------------------------------------------------------
// Formulaires
// ---------------------------------------------------------------------------

/// « 2027-03-31 » (format attendu par le serveur).
String jourIso(DateTime d) => d.toIso8601String().substring(0, 10);

/// Comportement commun aux deux formulaires : enregistrement sur le serveur
/// et affichage de ses refus (avec le détail champ par champ).
mixin _Enregistrement<T extends StatefulWidget> on State<T> {
  final formulaire = GlobalKey<FormState>();
  bool enCours = false;
  ErreurAdministration? refus;

  Future<void> enregistrer(
      Future<Ecriture> Function(ApiAdministration api) ecrire,
      String confirmation) async {
    if (!formulaire.currentState!.validate()) return;
    final api = ServicesScope.of(context).administration!;
    setState(() {
      enCours = true;
      refus = null;
    });
    try {
      await ecrire(api);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(confirmation)));
      Navigator.of(context).pop(true);
    } on ErreurAdministration catch (e) {
      if (mounted) setState(() => refus = e);
    } finally {
      if (mounted) setState(() => enCours = false);
    }
  }

  Widget refusAffiche() {
    final r = refus;
    if (r == null) return const SizedBox.shrink();
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text(context.l10n.adminRefus(r.message)),
        subtitle: r.details.isEmpty ? null : Text(r.details.join('\n')),
      ),
    );
  }

  Widget boutonEnregistrer(VoidCallback onPressed) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: FilledButton.icon(
          onPressed: enCours ? null : onPressed,
          icon: enCours
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.save),
          label: Text(context.l10n.enregistrer),
        ),
      );

  String? obligatoire(String? v) =>
      (v ?? '').trim().isEmpty ? context.l10n.champObligatoire : null;

  String? nombre(String? v) {
    final x = double.tryParse((v ?? '').replaceAll(',', '.'));
    return x != null && x > 0 ? null : context.l10n.nombreInvalide;
  }

  double lireNombre(TextEditingController c) =>
      double.parse(c.text.replaceAll(',', '.'));

  Future<DateTime?> choisirDate(DateTime? actuelle) => showDatePicker(
        context: context,
        initialDate: actuelle ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

  Widget champDate(String libelle, DateTime? valeur, ValueChanged<DateTime> ok,
          {Key? key}) =>
      FormField<DateTime>(
        key: key,
        initialValue: valeur,
        validator: (_) => valeur == null ? context.l10n.champObligatoire : null,
        builder: (etat) => InputDecorator(
          decoration:
              InputDecoration(labelText: libelle, errorText: etat.errorText),
          child: InkWell(
            onTap: () async {
              final d = await choisirDate(valeur);
              if (d != null) {
                ok(d);
                etat.didChange(d);
              }
            },
            child: Row(children: [
              Expanded(
                  child: Text(valeur == null
                      ? context.l10n.choisirDate
                      : jourIso(valeur))),
              const Icon(Icons.calendar_month),
            ]),
          ),
        ),
      );
}

class _Certificat {
  _Certificat(this.type, String numero, this.expiration)
      : numero = TextEditingController(text: numero);
  TypeCertificat type;
  final TextEditingController numero;
  DateTime? expiration;
}

/// Création ou modification d'un navire et de ses certificats.
class NavireFormScreen extends StatefulWidget {
  const NavireFormScreen({super.key, this.navire});

  /// `null` = nouveau navire.
  final Map<String, Object?>? navire;

  @override
  State<NavireFormScreen> createState() => _NavireFormScreenState();
}

class _NavireFormScreenState extends State<NavireFormScreen>
    with _Enregistrement {
  late final Map<String, Object?> n = widget.navire ?? const {};
  late final id = TextEditingController(text: '${n['id'] ?? ''}');
  late final nom = TextEditingController(text: '${n['nom'] ?? ''}');
  late final immat =
      TextEditingController(text: '${n['immatriculation'] ?? ''}');
  late final pavillon =
      TextEditingController(text: '${n['pavillon'] ?? 'MRT'}');
  late final longueur = TextEditingController(text: '${n['longueur_m'] ?? ''}');
  late final puissance =
      TextEditingController(text: '${n['puissance_kw'] ?? ''}');
  late final imo = TextEditingController(text: '${n['numero_imo'] ?? ''}');
  late TypeNavire type = n['type'] == null
      ? TypeNavire.pirogue
      : TypeNavire.values.byName('${n['type']}');
  late final certificats = [
    for (final c in (n['certificats'] as List? ?? const []).cast<Map>())
      _Certificat(TypeCertificat.values.byName('${c['type']}'),
          '${c['numero']}', DateTime.parse('${c['date_expiration']}')),
  ];

  bool get _nouveau => widget.navire == null;

  Map<String, Object?> _donnees() => {
        'nom': nom.text.trim(),
        'immatriculation': immat.text.trim(),
        'pavillon': pavillon.text.trim().toUpperCase(),
        'type': type.name,
        'longueur_m': lireNombre(longueur),
        'puissance_kw': lireNombre(puissance),
        'numero_imo': imo.text.trim().isEmpty ? null : imo.text.trim(),
        'certificats': [
          for (final c in certificats)
            {
              'type': c.type.name,
              'numero': c.numero.text.trim(),
              'date_expiration': jourIso(c.expiration!),
            },
        ],
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
          title: Text(_nouveau ? l10n.ajouterNavire : l10n.modifierNavire)),
      body: Form(
        key: formulaire,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            refusAffiche(),
            TextFormField(
              controller: id,
              enabled: _nouveau, // l'identifiant ne change plus ensuite
              decoration: InputDecoration(labelText: l10n.champIdentifiant),
              validator: obligatoire,
            ),
            TextFormField(
              controller: nom,
              decoration: InputDecoration(labelText: l10n.champNom),
              validator: obligatoire,
            ),
            TextFormField(
              controller: immat,
              decoration: InputDecoration(labelText: l10n.champImmatriculation),
              validator: obligatoire,
            ),
            TextFormField(
              controller: pavillon,
              decoration: InputDecoration(labelText: l10n.champPavillon),
              textCapitalization: TextCapitalization.characters,
              validator: obligatoire,
            ),
            DropdownButtonFormField<TypeNavire>(
              value: type,
              decoration: InputDecoration(labelText: l10n.champTypeNavire),
              items: [
                for (final t in TypeNavire.values)
                  DropdownMenuItem(
                      value: t, child: Text(l10n.libelleTypeNavire(t))),
              ],
              onChanged: (t) => setState(() => type = t!),
            ),
            TextFormField(
              controller: longueur,
              decoration: InputDecoration(labelText: l10n.champLongueur),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: nombre,
            ),
            TextFormField(
              controller: puissance,
              decoration: InputDecoration(labelText: l10n.champPuissance),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: nombre,
            ),
            TextFormField(
              controller: imo,
              decoration: InputDecoration(labelText: l10n.champImo),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Text(l10n.certificats,
                style: Theme.of(context).textTheme.titleMedium),
            for (final (i, c) in certificats.indexed)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                        child: DropdownButtonFormField<TypeCertificat>(
                          value: c.type,
                          items: [
                            for (final t in TypeCertificat.values)
                              DropdownMenuItem(
                                  value: t,
                                  child: Text(l10n.libelleCertificat(t),
                                      overflow: TextOverflow.ellipsis)),
                          ],
                          onChanged: (t) => setState(() => c.type = t!),
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.supprimer,
                        onPressed: () =>
                            setState(() => certificats.removeAt(i)),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ]),
                    TextFormField(
                      controller: c.numero,
                      decoration: InputDecoration(labelText: l10n.champNumero),
                      validator: obligatoire,
                    ),
                    champDate(l10n.champExpiration, c.expiration,
                        (d) => setState(() => c.expiration = d),
                        key: ObjectKey(c)),
                  ]),
                ),
              ),
            TextButton.icon(
              onPressed: () => setState(() => certificats
                  .add(_Certificat(TypeCertificat.navigabilite, '', null))),
              icon: const Icon(Icons.add),
              label: Text(l10n.ajouterCertificat),
            ),
            boutonEnregistrer(() => enregistrer(
                (api) => api.enregistrerNavire(id.text.trim(), _donnees()),
                l10n.navireEnregistre)),
          ],
        ),
      ),
    );
  }
}

class _Quota {
  _Quota(String code, String kg)
      : code = TextEditingController(text: code),
        kg = TextEditingController(text: kg);
  final TextEditingController code;
  final TextEditingController kg;
}

/// Création ou modification d'une licence et de ses quotas.
class LicenceFormScreen extends StatefulWidget {
  const LicenceFormScreen({super.key, this.licence, required this.navires});

  /// `null` = nouvelle licence.
  final Map<String, Object?>? licence;
  final List<Map<String, Object?>> navires;

  @override
  State<LicenceFormScreen> createState() => _LicenceFormScreenState();
}

class _LicenceFormScreenState extends State<LicenceFormScreen>
    with _Enregistrement {
  late final Map<String, Object?> l = widget.licence ?? const {};
  late final numero = TextEditingController(text: '${l['numero'] ?? ''}');
  late String? navireId = l['navire_id'] as String?;
  late TypePeche segment = l['segment'] == null
      ? TypePeche.artisanale
      : TypePeche.values.byName('${l['segment']}');
  late final engins = {
    for (final e in (l['engins_autorises'] as List? ?? const []))
      TypeEngin.values.byName('$e'),
  };
  late final especes = TextEditingController(
      text: (l['especes_cibles'] as List? ?? const []).join(', '));
  late DateTime? debut =
      l['date_debut'] == null ? null : DateTime.parse('${l['date_debut']}');
  late DateTime? fin =
      l['date_fin'] == null ? null : DateTime.parse('${l['date_fin']}');
  late final quotas = [
    for (final MapEntry(:key, :value)
        in (l['quotas_kg'] as Map? ?? const {}).entries)
      _Quota('$key', (value as num).toStringAsFixed(0)),
  ];

  bool get _nouvelle => widget.licence == null;

  Map<String, Object?> _donnees() => {
        'navire_id': navireId,
        'segment': segment.name,
        'engins_autorises': [
          for (final e in TypeEngin.values)
            if (engins.contains(e)) e.name,
        ],
        'especes_cibles': [
          for (final c in especes.text.split(RegExp(r'[,\s]+')))
            if (c.trim().isNotEmpty) c.trim().toUpperCase(),
        ],
        'date_debut': jourIso(debut!),
        'date_fin': jourIso(fin!),
        'quotas_kg': {
          for (final q in quotas)
            q.code.text.trim().toUpperCase(): lireNombre(q.kg),
        },
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
          title: Text(_nouvelle ? l10n.ajouterLicence : l10n.modifierLicence)),
      body: Form(
        key: formulaire,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            refusAffiche(),
            TextFormField(
              controller: numero,
              enabled: _nouvelle,
              decoration: InputDecoration(labelText: l10n.champNumeroLicence),
              validator: obligatoire,
            ),
            DropdownButtonFormField<String>(
              value: navireId,
              decoration: InputDecoration(labelText: l10n.champNavire),
              items: [
                for (final n in widget.navires)
                  DropdownMenuItem(
                      value: n['id']! as String,
                      child: Text('${n['nom']} (${n['id']})')),
              ],
              validator: (v) => v == null ? l10n.champObligatoire : null,
              onChanged: (v) => setState(() => navireId = v),
            ),
            DropdownButtonFormField<TypePeche>(
              value: segment,
              decoration: InputDecoration(labelText: l10n.champSegment),
              items: [
                for (final s in TypePeche.values)
                  DropdownMenuItem(
                      value: s, child: Text(l10n.libelleSegment(s))),
              ],
              onChanged: (s) => setState(() => segment = s!),
            ),
            const SizedBox(height: 12),
            FormField<void>(
              validator: (_) => engins.isEmpty ? l10n.champObligatoire : null,
              builder: (etat) => InputDecorator(
                decoration: InputDecoration(
                    labelText: l10n.enginsAutorises, errorText: etat.errorText),
                child: Wrap(spacing: 6, runSpacing: 6, children: [
                  for (final e in TypeEngin.values)
                    FilterChip(
                      label: Text(l10n.libelleEngin(e)),
                      selected: engins.contains(e),
                      onSelected: (oui) => setState(
                          () => oui ? engins.add(e) : engins.remove(e)),
                    ),
                ]),
              ),
            ),
            TextFormField(
              controller: especes,
              decoration: InputDecoration(labelText: l10n.champEspeces),
              textCapitalization: TextCapitalization.characters,
            ),
            champDate(l10n.champDebut, debut, (d) => setState(() => debut = d)),
            champDate(l10n.champFin, fin, (d) => setState(() => fin = d)),
            const SizedBox(height: 16),
            Text(l10n.quotas, style: Theme.of(context).textTheme.titleMedium),
            for (final (i, q) in quotas.indexed)
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: q.code,
                    decoration: InputDecoration(labelText: l10n.champEspece),
                    textCapitalization: TextCapitalization.characters,
                    validator: obligatoire,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: q.kg,
                    decoration: InputDecoration(labelText: l10n.champKg),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: nombre,
                  ),
                ),
                IconButton(
                  tooltip: l10n.supprimer,
                  onPressed: () => setState(() => quotas.removeAt(i)),
                  icon: const Icon(Icons.delete_outline),
                ),
              ]),
            TextButton.icon(
              onPressed: () => setState(() => quotas.add(_Quota('', ''))),
              icon: const Icon(Icons.add),
              label: Text(l10n.ajouterQuota),
            ),
            boutonEnregistrer(() => enregistrer(
                (api) => api.enregistrerLicence(numero.text.trim(), _donnees()),
                l10n.licenceEnregistree)),
          ],
        ),
      ),
    );
  }
}
