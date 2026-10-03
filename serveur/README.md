# Serveur central — Pêche Conforme

Reçoit les **déclarations** et les **contrôles** envoyés par l'application
(`peche_app/`), les vérifie et les enregistre dans **PostgreSQL**.
Écrit en Dart (paquets `shelf` et `postgres`), comme l'application.

## Lancer

### Avec Docker (serveur + base)

```bash
cd serveur
docker compose up --build        # http://localhost:8080/v1/sante
```

### Sans Docker

```bash
cd serveur
dart pub get
export JETON_API=un-secret-d-au-moins-16-caracteres
export DATABASE_URL=postgres://utilisateur:motdepasse@localhost:5432/peche
dart run bin/serveur.dart
```

Sans `DATABASE_URL`, le serveur démarre avec un stockage **en mémoire**
(démonstration : tout est perdu à l'arrêt).

### Brancher l'application

```bash
cd peche_app
flutter run --dart-define=API_URL=http://<adresse-du-serveur>:8080 \
            --dart-define=API_JETON=un-secret-d-au-moins-16-caracteres
```

## Configuration

| Variable | Rôle |
|---|---|
| `JETON_API` | Secret partagé avec l'application (16 caractères minimum, obligatoire) |
| `DATABASE_URL` | `postgres://user:mdp@hote:5432/base` (ajouter `?sslmode=require` en production) |
| `PORT` | Port d'écoute, 8080 par défaut |
| `ORIGINES_AUTORISEES` | Origines web autorisées (CORS), séparées par des virgules ; `*` par défaut |

Les tables sont créées automatiquement au démarrage (migrations
versionnées dans `lib/src/stockage_postgres.dart`, table `schema_version`).

## API

Toutes les routes, sauf `/v1/sante`, exigent l'en-tête
`Authorization: Bearer <JETON_API>`.

| Méthode | Route | Réponse |
|---|---|---|
| GET | `/v1/sante` | `{"statut":"ok","version":"1.0.0"}` |
| POST | `/v1/sync/declarations/{id}` | Reçoit une déclaration (JSON) |
| POST | `/v1/sync/controles/{id}` | Reçoit un contrôle (JSON, PDF en base64) |
| GET | `/v1/declarations?limite=50` | Dernières déclarations reçues |
| GET | `/v1/controles?limite=50` | Derniers contrôles reçus |
| GET | `/v1/controles/{id}/rapport.pdf` | Rapport PDF signé |
| GET | `/v1/statistiques` | Nombre de saisies reçues |

### Réponses de `POST /v1/sync/...`

| Code | Signification | Côté application |
|---|---|---|
| 201 | Nouvelle saisie enregistrée | retirée de la file d'envoi |
| 200 | Saisie identique déjà reçue (renvoi) | retirée de la file d'envoi |
| 400 | Données invalides (`details` liste chaque erreur) | reste en file, erreur affichée |
| 401 | Jeton absent ou faux | reste en file |
| 409 | Même identifiant, contenu différent | reste en file |
| 413 / 415 | Trop volumineux (> 5 Mo) / pas du JSON | reste en file |

**Idempotence** : l'identifiant (UUID) est créé sur le téléphone. Si la
réponse se perd et que le téléphone renvoie, le serveur reconnaît la saisie
grâce à son empreinte SHA-256 et ne crée pas de doublon.

## Tests

```bash
dart test                                    # API (stockage en mémoire)
DATABASE_URL_TEST=postgres://postgres:postgres@localhost:5432/peche_test \
  dart test                                  # + tests sur PostgreSQL
```

L'application a aussi un test de bout en bout
(`peche_app/test/bout_en_bout_test.dart`) qui démarre ce serveur et lui
envoie de vraies requêtes HTTP.

## À faire pour la production

- Remplacer le jeton partagé par **Keycloak / OpenID Connect** (un compte
  par agent et par capitaine, révocation d'un téléphone perdu).
- Mettre le serveur derrière **HTTPS** (reverse proxy ou hébergeur).
- Ajouter les référentiels (navires, licences, quotas) et leur
  téléchargement par l'application, puis recalculer les infractions côté
  serveur avec le même moteur Dart.
- Sauvegardes régulières de la base.
