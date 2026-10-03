# Pêche Conforme (prototype Flutter)

Application universelle de pêche pour la Mauritanie : déclaration du
capitaine, contrôle des garde-côtes avec rapport PDF signé, calcul
réglementaire, guide juridique. Elle fonctionne **sans réseau** (base
SQLite sur le téléphone) et envoie les saisies au serveur au retour du
réseau.

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
#    … avec un serveur central (sinon les saisies restent en file d'envoi) :
flutter run --dart-define=API_URL=https://api.exemple.mr

# 4. Vérifier le code et lancer les tests
flutter analyze
flutter test
```

Après toute modification de `lib/core/data/base/tables.dart`, régénérez le
code Drift (puis committez le fichier `.g.dart`) :

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Version navigateur (démonstration)

```bash
./tool/preparer_web.sh       # SQLite WebAssembly, worker Drift, pdf.js
flutter run -d chrome --web-renderer html
```

### Dans VS Code

Ouvrez le dossier du dépôt, installez l'extension **Flutter** proposée,
puis lancez « Pêche Conforme » depuis l'onglet *Exécuter et déboguer*
(configurations dans `.vscode/launch.json`).

### Télécharger l'application sans rien installer

À chaque modification, GitHub Actions construit l'**APK Android** et la
**version web** : onglet *Actions* du dépôt → dernière exécution →
section *Artifacts* (`peche-conforme-apk`, `peche-conforme-web`).

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
- **Synchronisation** (`lib/core/services/synchronisation.dart`) : au
  démarrage, au retour de chaque écran et avec le bouton « Envoyer
  maintenant », chaque saisie part en JSON vers
  `POST {API_URL}/v1/sync/{declarations|controles}/{id}` avec l'en-tête
  `Idempotency-Key` (pas de doublon si on renvoie). Un échec laisse la saisie
  en file avec le nombre de tentatives et l'erreur.
- **Migrations** : `schemaVersion` 2 ajoute la colonne du rapport PDF ; un
  téléphone resté en version 1 est mis à jour automatiquement (testé).

## Rapport PDF et GPS

- **Rapport d'inspection PDF** (`lib/core/regulation/rapport_pdf.dart`) :
  A4, identification, constatations, maillage, échantillons, infractions,
  amende indicative, cases de signature. Le PDF est produit au moment de la
  signature et **stocké tel quel** dans la base (valeur probante) ; on peut
  l'imprimer ou le partager, et le rouvrir depuis « Envois en attente ».
- **Position GPS** (`lib/core/services/position_service.dart`) : mesure
  réelle via `geolocator`. Si le GPS est refusé ou ne répond pas, la saisie
  reste possible et l'écran affiche « (non mesurée) ».

## Ce que contient le prototype

| Fichier | Rôle |
|---|---|
| `lib/main.dart` | Point d'entrée, thème, adresse du serveur (`API_URL`) |
| `lib/core/models/` | Modèles : navire, licence, certificat, déclaration, capture, contrôle |
| `lib/core/regulation/referentiel.dart` | Règles (espèces, engins, barèmes) |
| `lib/core/regulation/calcul_reglementaire.dart` | Moteur : licence, quotas, prises accessoires, maillage, tailles, sanctions |
| `lib/core/regulation/rapport.dart` | Rapport d'inspection (texte) |
| `lib/core/regulation/rapport_pdf.dart` | Rapport d'inspection (PDF) |
| `lib/core/services/` | `Services` partagés, GPS, synchronisation |
| `lib/core/data/base/tables.dart` | Tables SQLite (Drift) |
| `lib/core/data/base/base_de_donnees.dart` | Base locale, version du schéma, données initiales |
| `lib/core/data/depots/` | Dépôts : lecture de la flotte, enregistrement des saisies, file d'envoi |
| `lib/features/declaration/` | Écran **déclaration du capitaine** (4 étapes) |
| `lib/features/controle/` | Écran **contrôle de l'agent** et aperçu du PDF |
| `lib/features/guide/` | Guide réglementaire |
| `lib/features/envois/` | Écran **envois en attente** |
| `tool/preparer_web.sh` | Prépare la version navigateur |
| `test/` | 25 tests : moteur (8), base (6), PDF (1), synchronisation (5), écrans (5) |

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
   (`NativeDatabase.memory()`), et tester une migration.
8. **`lib/core/services/position_service.dart`** — classe abstraite
   (interface) et deux implémentations : le vrai GPS et une position fixe
   pour les tests.
9. **`lib/core/services/synchronisation.dart`** + **`test/faux_serveur.dart`**
   — appel HTTP, gestion des erreurs, et comment tester sans vrai serveur.

Exercices :
- ajoutez une espèce (par ex. le mérou) dans `referentielDemo`,
  puis un test qui vérifie qu'un individu trop petit est signalé ;
- ajoutez une colonne `portDebarquement` à la table `Declarations`
  (passez `schemaVersion` à 3 et écrivez la migration : modèle dans
  `base_de_donnees.dart`, la v2 ajoute déjà une colonne) ;
- ajoutez au rapport PDF le nom du port de débarquement.
