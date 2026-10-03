import 'package:flutter/material.dart';

import '../../l10n/libelles.dart';
import '../format.dart';
import '../models/enums.dart';
import '../regulation/calcul_reglementaire.dart';

/// Affiche le résultat du moteur réglementaire (vert = conforme).
class ResultatCard extends StatelessWidget {
  const ResultatCard({super.key, required this.resultat});

  final ResultatVerification resultat;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    if (resultat.conforme) {
      return Card(
        color: Colors.green.withOpacity(0.15),
        child: ListTile(
          leading: const Icon(Icons.verified, color: Colors.green),
          title: Text(l10n.conforme),
          subtitle: Text(l10n.aucuneNonConformite),
        ),
      );
    }
    return Card(
      color: scheme.errorContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.warning_amber, color: scheme.error),
            title: Text(l10n.nonConformites(resultat.infractions.length)),
            subtitle: Text(l10n.amendeIndicative(
              formaterMontant(resultat.amendeMin),
              formaterMontant(resultat.amendeMax),
            )),
          ),
          for (final i in resultat.infractions)
            ListTile(
              dense: true,
              leading: Icon(
                Icons.circle,
                size: 12,
                color: switch (i.gravite) {
                  Gravite.mineure => Colors.orange,
                  Gravite.grave => Colors.deepOrange,
                  Gravite.tresGrave => Colors.red,
                },
              ),
              title: Text(l10n.messageInfraction(i)),
              subtitle: Text(l10n.libelleGravite(i.gravite)),
            ),
        ],
      ),
    );
  }
}
