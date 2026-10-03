// Worker de la base Drift pour la version web (navigateur).
// Compilé en web/drift_worker.js par tool/preparer_web.sh.
import 'package:drift/wasm.dart';

void main() => WasmDatabase.workerMainForOpen();
