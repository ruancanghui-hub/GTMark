import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/reminder/personal_reminder.dart';
import 'package:lianji/core/reminder/reminder_kind.dart';
import 'package:lianji/core/reminder/reminder_repeat.dart';

void main() {
  test('groupOfReminder rolls yearly solar into future after stored date', () {
    final r = PersonalReminder(
      id: '1',
      title: '结婚纪念日',
      date: DateTime(2020, 6, 1),
      kind: ReminderKind.anniversary,
      repeatRule: ReminderRepeatRule.yearlySolar,
    );
    final from = DateTime(2026, 6, 21);
    expect(groupOfReminder(r), ReminderGroup.future);
    expect(r.effectiveNextDate(from), DateTime(2027, 6, 1));
  });

  test('notifyDateTimesLocal uses effective next date for yearly repeat', () {
    final r = PersonalReminder(
      id: '2',
      title: '结婚纪念日',
      date: DateTime(2020, 6, 1),
      kind: ReminderKind.anniversary,
      repeatRule: ReminderRepeatRule.yearlySolar,
      advanceMinutesList: [0],
    );
    final from = DateTime(2026, 6, 21);
    final next = r.effectiveNextDate(from);
    final slots = r.notifyDateTimesLocal(from);
    final latest = slots.reduce((a, b) => a.isAfter(b) ? a : b);
    expect(latest.year, next.year);
    expect(latest.month, next.month);
    expect(latest.day, next.day);
    expect(latest.hour, r.hour);
  });

  test('one-shot past reminder stays in past group', () {
    final r = PersonalReminder(
      id: '3',
      title: '过期事件',
      date: DateTime(2020, 1, 1),
      kind: ReminderKind.event,
    );
    expect(groupOfReminder(r), ReminderGroup.past);
  });
}
