import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../app/app_module.dart';
import '../app/app_widget.dart';
import '../core/hydration/hydration_store.dart';

Future<void> appBootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HydrationStore.init();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
