import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../app/app_module.dart';
import '../app/app_widget.dart';
import '../core/hydration/hydration_store.dart';
import '../core/reminders/reminder_notifications.dart';

Future<void> appBootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HydrationStore.init();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
  unawaited(_initializeRemindersSafely());
}

Future<void> _initializeRemindersSafely() async {
  try {
    await ReminderNotifications.initialize();
    await ReminderNotifications.sync(HydrationStore.of().reminders);
  } catch (error, stackTrace) {
    debugPrint('Reminder initialization skipped: $error');
    debugPrint('$stackTrace');
  }
}
