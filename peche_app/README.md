# Pêche Conforme (prototype Flutter)

Prototype d'application universelle de pêche pour la Mauritanie :
déclaration du capitaine, contrôle des garde-côtes, calcul réglementaire
et guide juridique.

📘 **Plan technique complet, architecture, étapes et recommandations :**
[`docs/PLAN_TECHNIQUE.md`](docs/PLAN_TECHNIQUE.md)
🗄️ **Schéma de base de données :** [`docs/schema.sql`](docs/schema.sql)

> ⚠️ Les seuils réglementaires (tailles, maillages, quotas, amendes) contenus
> dans `lib/core/regulation/referentiel.dart` sont **fictifs** et servent
> uniquement à la démonstration. Ils doivent être remplacés par les valeurs
> officielles validées.

## Lancer le projet

```bash
# 1. Installer Flutter : https://docs.flutter.dev/get-started/install
flutter --version          # Flutter 3.24+ / Dart 3.5+

# 2. Récupérer les dépendances
cd peche_app
flutter pub get

# 3. Lancer sur un téléphone Android branché ou un émulateur
flutter run

# 4. Vérifier le code et lancer les tests
flutter analyze
flutter test
```

## Ce que contient le prototype

| Fichier | Rôle |
|---|---|
| `lib/main.dart` | Point d'entrée, thème |
| `lib/core/models/` | Modèles : navire, licence, certificat, déclaration, capture, contrôle |
| `lib/core/regulation/referentiel.dart` | Règles (espèces, engins, barèmes) |
| `lib/core/regulation/calcul_reglementaire.dart` | Moteur : licence, quotas, prises accessoires, maillage, tailles, sanctions |
| `lib/core/regulation/rapport.dart` | Rapport d'inspection automatique |
| `lib/features/declaration/` | Écran **déclaration du capitaine** (4 étapes) |
| `lib/features/controle/` | Écran **contrôle de l'agent** |
| `lib/features/guide/` | Guide réglementaire |
| `test/` | Tests du moteur (8) + tests des écrans (3) |

## Pour apprendre (parcours conseillé)

1. **`lib/core/models/enums.dart`** — les *enums* Dart avec des champs.
2. **`lib/core/models/navire.dart`** — classes, constructeurs `const`,
   champs `final`, paramètres nommés `required`, types nullables (`String?`).
3. **`lib/core/regulation/calcul_reglementaire.dart`** — listes avec
   `if` / `for` à l'intérieur (*collection if/for*), `fold`, *pattern
   matching* (`case final quota? when ...`).
4. **`test/calcul_reglementaire_test.dart`** — écrire un test : préparer des
   données, appeler la fonction, vérifier avec `expect`.
5. **`lib/features/declaration/declaration_capitaine_screen.dart`** —
   `StatefulWidget`, `setState`, `Stepper`, dialogues, formulaires.

Exercice : ajoutez une espèce (par ex. le mérou) dans `referentielDemo`,
puis un test qui vérifie qu'un individu trop petit est signalé.
