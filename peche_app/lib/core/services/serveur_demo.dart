import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serveur_peche/serveur_memoire.dart' as serveur;
import 'package:shelf/shelf.dart' as shelf;

import '../data/donnees_demo.dart';

/// Adresse fictive du serveur de démonstration.
final adresseServeurDemo = Uri.parse('https://serveur-demo.local');

/// Jeton partagé du serveur de démonstration.
const jetonServeurDemo = 'jeton-demonstration-local';

/// Mode démonstration complet (`--dart-define=SERVEUR_DEMO=true`) : le VRAI
/// serveur du dépôt (`serveur/`) tourne dans l'application, en mémoire,
/// avec la flotte de démonstration. Les requêtes HTTP de l'application lui
/// sont remises directement, sans réseau : synchronisation, tableau de bord
/// et administration fonctionnent, par exemple dans la simulation web.
http.Client clientServeurDemo() {
  final stockage = serveur.StockageMemoire();
  final api = serveur.construireApi(
      stockage: stockage,
      authentificateur: serveur.AuthJetonPartage(jetonServeurDemo));
  final pret = serveur.importerReferentiel(stockage, referentielDemoJson());
  return MockClient((req) async {
    await pret;
    final rep = await api(shelf.Request(req.method, req.url,
        headers: req.headers, body: req.bodyBytes));
    return http.Response.bytes(
        await rep.read().expand((o) => o).toList(), rep.statusCode,
        headers: rep.headers);
  });
}

/// La flotte de démonstration au format du serveur (`GET /v1/referentiel`).
Map<String, Object?> referentielDemoJson() {
  String jour(DateTime d) => d.toIso8601String().substring(0, 10);
  return {
    'navires': [
      for (final n in naviresDemo)
        {
          'id': n.id,
          'nom': n.nom,
          'immatriculation': n.immatriculation,
          'pavillon': n.pavillon,
          'type': n.type.name,
          'longueur_m': n.longueurM,
          'puissance_kw': n.puissanceKw,
          'numero_imo': n.numeroImo,
          'certificats': [
            for (final c in n.certificats)
              {
                'type': c.type.name,
                'numero': c.numero,
                'date_expiration': jour(c.dateExpiration),
              },
          ],
        },
    ],
    'licences': [
      for (final l in licencesDemo.values)
        {
          'numero': l.numero,
          'navire_id': l.navireId,
          'segment': l.segment.name,
          'engins_autorises': [for (final e in l.enginsAutorises) e.name],
          'especes_cibles': [...l.especesCibles],
          'date_debut': jour(l.dateDebut),
          'date_fin': jour(l.dateFin),
          'quotas_kg': l.quotasKg,
        },
    ],
  };
}
