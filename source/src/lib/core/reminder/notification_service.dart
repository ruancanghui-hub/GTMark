import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../prefs/jichen_prefs.dart';
import 'personal_reminder.dart';
import 'reminder_advance.dart';

/// 本地通知（权限失败不阻断提醒保存；支持多提前量）。
abstract final class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Shanghai'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: darwin, macOS: darwin),
    );
    _initialized = true;
  }

  static int notificationId(String reminderId, int advanceMinutes) =>
      Object.hash(reminderId, advanceMinutes);

  static Future<bool> hasPermission() async {
    if (Platform.isMacOS || Platform.isIOS) {
      final impl = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (impl != null) {
        final ok = await impl.checkPermissions();
        return ok?.isEnabled ?? false;
      }
      final mac = _plugin.resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>();
      if (mac != null) {
        final ok = await mac.checkPermissions();
        return ok?.isEnabled ?? false;
      }
    }
    if (Platform.isAndroid) {
      return await Permission.notification.isGranted;
    }
    return true;
  }

  static Future<bool> requestPermission() async {
    if (!JichenPrefs.notifyMasterEnabled) return false;
    if (Platform.isAndroid) {
      final s = await Permission.notification.request();
      return s.isGranted;
    }
    if (Platform.isIOS) {
      final impl = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final ok = await impl?.requestPermissions(alert: true, badge: true);
      return ok ?? false;
    }
    if (Platform.isMacOS) {
      final mac = _plugin.resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>();
      final ok = await mac?.requestPermissions(alert: true, badge: true);
      return ok ?? false;
    }
    return true;
  }

  /// 保存提醒时尝试调度所有提前量；任一成功即返回 true。
  static Future<bool> scheduleIfAllowed(PersonalReminder reminder) async {
    if (!reminder.notifyEnabled || !JichenPrefs.notifyMasterEnabled) {
      return false;
    }
    final granted = await hasPermission() || await requestPermission();
    if (!granted) return false;

    await cancel(reminder);
    final now = tz.TZDateTime.now(tz.local);
    var anyScheduled = false;

    for (final fireAt in reminder.notifyDateTimesLocal()) {
      final scheduled = tz.TZDateTime.from(fireAt, tz.local);
      if (scheduled.isBefore(now)) continue;
      final next = reminder.effectiveNextDate();
      final eventAt = DateTime(
        next.year,
        next.month,
        next.day,
        reminder.hour,
        reminder.minute,
      );
      final advance = eventAt.difference(fireAt).inMinutes;
      final body = advance > 0
          ? '${reminder.note ?? '吉辰万年历提醒'} · ${kAdvanceMinuteOptions[advance] ?? '提前 $advance 分钟'}'
          : (reminder.note ?? '吉辰万年历提醒');

      await _plugin.zonedSchedule(
        notificationId(reminder.id, advance),
        reminder.title,
        body,
        scheduled,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(),
          macOS: DarwinNotificationDetails(),
          android: AndroidNotificationDetails(
            'jichen_reminders',
            '事件提醒',
            channelDescription: '吉辰万年历重要日期提醒',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      anyScheduled = true;
    }
    return anyScheduled;
  }

  static Future<void> cancel(PersonalReminder reminder) async {
    if (!_initialized) return;
    for (final adv in {
      ...allAdvanceSlotKeys(),
      ...reminder.advanceMinutesList,
    }) {
      await _plugin.cancel(notificationId(reminder.id, adv));
    }
    await _plugin.cancel(reminder.id.hashCode);
  }
}
