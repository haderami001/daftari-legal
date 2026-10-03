import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peche_app/core/data/base/base_de_donnees.dart';
import 'package:peche_app/core/data/base/tables.dart';
import 'package:peche_app/core/models/declaration.dart';
import 'package:peche_app/core/models/enums.dart';
import 'package:peche_app/core/regulation/calcul_reglementaire.dart';
import 'package:peche_app/core/regulation/rapport.dart';
import 'package:peche_app/core/regulation/rapport_pdf.dart';
import 'package:peche_app/core/regulation/referentiel.dart';
import 'package:peche_app/core/services/services.dart';
import 'package:peche_app/core/services/synchronisation.dart';
import 'package:serveur_peche/serveur_peche.dart' as serveur;
import 'package:shelf/shelf_io.dart' as shelf_io;

/// Test de bout en bout : l'application (base locale + synchronisation HTTP)
/// envoie ses saisies au VRAI serveur du dépôt (`serveur/`), démarré ici sur
/// un port libre, avec de vraies requêtes réseau.
void main() {
  const jeton = 'jeton-bout-en-bout-123456';
  const calcul = CalculReglementaire(referentielDemo);

  late HttpServer http;
  late serveur.StockageMemoire stockageServeur;
  late BaseDeDonnees base;

  setUp(() async {
    stockageServeur = serveur.StockageMemoire();
    http = await shelf_io.serve(
      serveur.construireApi(stockage: stockageServeur, jeton: jeton),
      InternetAddress.loopbackIPv4,
      0,
    );
    base = BaseDeDonnees.avec(NativeDatabase.memory());
  });

  tearDown(() async {
    await base.close();
    await http.close(force: true);
  });

  Uri adresse() => Uri.parse('http://localhost:${http.port}');

  /// Une déclaration et un contrôle signé (avec son vrai PDF), enregistrés
  /// sur le « téléphone » comme le font les écrans.
  Future<(String, String)> saisir(Services s) async {
    final flotte = await s.flotte.naviresAvecLicence();
    final pirogue = flotte.firstWhere((f) => f.navire.id == 'N1');
    final d = DeclarationCapitaine(
      navire: pirogue.navire,
      licence: pirogue.licence,
      engin: TypeEngin.casier,
      position: PositionGps(20.85, -17.45, DateTime.utc(2026, 10, 3, 8)),
      equipage: [
        const MembreEquipage(
            nom: 'Ahmed Salem', fonction: 'Patron', nationalite: 'MRT'),
      ],
      captures: [
        const Capture(especeCode: 'OCC', poidsKg: 120),
        const Capture(especeCode: 'CTC', poidsKg: 4.5),
      ],
    );
    final idDecl = await s.saisies
        .enregistrerDeclaration(d, calcul.verifierDeclaration(d));

    final chalutier = flotte.first;
    final c = Controle(
      navire: chalutier.navire,
      agent: 'Agent GCM-0427',
      date: DateTime.utc(2026, 10, 3, 9, 30),
      position: PositionGps(20.62, -17.3, DateTime.utc(2026, 10, 3, 9, 30)),
      engin: TypeEngin.chalutDemersal,
      maillagesMm: [62, 64],
      echantillons: [const Echantillon(especeCode: 'SOL', valeur: 22)],
      observations: 'Cale arrière non déclarée.',
    );
    final r = calcul.verifierControle(c, licence: chalutier.licence);
    final pdf = await genererRapportPdf(c, r, licence: chalutier.licence);
    final idCtrl = await s.saisies.enregistrerControle(
        c, r, genererRapportControle(c, r),
        rapportPdf: pdf);
    return (idDecl, idCtrl);
  }

  test('les saisies du téléphone arrivent au serveur, sans doublon', () async {
    final s = Services(base, api: ApiHttp(adresse(), jeton: jeton));
    final (idDecl, idCtrl) = await saisir(s);

    final r1 = await s.synchro.synchroniser();
    expect((r1.envoyes, r1.echecs), (2, 0));
    expect(await s.envois.nombreEnAttente(), 0);
    expect(
        await stockageServeur.compter(), {'declarations': 1, 'controles': 1});

    // Ce qui est arrivé sur le serveur est bien ce qui a été saisi.
    final decl =
        (await stockageServeur.lister(serveur.TypeSaisie.declaration)).single;
    expect(decl.id, idDecl);
    expect(decl.navireId, 'N1');
    expect(await stockageServeur.rapportPdf(idCtrl),
        await s.saisies.rapportPdf(idCtrl));

    // Le téléphone renvoie (réponse perdue) : accepté, pas de doublon.
    await ApiHttp(adresse(), jeton: jeton).envoyer(TypeEnvoi.declaration,
        idDecl, await s.saisies.exporterDeclaration(idDecl));
    expect(
        await stockageServeur.compter(), {'declarations': 1, 'controles': 1});

    // Plus rien à envoyer.
    final r2 = await s.synchro.synchroniser();
    expect((r2.envoyes, r2.echecs), (0, 0));
  });

  test('mauvais jeton : refus, les saisies restent sur le téléphone', () async {
    final s = Services(base,
        api: ApiHttp(adresse(), jeton: 'mauvais-jeton-000000000'));
    await saisir(s);

    final r = await s.synchro.synchroniser();
    expect((r.envoyes, r.echecs), (0, 2));
    final enAttente = await s.envois.enAttente();
    expect(enAttente.map((e) => e.derniereErreur),
        everyElement('Serveur : HTTP 401'));
    expect(
        await stockageServeur.compter(), {'declarations': 0, 'controles': 0});
  });

  test('serveur éteint : les saisies restent en file, puis repartent',
      () async {
    final adresseEteinte = adresse();
    await http.close(force: true);
    final s = Services(base, api: ApiHttp(adresseEteinte, jeton: jeton));
    await saisir(s);

    final r1 = await s.synchro.synchroniser();
    expect((r1.envoyes, r1.echecs), (0, 2));
    expect((await s.envois.enAttente()).first.derniereErreur,
        startsWith('Réseau indisponible'));

    // Le serveur revient (nouveau port) : tout part.
    http = await shelf_io.serve(
      serveur.construireApi(stockage: stockageServeur, jeton: jeton),
      InternetAddress.loopbackIPv4,
      0,
    );
    final s2 = Services(base, api: ApiHttp(adresse(), jeton: jeton));
    final r2 = await s2.synchro.synchroniser();
    expect((r2.envoyes, r2.echecs), (2, 0));
  });
}
