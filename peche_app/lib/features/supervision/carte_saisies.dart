import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/services/supervision.dart';
import '../../l10n/libelles.dart';

/// Carte des saisies reçues par le serveur : déclarations en bleu,
/// contrôles en vert (conformes) ou rouge (avec infraction).
///
/// Le fond de carte vient d'OpenStreetMap : il faut Internet pour le voir
/// (le tableau de bord a de toute façon besoin du serveur).
class CarteSaisies extends StatelessWidget {
  const CarteSaisies({
    super.key,
    required this.declarations,
    required this.controles,
    this.onControle,
  });

  final List<SaisieRecue> declarations;
  final List<SaisieRecue> controles;

  /// Appui sur un contrôle (ex. ouvrir son rapport PDF).
  final void Function(SaisieRecue)? onControle;

  /// Large de la Mauritanie, entre Nouadhibou et Nouakchott.
  static const _centreMauritanie = LatLng(19.5, -17.0);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final points = [
      for (final s in declarations)
        if (s.aUnePosition) (s, false),
      for (final s in controles)
        if (s.aUnePosition) (s, true),
    ];
    Marker repere(SaisieRecue s, bool controle) {
      final couleur = !controle
          ? Colors.blue.shade700
          : s.nbInfractions == 0
              ? Colors.green.shade700
              : Colors.red.shade700;
      return Marker(
        point: LatLng(s.latitude!, s.longitude!),
        width: 36,
        height: 36,
        child: Tooltip(
          message: '${s.navireId} · ${l10n.nbInfractions(s.nbInfractions)}',
          child: GestureDetector(
            onTap: controle && onControle != null ? () => onControle!(s) : null,
            child: Icon(
              controle ? Icons.shield : Icons.directions_boat,
              color: couleur,
              size: 32,
              shadows: const [Shadow(color: Colors.white, blurRadius: 4)],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Text(
            points.isEmpty ? l10n.carteSansPosition : l10n.carteLegende,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: _centreMauritanie,
              initialZoom: 6,
              initialCameraFit: points.length < 2
                  ? null
                  : CameraFit.coordinates(
                      coordinates: [
                        for (final (s, _) in points)
                          LatLng(s.latitude!, s.longitude!),
                      ],
                      padding: const EdgeInsets.all(48),
                      maxZoom: 11,
                    ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'mr.gov.peche.peche_app',
              ),
              MarkerLayer(markers: [
                for (final (s, controle) in points) repere(s, controle),
              ]),
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('© OpenStreetMap'),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(l10n.carteHorsLigne,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
