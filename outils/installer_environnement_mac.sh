#!/usr/bin/env bash
# Installe l'environnement de développement sur le Mac (Intel) :
#   Android Studio + SDK Android + émulateur, simulateur iPhone,
#   Node.js 22 LTS, bibliothèques Python de base.
# Sans sudo : tout va dans /Applications (ou ~/Applications) et dans le
# dossier de l'utilisateur. Relançable : chaque étape déjà faite est sautée.
# Usage : ./outils/installer_environnement_mac.sh [etape...]
#   étapes : studio sdk avd node python ios flutter (par défaut : toutes)
set -uo pipefail

DEV="$HOME/development"
SDK="$HOME/Library/Android/sdk"
TELECHARGEMENTS="$HOME/Downloads"
JOURNAL="$(cd "$(dirname "$0")/.." && pwd)/peche_app/build/installation.log"
mkdir -p "$(dirname "$JOURNAL")" "$DEV" "$TELECHARGEMENTS"
exec > >(tee -a "$JOURNAL") 2>&1

STUDIO_URL="https://edgedl.me.gvt1.com/android/studio/install/2026.2.1.8/android-studio-rabbit1-mac.dmg"
STUDIO_SHA="9284f783ac1096af1e0612173d8b5e17693fe32cc44ef8f6bec5d1367e00c40e"
OUTILS_BUILD="15859902"
OUTILS_SHA="c5a6378ab5cf7e0d5701921405115befff13e9ff7417fb588389338f8bd050f3"
API=36
IMAGE="system-images;android-${API};google_apis;x86_64"
AVD="Pixel_Peche"

etape() { echo; echo "======== $(date '+%H:%M:%S') $* ========"; }
ok() { echo "OK : $*"; }
erreur() { echo "ERREUR : $*"; ECHECS+=("$*"); }
ECHECS=()

ajouter_zshrc() { # ajoute une ligne à ~/.zshrc si elle n'y est pas déjà
  touch "$HOME/.zshrc"
  grep -qxF "$1" "$HOME/.zshrc" || { echo "$1" >> "$HOME/.zshrc"; echo "~/.zshrc : $1"; }
}

trouver_studio() {
  for d in "/Applications/Android Studio.app" "$HOME/Applications/Android Studio.app"; do
    [ -d "$d" ] && { echo "$d"; return 0; }
  done
  return 1
}

java_home() { echo "$(trouver_studio)/Contents/jbr/Contents/Home"; }

etape_studio() {
  etape "Android Studio"
  if trouver_studio >/dev/null; then ok "déjà installé : $(trouver_studio)"; return; fi
  local dmg="$TELECHARGEMENTS/android-studio-rabbit1-mac.dmg"
  if ! echo "$STUDIO_SHA  $dmg" | shasum -a 256 -c --status 2>/dev/null; then
    echo "Téléchargement (1,5 Go)…"
    curl -fL --retry 3 -C - -o "$dmg" "$STUDIO_URL" || { erreur "téléchargement Android Studio"; return; }
    echo "$STUDIO_SHA  $dmg" | shasum -a 256 -c || { erreur "empreinte SHA-256 du .dmg incorrecte"; return; }
  fi
  local montage; montage=$(mktemp -d)
  hdiutil attach -nobrowse -readonly -mountpoint "$montage" "$dmg" >/dev/null || { erreur "ouverture du .dmg"; return; }
  if cp -R "$montage/Android Studio.app" /Applications/ 2>/dev/null; then
    ok "copié dans /Applications"
  else
    mkdir -p "$HOME/Applications" && cp -R "$montage/Android Studio.app" "$HOME/Applications/" \
      && ok "copié dans ~/Applications" || erreur "copie d'Android Studio"
  fi
  hdiutil detach "$montage" >/dev/null
}

