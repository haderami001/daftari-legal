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
            --dart-define=OIDC_EMETTEUR=http://<adresse>:8180/realms/peche
# Développement sans Keycloak : --dart-define=API_JETON=<JETON_API>
```

## Comptes et rôles (Keycloak)

Le domaine Keycloak `peche` est décrit dans
[`../keycloak/realm-peche.json`](../keycloak/realm-peche.json) (importé par
`docker compose`). Le serveur vérifie la signature des jetons (clés publiées
par Keycloak), l'émetteur, le destinataire `peche-api` et l'expiration.

| Rôle | Droits |
|---|---|
| `capitaine` | envoyer des déclarations |
| `agent` | envoyer des contrôles |
| `superviseur` | consulter listes, statistiques, rapports PDF |
| `admin` | tout |

Comptes de démonstration (mot de passe `Demo-Peche-2026`, **à supprimer en
production**) : `capitaine.demo`, `agent.demo`, `superviseur.demo`,
`admin.demo`. Chaque saisie garde le compte qui l'a envoyée (`envoye_par`).

## Configuration

| Variable | Rôle |
|---|---|
| `OIDC_EMETTEUR` | Keycloak : `https://auth.exemple.mr/realms/peche` (recommandé) |
| `OIDC_AUDIENCE` | `aud` attendu, `peche-api` par défaut |
| `OIDC_JWKS_URL` | Adresse des clés si elle diffère (réseau Docker) |
| `JETON_API` | Sans Keycloak : secret partagé, **développement seulement** |
| `DATABASE_URL` | `postgres://user:mdp@hote:5432/base` (ajouter `?sslmode=require` en production) |
| `PORT` | Port d'écoute, 8080 par défaut |
| `REFERENTIEL_INITIAL` | Fichier JSON importé au démarrage si le référentiel est vide (ex. `donnees/referentiel_demo.json`) |
| `ORIGINES_AUTORISEES` | Origines web autorisées (CORS), séparées par des virgules ; `*` par défaut |

Les tables sont créées automatiquement au démarrage (migrations
versionnées dans `lib/src/stockage_postgres.dart`, table `schema_version`).

## API

Toutes les routes, sauf `/v1/sante`, exigent `Authorization: Bearer <jeton
Keycloak>` (401 sinon) et le bon rôle (403 sinon). `GET /v1/moi` renvoie le
compte et les rôles du jeton.

| Méthode | Route | Réponse |
|---|---|---|
| GET | `/v1/sante` | `{"statut":"ok","version":"1.0.0"}` |
| POST | `/v1/sync/declarations/{id}` | Reçoit une déclaration (JSON) |
| POST | `/v1/sync/controles/{id}` | Reçoit un contrôle (JSON, PDF en base64) |
| GET | `/v1/declarations?limite=50` | Dernières déclarations reçues |
| GET | `/v1/controles?limite=50` | Derniers contrôles reçus |
| GET | `/v1/controles/{id}/rapport.pdf` | Rapport PDF signé |
| GET | `/v1/statistiques` | Nombre de saisies reçues |
| GET | `/v1/referentiel` | Navires et licences (tout compte connecté ; `ETag`, 304 si inchangé) |
| PUT | `/v1/navires/{id}` | Crée ou modifie un navire (admin) |
| PUT | `/v1/licences/{numero}` | Crée ou modifie une licence (admin) |
| DELETE | `/v1/navires/{id}` | Supprime un navire sans licence active (admin) |
| DELETE | `/v1/licences/{numero}` | Supprime une licence (admin) |

### Référentiel (navires, licences)

L'administrateur tient la flotte à jour sur le serveur ; chaque téléphone
la télécharge pendant la synchronisation et la garde pour travailler hors
ligne. Chaque modification augmente la **version** du référentiel : le
téléphone envoie la sienne (`If-None-Match`) et ne retélécharge que si
elle a changé.

```bash
curl -X PUT http://localhost:8080/v1/navires/N4 \
  -H "Authorization: Bearer $JETON_ADMIN" -H 'Content-Type: application/json' \
  -d '{"nom":"Tanit","immatriculation":"NKT-SE-0001","pavillon":"MRT",
       "type":"senneur","longueur_m":30,"puissance_kw":500,
       "certificats":[{"type":"navigabilite","numero":"NAV-1",
                       "date_expiration":"2027-12-31"}]}'
curl -X PUT http://localhost:8080/v1/licences/LIC-COT-2026-0400 \
  -H "Authorization: Bearer $JETON_ADMIN" -H 'Content-Type: application/json' \
  -d '{"navire_id":"N4","segment":"cotiere","engins_autorises":["senneTournante"],
       "especes_cibles":["SAA"],"date_debut":"2026-01-01",
       "date_fin":"2026-12-31","quotas_kg":{"SAA":80000}}'
```

Valeurs acceptées — `type` : pirogue, chalutier, senneur, dragueur ;
`segment` : artisanale, cotiere, hauturiere ; certificats : navigabilite,
jaugeage, hygiene, radio. Réponses : 201 créé, 200 modifié, 400 données
invalides (`details`), 403 pas admin, 409 immatriculation déjà prise,
422 licence d'un navire inconnu ou supprimé.

**Suppression** (`DELETE`) : logique. L'élément reste en base avec
`"supprime": true` dans le référentiel (les déclarations et contrôles
passés y font référence) ; les téléphones le masquent à la synchronisation
suivante. Un navire qui a encore des licences est refusé (409
`licences_actives`) : supprimer d'abord ses licences. Un nouvel `PUT` le
rétablit. Réponses : 200 supprimé, 404 introuvable ou déjà supprimé.

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

- Créer les vrais comptes dans Keycloak, supprimer les comptes de démo,
  activer HTTPS sur Keycloak.
- Mettre le serveur derrière **HTTPS** (reverse proxy ou hébergeur).
- Recalculer les infractions côté serveur avec le même moteur Dart et le
  référentiel central.
- Sauvegardes régulières de la base.
