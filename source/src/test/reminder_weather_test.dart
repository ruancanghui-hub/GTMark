import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/reminder/personal_reminder.dart';
import 'package:lianji/core/reminder/reminder_advance.dart';
import 'package:lianji/core/reminder/reminder_kind.dart';
import 'package:lianji/core/reminder/reminder_repeat.dart';
import 'package:lianji/core/weather/weather_day_info.dart';
import 'package:lianji/core/weather/weather_service.dart';

void main() {
  test('WeatherDayInfo air quality risk label', () {
    final info = WeatherDayInfo(
      date: DateTime(2026, 6, 21),
      aqi: 180,
    );
    expect(info.riskLabels, contains('空气差'));
    expect(info.summaryLine, contains('AQI 180'));
  });

  test('PersonalReminder serializes multi advance and kind', () {
    final r = PersonalReminder(
      id: '1',
      title: 'test',
      date: DateTime(2026, 6, 21),
      advanceMinutesList: const [10, 1440],
      repeatRule: ReminderRepeatRule.yearlySolar,
      kind: ReminderKind.birthday,
    );
    final restored = PersonalReminder.deserialize(r.serialize());
    expect(restored?.advanceMinutesList, [10, 1440]);
    expect(restored?.repeatRule, ReminderRepeatRule.yearlySolar);
    expect(restored?.kind, ReminderKind.birthday);
  });

  test('parseAdvanceMinutesList supports comma separated', () {
    expect(parseAdvanceMinutesList('10,1440,60'), [10, 60, 1440]);
    expect(parseAdvanceMinutesList('1440'), [1440]);
  });

  test('ReminderRepeat next yearly solar', () {
    final r = PersonalReminder(
      id: '1',
      title: 'anniversary',
      date: DateTime(2026, 6, 18),
      repeatRule: ReminderRepeatRule.yearlySolar,
    );
    final next = ReminderRepeat.nextAfter(r, DateTime(2026, 6, 19));
    expect(next, DateTime(2027, 6, 18));
  });

  test('ReminderRepeat next weekly anchors base weekday', () {
    final r = PersonalReminder(
      id: '1',
      title: 'weekly',
      date: DateTime(2026, 6, 8),
      repeatRule: ReminderRepeatRule.weekly,
    );
    final next = ReminderRepeat.nextAfter(r, DateTime(2026, 6, 12));
    expect(next, isNotNull);
    expect(next!.weekday, DateTime(2026, 6, 8).weekday);
    expect(next, DateTime(2026, 6, 15));
  });

  test('notifyDateTimesLocal dedupes multi advance', () {
    final r = PersonalReminder(
      id: '1',
      title: 't',
      date: DateTime(2026, 12, 25),
      hour: 9,
      advanceMinutesList: [10, 60, 1440],
    );
    expect(r.notifyDateTimesLocal().length, 3);
  });

  tearDown(() {
    WeatherService.debugOverride = null;
  });
}
