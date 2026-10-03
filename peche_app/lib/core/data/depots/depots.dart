import 'package:flutter/widgets.dart';

import '../base/base_de_donnees.dart';
import 'file_envoi_depot.dart';
import 'flotte_depot.dart';
import 'saisie_depot.dart';

/// Regroupe les dépôts créés à partir d'une même base.
class Depots {
  Depots(this.base)
      : flotte = FlotteDepot(base),
        saisies = SaisieDepot(base),
        envois = FileEnvoiDepot(base);

  final BaseDeDonnees base;
  final FlotteDepot flotte;
  final SaisieDepot saisies;
  final FileEnvoiDepot envois;
}

/// Rend les [Depots] accessibles à tous les écrans :
/// `DepotsScope.of(context).flotte...`
///
/// (Un `InheritedWidget` est le mécanisme de base de Flutter pour partager
/// un objet dans l'arbre de widgets ; Riverpod le fait en plus confortable.)
class DepotsScope extends InheritedWidget {
  const DepotsScope({super.key, required this.depots, required super.child});

  final Depots depots;

  static Depots of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DepotsScope>()!.depots;

  @override
  bool updateShouldNotify(DepotsScope oldWidget) => depots != oldWidget.depots;
}
