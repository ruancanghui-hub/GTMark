import 'package:flutter_modular/flutter_modular.dart';

import 'mute_at_night_page.dart';
import 'reminder_settings_page.dart';

class ReminderModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const ReminderSettingsPage());
    r.child('/mute', child: (_) => const MuteAtNightPage());
  }
}
