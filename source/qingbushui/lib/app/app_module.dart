import 'package:flutter_modular/flutter_modular.dart';

import '../core/hydration/hydration_store.dart';
import '../modules/drink/drink_module.dart';
import '../modules/main/main_module.dart';
import '../modules/onboarding/onboarding_module.dart';
import '../modules/record/record_module.dart';
import '../modules/reminders/reminder_module.dart';
import '../modules/splash/splash_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<HydrationStore>(HydrationStore.new);
  }

  @override
  void routes(r) {
    r.redirect('/', to: '/splash/');
    r.module('/splash', module: SplashModule());
    r.module('/onboarding', module: OnboardingModule());
    r.module('/main', module: MainModule());
    r.module('/record', module: RecordModule());
    r.module('/drink', module: DrinkModule());
    r.module('/reminders', module: ReminderModule());
  }
}
