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

Après toute modification de `lib/core/data/base/tables.dart`, régénérez le
code Drift (puis committez le fichier `.g.dart`) :

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Base de données hors ligne (Drift / SQLite)

En mer il n'y a pas de réseau : tout est enregistré **sur le téléphone**.

```
Écran ──► Dépôt (lib/core/data/depots/) ──► Drift ──► fichier SQLite
                                   └──► file d'envoi (FileEnvois) ──► serveur*
```

- **Référentiel** : navires, certificats, licences, quotas. Au premier
  lancement, la base est remplie avec la flotte de démo ; en production elle
  sera téléchargée depuis l'API.
- **Saisies** : chaque déclaration ou contrôle signé reçoit un **UUID** et
  est écrit en une seule **transaction** (la saisie, ses lignes et son entrée
  dans la file d'envoi), donc jamais à moitié.
- **File d'envoi** : écran « Envois en attente » et compteur sur l'accueil.
  *L'envoi au serveur (`POST /sync`) sera branché quand l'API existera ; les
  méthodes `marquerEnvoye` / `marquerEchec` sont prêtes.

## Ce que contient le prototype

| Fichier | Rôle |
|---|---|
| `lib/main.dart` | Point d'entrée, thème |
| `lib/core/models/` | Modèles : navire, licence, certificat, déclaration, capture, contrôle |
| `lib/core/regulation/referentiel.dart` | Règles (espèces, engins, barèmes) |
| `lib/core/regulation/calcul_reglementaire.dart` | Moteur : licence, quotas, prises accessoires, maillage, tailles, sanctions |
| `lib/core/regulation/rapport.dart` | Rapport d'inspection automatique |
| `lib/core/data/base/tables.dart` | Tables SQLite (Drift) |
| `lib/core/data/base/base_de_donnees.dart` | Base locale, version du schéma, données initiales |
| `lib/core/data/depots/` | Dépôts : lecture de la flotte, enregistrement des saisies, file d'envoi |
| `lib/features/declaration/` | Écran **déclaration du capitaine** (4 étapes) |
| `lib/features/controle/` | Écran **contrôle de l'agent** |
| `lib/features/guide/` | Guide réglementaire |
| `lib/features/envois/` | Écran **envois en attente** |
| `test/` | Tests du moteur (8), de la base (5) et des écrans (4) |

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
6. **`lib/core/data/base/tables.dart`** puis **`depots/saisie_depot.dart`** —
   décrire une table en Dart, `async` / `await`, transactions.
7. **`test/base_de_donnees_test.dart`** — tester avec une base en mémoire
   (`NativeDatabase.memory()`).

Exercices :
- ajoutez une espèce (par ex. le mérou) dans `referentielDemo`,
  puis un test qui vérifie qu'un individu trop petit est signalé ;
- ajoutez une colonne `portDebarquement` à la table `Declarations`
  (pensez à passer `schemaVersion` à 2 et à écrire la migration).
