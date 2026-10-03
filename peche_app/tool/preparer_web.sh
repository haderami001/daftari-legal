#!/usr/bin/env bash
# Prépare les fichiers nécessaires à la base SQLite dans le navigateur :
#   web/sqlite3.wasm   : SQLite compilé en WebAssembly (même version que
#                        le package Dart « sqlite3 » du pubspec.lock)
#   web/drift_worker.js : le worker Drift compilé depuis tool/drift_worker.dart
#   web/pdfjs/          : pdf.js (aperçu des rapports PDF), servi avec l'app
#                        au lieu d'un CDN : l'aperçu marche aussi hors ligne
# Usage (depuis peche_app/) : ./tool/preparer_web.sh && flutter build web
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(awk '/^  sqlite3:$/{f=1} f&&/version:/{gsub(/"/,"",$2);print $2;exit}' pubspec.lock)
echo "sqlite3 ${version}"
curl -sSfL -o web/sqlite3.wasm \
  "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-${version}/sqlite3.wasm"
dart compile js -O4 tool/drift_worker.dart -o web/drift_worker.js
rm -f web/drift_worker.js.deps web/drift_worker.js.map

# Version de pdf.js attendue par le package « printing ».
pdfjs=3.2.146
mkdir -p web/pdfjs
curl -sSfL "https://registry.npmjs.org/pdfjs-dist/-/pdfjs-dist-${pdfjs}.tgz" \
  | tar xz -C web/pdfjs --strip-components=2 \
      package/build/pdf.min.js package/build/pdf.worker.min.js
echo "OK : web/sqlite3.wasm, web/drift_worker.js et web/pdfjs/"
