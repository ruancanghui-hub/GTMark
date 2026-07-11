import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/date/lunar_birthday.dart';
import 'package:lianji/core/reminder/personal_reminder.dart';
import 'package:lianji/core/reminder/reminder_kind.dart';
import 'package:lianji/core/reminder/reminder_repeat.dart';
import 'package:lunar/lunar.dart';

void main() {
  test('LunarBirthdayAnchor serializes and converts to solar', () {
    const anchor = LunarBirthdayAnchor(month: 8, day: 3);
    final restored = LunarBirthdayAnchor.deserialize(anchor.serialize());
    expect(restored?.month, 8);
    expect(restored?.day, 3);
    final next = LunarBirthdayCalendar.nextSolarOccurrence(
      anchor,
      DateTime(2026, 1, 1),
    );
    expect(next.year, greaterThanOrEqualTo(2026));
  });

  test('PersonalReminder stores lunar birthday anchor', () {
    final r = PersonalReminder(
      id: '1',
      title: '父亲生日',
      date: DateTime(2026, 9, 14),
      kind: ReminderKind.birthday,
      repeatRule: ReminderRepeatRule.yearlyLunar,
      lunarBirthdayAnchor: const LunarBirthdayAnchor(month: 8, day: 3),
    );
    final restored = PersonalReminder.deserialize(r.serialize());
    expect(restored?.lunarBirthdayAnchor?.month, 8);
    expect(restored?.kind, ReminderKind.birthday);
  });

  test('nearestAnniversary excludes generic events', () {
    final birthday = PersonalReminder(
      id: 'b',
      title: '生日',
      date: DateTime(2026, 12, 1),
      kind: ReminderKind.birthday,
    );
    final event = PersonalReminder(
      id: 'e',
      title: '会议',
      date: DateTime(2026, 12, 1),
      kind: ReminderKind.event,
    );
    expect(birthday.isAnniversaryKind, isTrue);
    expect(event.isAnniversaryKind, isFalse);
  });

  test('闰八月 anchor resolves when lunar year supports', () {
    final lunarYear = Solar.fromDate(DateTime(2020, 8, 1)).getLunar().getYear();
    final hasLeap8 = LunarBirthdayCalendar.monthOptions(lunarYear)
        .any((m) => m.signedMonth == -8);
    if (hasLeap8) {
      const anchor = LunarBirthdayAnchor(month: 8, day: 15, isLeapMonth: true);
      final solar = LunarBirthdayCalendar.solarOnLunarDate(
        lunarYear,
        anchor.signedMonth,
        anchor.day,
      );
      expect(solar, isNotNull);
    }
  });
}
