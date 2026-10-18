#!/usr/bin/env bash
# Installe CocoaPods (nécessaire pour compiler l'app sur iPhone) sans sudo.
# Essaie Homebrew s'il existe, sinon le Ruby du Mac en mode utilisateur.
# Journal : peche_app/build/cocoapods.log
set -uo pipefail
JOURNAL="$(cd "$(dirname "$0")/.." && pwd)/peche_app/build/cocoapods.log"
mkdir -p "$(dirname "$JOURNAL")"
exec > >(tee "$JOURNAL") 2>&1
export LANG=en_US.UTF-8

ajouter_zshrc() {
  touch "$HOME/.zshrc"
  grep -qxF "$1" "$HOME/.zshrc" || { echo "$1" >> "$HOME/.zshrc"; echo "~/.zshrc : $1"; }
}

if command -v pod >/dev/null; then echo "OK : CocoaPods déjà installé ($(pod --version))"; echo FIN; exit 0; fi

if command -v brew >/dev/null; then
  echo "Installation par Homebrew…"
  brew install cocoapods && { echo "OK : $(pod --version)"; echo FIN; exit 0; }
fi

echo "Ruby : $(command -v ruby) $(ruby -v 2>&1)"
echo "RubyGems : $(gem -v 2>&1)"
REP="$(ruby -e 'print Gem.user_dir')"
# Ruby 2.6 du Mac : versions des dépendances compatibles.
if ruby -e 'exit(RUBY_VERSION < "3.0" ? 0 : 1)'; then
  for g in "activesupport:7.0.8.7" "ffi:1.16.3" "securerandom:0.3.2" "drb:2.0.6" "minitest:5.25.1" "public_suffix:5.1.1" "concurrent-ruby:1.3.4" "i18n:1.14.6" "xcodeproj:1.27.0"; do
    gem install --user-install --no-document "${g%%:*}" -v "${g##*:}" || echo "(échec ${g})"
  done
fi
gem install --user-install --no-document cocoapods || { echo "ERREUR : gem install cocoapods"; echo FIN; exit 1; }

ajouter_zshrc "export PATH=\"$REP/bin:\$PATH\""
ajouter_zshrc 'export LANG=en_US.UTF-8'
export PATH="$REP/bin:$PATH"
echo "OK : CocoaPods $(pod --version) dans $REP/bin"
echo "Redémarrer VS Code pour qu'il voie la commande pod."
echo FIN
