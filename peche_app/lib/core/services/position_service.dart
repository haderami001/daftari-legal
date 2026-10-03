import 'package:geolocator/geolocator.dart';

import '../models/declaration.dart';

/// Fournit la position du téléphone.
///
/// C'est une classe abstraite (une « interface ») : les écrans ne
/// dépendent pas du GPS réel, ce qui permet de les tester avec
/// [PositionFixe].
abstract class ServicePosition {
  Future<PositionGps> positionActuelle();
}

/// Position réelle via le GPS du téléphone (package `geolocator`).
///
/// En cas de refus de permission, de GPS coupé ou de délai dépassé, on
/// renvoie la position de [repli] marquée `demonstration: true` : la saisie
/// reste possible et l'écran affiche que la position n'est pas mesurée.
class PositionGeolocator implements ServicePosition {
  const PositionGeolocator({
    this.repli = const (latitude: 20.85, longitude: -17.45),
    this.delai = const Duration(seconds: 10),
  });

  /// Position utilisée si le GPS ne répond pas (large de Nouadhibou).
  final ({double latitude, double longitude}) repli;
  final Duration delai;

  @override
  Future<PositionGps> positionActuelle() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return _repli();
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return _repli();
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: delai,
        ),
      );
      return PositionGps(p.latitude, p.longitude, p.timestamp.toLocal());
    } catch (_) {
      // Délai dépassé, plateforme sans GPS, etc.
      return _repli();
    }
  }

  PositionGps _repli() =>
      PositionGps(repli.latitude, repli.longitude, DateTime.now(),
          demonstration: true);
}

/// Position constante : tests, démonstration.
class PositionFixe implements ServicePosition {
  const PositionFixe(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  @override
  Future<PositionGps> positionActuelle() async =>
      PositionGps(latitude, longitude, DateTime.now());
}
