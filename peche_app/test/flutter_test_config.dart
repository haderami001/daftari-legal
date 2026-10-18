import 'dart:async';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

/// Configuration commune à tous les tests de l'application.
///
/// L'écran de test par défaut (800 × 600) est plus bas qu'un téléphone : avec
/// le bandeau d'accueil, les derniers modules sortaient de l'écran. On teste
/// donc sur une surface de 800 × 1400 (points logiques).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUp(() {
    final vue =
        TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first;
    vue.physicalSize = const Size(2400, 4200);
    vue.devicePixelRatio = 3;
  });
  await testMain();
}
