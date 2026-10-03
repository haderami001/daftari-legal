import 'package:peche_app/core/data/base/tables.dart';
import 'package:peche_app/core/services/synchronisation.dart';

/// Faux serveur pour les tests : garde ce qu'il reçoit, et peut simuler
/// une panne.
class FauxServeur implements ApiSynchro {
  final recus = <(TypeEnvoi, String, Map<String, Object?>)>[];
  bool enPanne = false;

  /// Référentiel servi (`null` = le serveur n'en a pas encore).
  Map<String, Object?>? referentiel;
  final versionsDemandees = <int?>[];

  @override
  Future<void> envoyer(
      TypeEnvoi type, String id, Map<String, Object?> donnees) async {
    if (enPanne) throw const ErreurSynchro('Serveur : HTTP 503');
    recus.add((type, id, donnees));
  }

  @override
  Future<Map<String, Object?>?> telechargerReferentiel(
      {int? versionConnue}) async {
    if (enPanne) throw const ErreurSynchro('Serveur : HTTP 503');
    versionsDemandees.add(versionConnue);
    final r = referentiel;
    return r == null || r['version'] == versionConnue ? null : r;
  }
}
