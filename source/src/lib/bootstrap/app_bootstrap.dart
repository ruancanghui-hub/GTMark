import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../app/app_module.dart';
import '../app/app_widget.dart';
import '../core/account/supabase_env.dart';
import '../core/content/content_repository.dart';
import '../core/prefs/festival_reminder_prefs.dart';
import '../core/prefs/jichen_prefs.dart';
import '../core/reminder/notification_service.dart';
import '../infra/storage/hive_init.dart';
import '../shared/utils/sp_utils.dart';

Future<void> appBootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtils.getInstance();
  if (SupabaseEnv.isConfigured) {
    await Supabase.initialize(
      url: SupabaseEnv.url,
      publishableKey: SupabaseEnv.anonKey,
    );
  }
  await JichenPrefs.load();
  FestivalReminderPrefs.load();
  await NotificationService.init();
  await initHive();
  await ContentRepository.instance.init();

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
