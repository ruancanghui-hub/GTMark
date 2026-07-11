import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/date/next_reminder_service.dart';

void main() {
  test('nearestEventOrFestival returns future festival within a year', () {
    final next = NextReminderService.nearestEventOrFestival(
      from: DateTime(2026, 1, 5),
    );
    expect(next, isNotNull);
    expect(next!.daysUntil, greaterThan(0));
    expect(next.title, isNotEmpty);
  });
}
