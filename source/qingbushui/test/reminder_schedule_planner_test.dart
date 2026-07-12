import 'package:flutter_test/flutter_test.dart';
import 'package:qingbushui/l10n/app_locale.dart';
import 'package:qingbushui/core/hydration/models.dart';
import 'package:qingbushui/core/reminders/reminder_schedule_planner.dart';

void main() {
  test('disabled reminders produce no daily slots', () {
    final slots = ReminderSchedulePlanner.dailySlots(
      const ReminderPrefs(enabled: false),
    );

    expect(slots, isEmpty);
  });

  test('enabled reminder prefs produce stable daily hydration slots', () {
    final slots = ReminderSchedulePlanner.dailySlots(
      const ReminderPrefs(),
      locale: AppLocale.en,
    );

    expect(slots.map((s) => s.id), [101, 102, 103, 104]);
    expect(slots.map((s) => '${s.hour}:${s.minute}'), [
      '8:0',
      '11:30',
      '13:30',
      '21:30',
    ]);
    expect(slots.map((s) => s.title), [
      "It's time to drink wake-up water",
      'Drink water before meals',
      'Drink water after meals',
      'Drink water before bed',
    ]);
  });

  test('mute at night suppresses slots before the configured end time', () {
    final slots = ReminderSchedulePlanner.dailySlots(
      const ReminderPrefs(muteAtNight: true, muteEndHour: 12),
    );

    expect(slots.map((s) => s.id), [103, 104]);
  });

  test('custom reminder times are used when scheduling daily slots', () {
    final slots = ReminderSchedulePlanner.dailySlots(
      const ReminderPrefs(
        wakeUpHour: 7,
        wakeUpMinute: 15,
        bedtimeHour: 22,
        bedtimeMinute: 45,
      ),
    );

    expect(slots.first.hour, 7);
    expect(slots.first.minute, 15);
    expect(slots.last.hour, 22);
    expect(slots.last.minute, 45);
  });
}
