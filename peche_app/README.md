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
#    … avec le serveur central (../serveur) et les comptes Keycloak :
flutter run --dart-define=API_URL=http://<adresse-du-serveur>:8080 \
            --dart-define=OIDC_EMETTEUR=http://<adresse>:8180/realms/peche
#    Sans OIDC_EMETTEUR : mode démonstration (pas de connexion).

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
flutter run -d chrome --web-renderer canvaskit --no-web-resources-cdn
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
  en file avec le nombre de tentatives et l'erreur. Ensuite, le
  **référentiel** (navires, certificats, licences, quotas) est téléchargé
  depuis `GET {API_URL}/v1/referentiel` s'il a changé (version comparée),
  puis installé dans la base locale en une seule transaction.
- **Tableau de bord** (`lib/features/supervision/`) : rôle `superviseur`
  (et admin), serveur requis. Chiffres clés, dernières déclarations et
  derniers contrôles reçus par le serveur (navire, date, infractions,
  compte qui a envoyé) et rapport PDF signé de chaque contrôle.
- **Administration** (`lib/features/administration/`) : réservée au rôle
  `admin`, visible quand un serveur est configuré. Liste, ajoute et modifie
  les navires (avec certificats) et les licences (engins, espèces, dates,
  quotas) directement sur le serveur (`PUT /v1/navires/{id}`,
  `PUT /v1/licences/{numero}`), et les supprime après confirmation
  (`DELETE`, suppression logique : l'historique des saisies est gardé) ; les refus du serveur s'affichent champ par
  champ, puis la synchronisation met à jour la copie du téléphone.
- **Serveur central** : dossier [`../serveur`](../serveur/README.md) (Dart,
  PostgreSQL, Docker). `test/bout_en_bout_test.dart` démarre ce serveur et
  vérifie que les saisies de l'application y arrivent (vraies requêtes HTTP).
- **Migrations** : `schemaVersion` 2 ajoute la colonne du rapport PDF ; un
  téléphone resté en version 1 est mis à jour automatiquement (testé).

## Langues : français et arabe

- L'interface est traduite en **arabe** (affichage de droite à gauche) et en
  français. Menu **Langue** (icône 文A) sur l'accueil : langue du téléphone,
  français ou العربية. Le choix est gardé dans la base locale (table
  `reglages`, schéma v3).
- Les textes sont dans `lib/l10n/app_fr.arb` (modèle) et `lib/l10n/app_ar.arb`.
  Le code Dart correspondant est généré par `flutter gen-l10n` (automatique à
  chaque `flutter pub get`). Le pluriel arabe (1, 2, 3 à 10, 11 et plus) est
  géré par le format ICU des fichiers ARB.
- Le moteur réglementaire reste en français ; chaque infraction porte ses
  valeurs brutes (`details`) et `lib/l10n/libelles.dart` rédige le message
  dans la langue de l'écran.
- Le **rapport officiel** (texte et PDF) reste en français.
- Texte bidirectionnel : les montants utilisent une espace insécable et les
  coordonnées GPS sont isolées (`lib/core/format.dart`), sinon « 1 200 000 »
  s'afficherait « 000 200 1 » dans une phrase arabe (testé dans
  `test/bidi_test.dart`).
- Polices embarquées **Noto Sans** et **Noto Sans Arabic** (licence OFL,
  `assets/fonts/`) : même rendu sur tous les appareils, sans réseau.

## Comptes utilisateurs (Keycloak)

- Écran de **connexion** (identifiant + mot de passe Keycloak). La session
  est gardée chiffrée sur le téléphone (`flutter_secure_storage`) avec un
  jeton « hors ligne » valable 30 jours : l'agent se connecte une fois à
  terre, travaille en mer sans réseau, et ses saisies partent au retour.
- L'accueil n'affiche que les modules du **rôle** : capitaine → déclaration,
  agent → contrôle, admin → tout. Le rapport porte le nom de l'agent connecté.
- Menu **Compte** : nom, identifiant, déconnexion (session révoquée).
- Code : `lib/core/services/session.dart`, `lib/features/connexion/`.
- Évolution recommandée : connexion par le navigateur (Authorization Code +
  PKCE, déjà autorisée côté Keycloak) au lieu du formulaire.

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
| `lib/main.dart` | Point d'entrée, thème, serveur (`API_URL`, `API_JETON`) |
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
| `lib/l10n/` | Traductions français / arabe et libellés traduits |
| `tool/preparer_web.sh` | Prépare la version navigateur |
| `test/` | Tests : moteur, base, PDF, synchronisation et référentiel, connexion, écrans, traduction, texte bidirectionnel, bout en bout avec le serveur |

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
10. **`lib/l10n/app_fr.arb`** puis **`lib/l10n/libelles.dart`** — traduire
    une application : textes avec paramètres, pluriels, `select` pour les
    listes, extension sur `AppLocalizations`.

Exercices :
- ajoutez une espèce (par ex. le mérou) dans `referentielDemo`,
  puis un test qui vérifie qu'un individu trop petit est signalé ;
- ajoutez une colonne `portDebarquement` à la table `Declarations`
  (passez `schemaVersion` à 4 et écrivez la migration : modèles dans
  `base_de_donnees.dart`, la v2 ajoute une colonne, la v3 une table) ;
- traduisez un nouveau texte : ajoutez la clé dans `app_fr.arb` et
  `app_ar.arb`, lancez `flutter gen-l10n`, utilisez `context.l10n.maCle` ;
- ajoutez au rapport PDF le nom du port de débarquement.
