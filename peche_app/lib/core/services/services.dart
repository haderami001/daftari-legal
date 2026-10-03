import 'package:flutter/widgets.dart';

import '../data/base/base_de_donnees.dart';
import '../data/depots/file_envoi_depot.dart';
import '../data/depots/flotte_depot.dart';
import '../data/depots/reglages_depot.dart';
import '../data/depots/saisie_depot.dart';
import 'position_service.dart';
import 'session.dart';
import 'synchronisation.dart';

/// Tout ce dont les écrans ont besoin, créé une seule fois au démarrage :
/// la base locale, ses dépôts, le GPS et la synchronisation.
///
/// En test, on crée des `Services` avec une base en mémoire, une position
/// fixe et un faux serveur : les écrans ne voient pas la différence.
class Services {
  Services(
    this.base, {
    this.position = const PositionGeolocator(),
    ApiSynchro? api,
    Session? session,
  })  : session = session ?? SessionDemo(),
        flotte = FlotteDepot(base),
        saisies = SaisieDepot(base),
        envois = FileEnvoiDepot(base),
        reglages = ReglagesDepot(base) {
    synchro = Synchroniseur(
        saisies: saisies,
        file: envois,
        api: api,
        flotte: flotte,
        reglages: reglages);
  }

  final BaseDeDonnees base;
  final FlotteDepot flotte;
  final SaisieDepot saisies;
  final FileEnvoiDepot envois;
  final ReglagesDepot reglages;
  final ServicePosition position;

  /// Compte connecté (Keycloak) ou mode démonstration.
  final Session session;
  late final Synchroniseur synchro;
}

/// Rend les [Services] accessibles à tous les écrans :
/// `ServicesScope.of(context).flotte...`
///
/// (Un `InheritedWidget` est le mécanisme de base de Flutter pour partager
/// un objet dans l'arbre de widgets ; Riverpod le fait en plus confortable.)
class ServicesScope extends InheritedWidget {
  const ServicesScope({
    super.key,
    required this.services,
    required super.child,
  });

  final Services services;

  static Services of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ServicesScope>()!.services;

  @override
  bool updateShouldNotify(ServicesScope oldWidget) =>
      services != oldWidget.services;
}
