import 'package:flutter_test/flutter_test.dart';
import 'package:qingbushui/core/hydration/models.dart';
import 'package:qingbushui/core/reminders/reminder_notification_sync.dart';

void main() {
  test(
    'sync cancels old notifications before scheduling enabled slots',
    () async {
      final gateway = _FakeReminderGateway();

      await ReminderNotificationSync(gateway).sync(const ReminderPrefs());

      expect(gateway.calls.first, 'cancelAll');
      expect(gateway.scheduledIds, [101, 102, 103, 104]);
    },
  );

  test('sync only cancels when reminders are disabled', () async {
    final gateway = _FakeReminderGateway();

    await ReminderNotificationSync(
      gateway,
    ).sync(const ReminderPrefs(enabled: false));

    expect(gateway.calls, ['cancelAll']);
    expect(gateway.scheduledIds, isEmpty);
  });
}

class _FakeReminderGateway implements ReminderNotificationGateway {
  final calls = <String>[];
  final scheduledIds = <int>[];

  @override
  Future<void> cancelAll() async {
    calls.add('cancelAll');
  }

  @override
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    calls.add('schedule:$id');
    scheduledIds.add(id);
  }
}
