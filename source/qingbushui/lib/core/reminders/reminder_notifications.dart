import '../hydration/models.dart';
import 'local_reminder_notification_gateway.dart';
import 'reminder_notification_sync.dart';

class ReminderNotifications {
  ReminderNotifications._();

  static final _gateway = LocalReminderNotificationGateway.instance;
  static final _sync = ReminderNotificationSync(_gateway);

  static Future<void> initialize() => _gateway.initialize();

  static Future<bool> sync(
    ReminderPrefs prefs, {
    bool requestPermissions = false,
  }) async {
    var permitted = true;
    if (requestPermissions && prefs.enabled) {
      permitted = await _gateway.requestPermissions();
    }
    await _sync.sync(permitted ? prefs : prefs.copyWith(enabled: false));
    return permitted;
  }
}