etape_sdk() {
  etape "SDK Android (outils, plateforme ${API}, émulateur)"
  trouver_studio >/dev/null || { erreur "Android Studio absent (Java fourni par Studio)"; return; }
  export JAVA_HOME; JAVA_HOME="$(java_home)"
  local sdkm="$SDK/cmdline-tools/latest/bin/sdkmanager"
  if [ ! -x "$sdkm" ]; then
    local zip="$TELECHARGEMENTS/commandlinetools-mac-${OUTILS_BUILD}.zip"
    curl -fL --retry 3 -o "$zip" "https://dl.google.com/android/repository/commandlinetools-mac_x86_64-${OUTILS_BUILD}_latest.zip" \
      || curl -fL --retry 3 -o "$zip" "https://dl.google.com/android/repository/commandlinetools-mac-${OUTILS_BUILD}_latest.zip" \
      || { erreur "téléchargement des outils en ligne de commande"; return; }
    echo "$OUTILS_SHA  $zip" | shasum -a 256 -c || echo "(empreinte différente : autre build, on continue)"
    local tmp; tmp=$(mktemp -d)
    unzip -q "$zip" -d "$tmp" && mkdir -p "$SDK/cmdline-tools" && rm -rf "$SDK/cmdline-tools/latest" \
      && mv "$tmp/cmdline-tools" "$SDK/cmdline-tools/latest" || { erreur "décompression des outils"; return; }
  fi
  yes | "$sdkm" --sdk_root="$SDK" --licenses >/dev/null
  "$sdkm" --sdk_root="$SDK" --install "platform-tools" "emulator" "platforms;android-${API}" \
    "build-tools;${API}.0.0" "$IMAGE" || { erreur "sdkmanager --install"; return; }
  ok "SDK dans $SDK"
  ajouter_zshrc "export ANDROID_HOME=\"$SDK\""
  ajouter_zshrc 'export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"'
}

etape_avd() {
  etape "Téléphone virtuel Android ($AVD)"
  export JAVA_HOME; JAVA_HOME="$(java_home)"
  local avdm="$SDK/cmdline-tools/latest/bin/avdmanager"
  [ -x "$avdm" ] || { erreur "avdmanager absent (étape sdk)"; return; }
  if "$SDK/emulator/emulator" -list-avds 2>/dev/null | grep -qx "$AVD"; then ok "déjà créé"; return; fi
  echo no | "$avdm" create avd -n "$AVD" -k "$IMAGE" -d pixel_7 || { erreur "création de l'émulateur"; return; }
  ok "émulateur $AVD créé"
}

etape_node() {
  etape "Node.js 22 LTS"
  if [ -x "$DEV/node/bin/node" ]; then ok "déjà installé : $("$DEV/node/bin/node" -v)"; return; fi
  local nom; nom=$(curl -fsL https://nodejs.org/dist/latest-v22.x/ | grep -o 'node-v22[0-9.]*-darwin-x64\.tar\.gz' | head -1)
  [ -n "$nom" ] || { erreur "version de Node introuvable"; return; }
  curl -fL --retry 3 -o "$TELECHARGEMENTS/$nom" "https://nodejs.org/dist/latest-v22.x/$nom" || { erreur "téléchargement de Node"; return; }
  local tmp; tmp=$(mktemp -d)
  tar xzf "$TELECHARGEMENTS/$nom" -C "$tmp" && mv "$tmp"/node-v22* "$DEV/node" || { erreur "décompression de Node"; return; }
  ajouter_zshrc "export PATH=\"$DEV/node/bin:\$PATH\""
  ok "Node $("$DEV/node/bin/node" -v), npm $("$DEV/node/bin/npm" -v)"
}

etape_python() {
  etape "Bibliothèques Python"
  python3 -m pip install --user --upgrade requests pandas openpyxl matplotlib jupyter \
    && ok "$(python3 -c 'import pandas, matplotlib, openpyxl, requests; print("pandas", pandas.__version__, "· matplotlib", matplotlib.__version__)')" \
    || erreur "pip install"
}

etape_ios() {
  etape "Simulateur iPhone (composant iOS de Xcode, ~8 Go)"
  if xcrun simctl list runtimes 2>/dev/null | grep -q "iOS"; then ok "déjà présent"; xcrun simctl list runtimes | grep iOS; return; fi
  xcodebuild -runFirstLaunch 2>&1 | tail -3
  xcodebuild -downloadPlatform iOS || { erreur "téléchargement du simulateur iOS (essayer : Xcode > Réglages > Composants)"; return; }
  ok "$(xcrun simctl list runtimes | grep iOS)"
}

etape_flutter() {
  etape "Flutter : configuration et diagnostic"
  export PATH="$DEV/flutter/bin:$PATH"
  local studio; studio=$(trouver_studio) && flutter config --android-studio-dir "$studio"
  [ -d "$SDK" ] && flutter config --android-sdk "$SDK"
  [ -d "$SDK" ] && { export JAVA_HOME; JAVA_HOME="$(java_home)"; yes | flutter doctor --android-licenses >/dev/null 2>&1; }
  flutter doctor -v
  flutter emulators
}

ETAPES=("$@"); [ ${#ETAPES[@]} -eq 0 ] && ETAPES=(studio sdk avd node python ios flutter)
echo "Journal : $JOURNAL"
for e in "${ETAPES[@]}"; do "etape_$e"; done

etape "Bilan"
if [ ${#ECHECS[@]} -eq 0 ]; then echo "TOUT EST INSTALLÉ"; else printf 'À reprendre : %s\n' "${ECHECS[@]}"; fi
echo "FIN"
