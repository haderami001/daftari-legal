import 'package:flutter/material.dart';

import '../../core/services/services.dart';
import '../../core/services/session.dart';
import '../../l10n/libelles.dart';

/// Connexion avec un compte Keycloak (identifiant + mot de passe).
class ConnexionScreen extends StatefulWidget {
  const ConnexionScreen({super.key});

  @override
  State<ConnexionScreen> createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {
  final _identifiant = TextEditingController();
  final _motDePasse = TextEditingController();
  bool _enCours = false;
  String? _erreur;

  @override
  void dispose() {
    _identifiant.dispose();
    _motDePasse.dispose();
    super.dispose();
  }

  Future<void> _connecter() async {
    final l10n = context.l10n;
    if (_identifiant.text.trim().isEmpty || _motDePasse.text.isEmpty) {
      setState(() => _erreur = l10n.connexionChampsVides);
      return;
    }
    setState(() {
      _enCours = true;
      _erreur = null;
    });
    try {
      await ServicesScope.of(context)
          .session
          .connecter(_identifiant.text.trim(), _motDePasse.text);
      // L'application affiche l'accueil dès que la session change.
    } on ExceptionConnexion catch (e) {
      if (!mounted) return;
      setState(() {
        _enCours = false;
        _erreur = switch (e.erreur) {
          ErreurConnexion.identifiants => l10n.connexionIdentifiants,
          ErreurConnexion.reseau => l10n.connexionReseau,
          ErreurConnexion.serveur => l10n.connexionServeur,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.sailing, size: 64),
                    const SizedBox(height: 8),
                    Text(l10n.appTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(l10n.connexionSousTitre, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _identifiant,
                      enabled: !_enCours,
                      autofillHints: const [AutofillHints.username],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: l10n.identifiant,
                          prefixIcon: const Icon(Icons.person)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _motDePasse,
                      enabled: !_enCours,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _connecter(),
                      decoration: InputDecoration(
                          labelText: l10n.motDePasse,
                          prefixIcon: const Icon(Icons.lock)),
                    ),
                    if (_erreur != null) ...[
                      const SizedBox(height: 12),
                      Text(_erreur!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _enCours ? null : _connecter,
                      child: _enCours
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(l10n.seConnecter),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
