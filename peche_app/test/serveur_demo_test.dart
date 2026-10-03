import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peche_app/core/data/base/base_de_donnees.dart';
import 'package:peche_app/core/services/administration.dart';
import 'package:peche_app/core/services/serveur_demo.dart';
import 'package:peche_app/core/services/services.dart';
import 'package:peche_app/core/services/supervision.dart';
import 'package:peche_app/core/services/synchronisation.dart';

/// Mode démonstration complet : le serveur tourne dans l'application.
void main() {
  test('flotte de démo servie, administration et tableau de bord', () async {
    final client = clientServeurDemo();
    Future<String?> jeton() async => jetonServeurDemo;
    final db = BaseDeDonnees.avec(NativeDatabase.memory());
    addTearDown(db.close);
    final s = Services(db,
        api: ApiHttp(adresseServeurDemo, client: client, jeton: jeton));

    final admin =
        ApiAdministration(adresseServeurDemo, client: client, jeton: jeton);
    final ref = await admin.referentiel();
    expect((ref['navires']! as List).length, 3);
    expect((ref['licences']! as List).length, 3);

    // La copie du téléphone (créée avec la même flotte) se met à jour.
    final r = await s.synchro.synchroniser();
    expect(r.referentielVersion, greaterThan(0));
    expect(r.erreurReferentiel, isNull);
    expect((await s.flotte.naviresAvecLicence()).length, 3);

    final stats =
        await ApiSupervision(adresseServeurDemo, client: client, jeton: jeton)
            .statistiques();
    expect(stats, {'declarations': 0, 'controles': 0});
  });
}
