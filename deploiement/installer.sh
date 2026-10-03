#!/usr/bin/env bash
# Installe le serveur « Pêche Conforme » en HTTPS sur un serveur Linux
# (Ubuntu/Debian conseillé, 2 Go de RAM minimum).
#
#   ./installer.sh api.mondomaine.mr auth.mondomaine.mr moi@mondomaine.mr
#
# Avant : deux enregistrements DNS de type A (api… et auth…) vers l'adresse
# IP du serveur, et les ports 80 et 443 ouverts. Relancer le script est sans
# danger : il met à jour et redémarre ce qui a changé.
set -euo pipefail
cd "$(dirname "$0")"

# 1. Docker
if ! command -v docker >/dev/null 2>&1; then
  echo "Installation de Docker…"
  curl -fsSL https://get.docker.com | sh
fi
docker compose version >/dev/null

# 2. Configuration (.env)
if [ ! -f .env ]; then
  if [ $# -lt 3 ]; then
    echo "Usage : $0 <domaine-api> <domaine-auth> <email-letsencrypt>" >&2
    exit 64
  fi
  sed -e "s|^DOMAINE_API=.*|DOMAINE_API=$1|" \
      -e "s|^DOMAINE_AUTH=.*|DOMAINE_AUTH=$2|" \
      -e "s|^EMAIL_ACME=.*|EMAIL_ACME=$3|" .env.exemple > .env
  chmod 600 .env
fi
secret() { head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n'; }
for cle in MOT_DE_PASSE_BASE MOT_DE_PASSE_ADMIN_KEYCLOAK; do
  if grep -q "^$cle=$" .env; then
    sed -i "s|^$cle=$|$cle=$(secret)|" .env
  fi
done
set -a; . ./.env; set +a
: "${EMAIL_ACME:?EMAIL_ACME manquant dans .env}"

# 3. Domaine Keycloak : sans les comptes de démonstration, sauf demande.
mkdir -p keycloak
python3 - "${GARDER_COMPTES_DEMO:-non}" <<'PY'
import json, sys
realm = json.load(open('../keycloak/realm-peche.json'))
if sys.argv[1] != 'oui':
    realm.pop('users', None)
realm['sslRequired'] = 'external'
json.dump(realm, open('keycloak/realm-peche.json', 'w'), ensure_ascii=False, indent=2)
PY

# 4. Démarrage
docker compose up -d --build

# 5. Vérification : l'API répond en HTTPS (certificat obtenu par Caddy).
echo "Attente du certificat HTTPS et du démarrage (jusqu'à 5 minutes)…"
for _ in $(seq 1 60); do
  if curl -fsS "https://$DOMAINE_API/v1/sante" ${CURL_OPTIONS:-} >/dev/null 2>&1 &&
     curl -fsS "https://$DOMAINE_AUTH/realms/peche/.well-known/openid-configuration" \
       ${CURL_OPTIONS:-} >/dev/null 2>&1; then
    cat <<FIN

✅ Serveur en ligne :
   API       https://$DOMAINE_API/v1/sante
   Comptes   https://$DOMAINE_AUTH/admin   (admin / voir .env)

Application à construire avec :
   flutter build apk --dart-define=API_URL=https://$DOMAINE_API \\
                     --dart-define=OIDC_EMETTEUR=https://$DOMAINE_AUTH/realms/peche
FIN
    exit 0
  fi
  sleep 5
done
echo "❌ Pas de réponse en HTTPS. Journaux : docker compose logs caddy serveur keycloak" >&2
exit 1
