import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/reminder/personal_reminder.dart';

void main() {
  test('v3 fields round-trip', () {
    final item = PersonalReminder(
      id: 'p1',
      title: '拜访长辈',
      date: DateTime(2026, 7, 8),
      allDay: true,
      category: 'family',
    );
    final restored = PersonalReminder.deserialize(item.serialize())!;
    expect(restored.allDay, isTrue);
    expect(restored.category, 'family');
  });

  test('v2 rows receive safe defaults', () {
    const row = '1\t旧提醒\t2026-07-08\t9\t0\t1\t0\tmanual\t';
    final restored = PersonalReminder.deserialize(row)!;
    expect(restored.allDay, isFalse);
    expect(restored.category, 'general');
  });
}
