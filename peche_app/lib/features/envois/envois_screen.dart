import 'package:flutter/material.dart';

import '../../core/data/base/base_de_donnees.dart';
import '../../core/data/base/tables.dart';
import '../../core/data/depots/depots.dart';

/// Liste des saisies enregistrées sur le téléphone et pas encore reçues
/// par le serveur (file d'envoi).
class EnvoisScreen extends StatefulWidget {
  const EnvoisScreen({super.key});

  @override
  State<EnvoisScreen> createState() => _EnvoisScreenState();
}

class _EnvoisScreenState extends State<EnvoisScreen> {
  Future<List<EnvoiLigne>>? _envois;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _envois ??= DepotsScope.of(context).envois.enAttente();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Envois en attente')),
      body: FutureBuilder<List<EnvoiLigne>>(
        future: _envois,
        builder: (context, snapshot) {
          final envois = snapshot.data;
          if (envois == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (envois.isEmpty) {
            return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.cloud_done, size: 48, color: Colors.green),
                SizedBox(height: 8),
                Text('Tout a été envoyé.'),
              ]),
            );
          }
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_off),
                title: Text('${envois.length} saisie(s) stockée(s) '
                    'sur le téléphone'),
                subtitle: const Text('Elles partiront automatiquement au '
                    'retour du réseau.'),
              ),
              const Divider(),
              for (final e in envois)
                ListTile(
                  leading: Icon(switch (e.type) {
                    TypeEnvoi.declaration => Icons.sailing,
                    TypeEnvoi.controle => Icons.shield,
                  }),
                  title: Text(e.resume),
                  subtitle: Text(
                    '${e.creeLe.toIso8601String().substring(0, 16).replaceFirst('T', ' ')}'
                    ' · n° ${e.entiteId.substring(0, 8)}'
                    '${e.tentatives > 0 ? ' · ${e.tentatives} échec(s)' : ''}',
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
