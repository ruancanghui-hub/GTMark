import '../hydration/hydration_store.dart';
import '../hydration/models.dart';
import 'reminder_schedule_planner.dart';

abstract class ReminderNotificationGateway {
  Future<void> cancelAll();

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  });
}

class ReminderNotificationSync {
  const ReminderNotificationSync(this.gateway);

  final ReminderNotificationGateway gateway;

  Future<void> sync(ReminderPrefs prefs) async {
    await gateway.cancelAll();
    for (final slot in ReminderSchedulePlanner.dailySlots(
      prefs,
      locale: HydrationStore.currentLocale(),
    )) {
      await gateway.scheduleDaily(
        id: slot.id,
        title: slot.title,
        body: slot.body,
        hour: slot.hour,
        minute: slot.minute,
      );
    }
  }
}
