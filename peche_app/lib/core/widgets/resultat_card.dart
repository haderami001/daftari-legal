import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../regulation/calcul_reglementaire.dart';

/// Affiche le résultat du moteur réglementaire (vert = conforme).
class ResultatCard extends StatelessWidget {
  const ResultatCard({super.key, required this.resultat});

  final ResultatVerification resultat;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (resultat.conforme) {
      return Card(
        color: Colors.green.withOpacity(0.15),
        child: const ListTile(
          leading: Icon(Icons.verified, color: Colors.green),
          title: Text('Conforme'),
          subtitle: Text('Aucune non-conformité détectée.'),
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
            title: Text('${resultat.infractions.length} non-conformité(s)'),
            subtitle: Text(
              'Amende indicative : ${resultat.amendeMin.toStringAsFixed(0)}'
              ' – ${resultat.amendeMax.toStringAsFixed(0)} MRU',
            ),
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
              title: Text(i.message),
              subtitle: Text(i.gravite.libelle),
            ),
        ],
      ),
    );
  }
}
