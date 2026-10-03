# Mise en ligne du serveur (HTTPS)

Installe sur **un seul serveur Linux** l'API « Pêche Conforme », Keycloak
(comptes) et PostgreSQL, derrière **Caddy**, qui obtient et renouvelle
automatiquement les certificats HTTPS (Let's Encrypt).

```
Téléphones ──HTTPS──► Caddy ──► API (serveur/)   https://api.mondomaine.mr
                            └─► Keycloak         https://auth.mondomaine.mr
                      PostgreSQL (bases « peche » et « keycloak »)
```

## Ce qu'il faut

1. Un **serveur Linux** (VPS) : Ubuntu 22.04/24.04, 2 Go de RAM, 20 Go de
   disque. N'importe quel hébergeur convient (OVH, Hetzner, Scaleway,
   DigitalOcean, un serveur de l'administration…).
2. Un **nom de domaine** et deux enregistrements DNS de type **A** vers
   l'adresse IP du serveur : `api.mondomaine.mr` et `auth.mondomaine.mr`.
3. Les ports **80 et 443** ouverts (pare-feu de l'hébergeur).

## Installation (une commande)

```bash
git clone https://github.com/haderami001/daftari-legal.git
cd daftari-legal/deploiement
sudo ./installer.sh api.mondomaine.mr auth.mondomaine.mr moi@mondomaine.mr
```

Le script installe Docker si besoin, génère des mots de passe aléatoires
(fichier `.env`, lisible par root seulement), prépare le domaine Keycloak
`peche` **sans les comptes de démonstration**, démarre tout et vérifie que
l'API répond en HTTPS. Il affiche ensuite la commande pour construire
l'application branchée sur ce serveur :

```bash
flutter build apk --dart-define=API_URL=https://api.mondomaine.mr \
                  --dart-define=OIDC_EMETTEUR=https://auth.mondomaine.mr/realms/peche
```

## Créer les comptes

Console Keycloak : `https://auth.mondomaine.mr/admin` (utilisateur `admin`,
mot de passe `MOT_DE_PASSE_ADMIN_KEYCLOAK` dans `.env`).
Domaine **peche** → *Users* → *Add user*, puis onglet *Credentials* (mot de
passe) et *Role mapping* : `capitaine`, `agent`, `superviseur` ou `admin`.

Pour un serveur d'**essai**, `GARDER_COMPTES_DEMO=oui` dans `.env` garde
les comptes de démonstration et `REFERENTIEL_INITIAL=/app/donnees/referentiel_demo.json`
charge la flotte de démo.

## Exploitation

| Action | Commande (dans `deploiement/`) |
|---|---|
| État | `docker compose ps` |
| Journaux | `docker compose logs -f serveur keycloak caddy` |
| Mise à jour | `git pull && sudo ./installer.sh` |
| Sauvegarde de la base | `docker compose exec base pg_dumpall -U peche > sauvegarde.sql` |
| Arrêt | `docker compose down` (les données restent dans les volumes) |

## Testé

L'ensemble a été démarré avec des domaines locaux (`api.localhost`,
`auth.localhost`, certificats de l'autorité locale de Caddy) :
redirection HTTP → HTTPS, `GET /v1/sante`, connexion Keycloak en HTTPS,
jeton accepté par l'API (`/v1/moi`), référentiel de démonstration,
401 sans jeton.
