import '../../l10n/app_locale.dart';
import '../../l10n/app_localizations.dart';
import '../hydration/models.dart';

class ReminderSlot {
  const ReminderSlot({
    required this.id,
    required this.title,
    required this.body,
    required this.hour,
    required this.minute,
  });

  final int id;
  final String title;
  final String body;
  final int hour;
  final int minute;
}

class ReminderSchedulePlanner {
  const ReminderSchedulePlanner._();

  static List<ReminderSlot> dailySlots(ReminderPrefs prefs, {AppLocale? locale}) {
    if (!prefs.enabled) return [];
    final l10n = AppLocalizations(locale ?? AppLocale.zh);

    final slots = <ReminderSlot>[
      if (prefs.wakeUp)
        ReminderSlot(
          id: 101,
          title: l10n.notificationTitle('wakeUp'),
          body: l10n.isZh ? '用一杯温水开启新的一天。' : 'Start your day with a gentle sip.',
          hour: prefs.wakeUpHour,
          minute: prefs.wakeUpMinute,
        ),
      if (prefs.beforeMeal)
        ReminderSlot(
          id: 102,
          title: l10n.notificationTitle('beforeMeal'),
          body: l10n.isZh ? '餐前喝一小杯水，保持节奏。' : 'A small glass before eating keeps your rhythm fresh.',
          hour: prefs.beforeMealHour,
          minute: prefs.beforeMealMinute,
        ),
      if (prefs.afterMeal)
        ReminderSlot(
          id: 103,
          title: l10n.notificationTitle('afterMeal'),
          body: l10n.isZh ? '餐后记录一杯清爽饮品。' : 'Log a refreshing drink after your meal.',
          hour: prefs.afterMealHour,
          minute: prefs.afterMealMinute,
        ),
      if (prefs.bedtime)
        ReminderSlot(
          id: 104,
          title: l10n.notificationTitle('bedtime'),
          body: l10n.isZh ? '睡前平静地喝一口水。' : 'One calm sip before winding down.',
          hour: prefs.bedtimeHour,
          minute: prefs.bedtimeMinute,
        ),
    ];

    if (!prefs.muteAtNight) return slots;
    return slots.where((slot) {
      if (slot.hour > prefs.muteEndHour) return true;
      if (slot.hour < prefs.muteEndHour) return false;
      return slot.minute >= prefs.muteEndMinute;
    }).toList();
  }
}
