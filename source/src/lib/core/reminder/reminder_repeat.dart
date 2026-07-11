import 'package:lunar/lunar.dart';

import 'personal_reminder.dart';
import '../date/lunar_birthday.dart';

/// 提醒重复规则（LOOP-003 / SPEC-012 最小集）。
enum ReminderRepeatRule {
  none('不重复'),
  weekly('每周'),
  monthly('每月'),
  yearlySolar('每年（公历）'),
  yearlyLunar('每年（农历）');

  const ReminderRepeatRule(this.label);
  final String label;

  static ReminderRepeatRule fromName(String? raw) {
    if (raw == null || raw.isEmpty) return ReminderRepeatRule.none;
    return ReminderRepeatRule.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => ReminderRepeatRule.none,
    );
  }
}

/// 计算下一次发生日（完成/到期后滚进）。
abstract final class ReminderRepeat {
  static DateTime? nextAfter(PersonalReminder reminder, DateTime from) {
    final base = DateTime(
      reminder.date.year,
      reminder.date.month,
      reminder.date.day,
    );
    switch (reminder.repeatRule) {
      case ReminderRepeatRule.none:
        return null;
      case ReminderRepeatRule.weekly:
        return _nextWeekly(base, from);
      case ReminderRepeatRule.monthly:
        return _nextMonthly(base, from);
      case ReminderRepeatRule.yearlySolar:
        return _nextYearlySolar(base, from);
      case ReminderRepeatRule.yearlyLunar:
        if (reminder.lunarBirthdayAnchor != null) {
          return LunarBirthdayCalendar.nextSolarOccurrence(
            reminder.lunarBirthdayAnchor!,
            from,
          );
        }
        return _nextYearlyLunar(
          base,
          from,
          preferLeap: reminder.lunarLeapPreferred,
        );
    }
  }

  static DateTime _nextWeekly(DateTime base, DateTime from) {
    final baseDay = DateTime(base.year, base.month, base.day);
    final fromDay = DateTime(from.year, from.month, from.day);
    if (!fromDay.isAfter(baseDay)) return baseDay;
    final daysSince = fromDay.difference(baseDay).inDays;
    final weeks = daysSince ~/ 7 + 1;
    return baseDay.add(Duration(days: weeks * 7));
  }

  static DateTime _nextMonthly(DateTime base, DateTime from) {
    var y = from.year;
    var m = from.month;
    final day = base.day;
    for (var i = 0; i < 24; i++) {
      final last = DateTime(y, m + 1, 0).day;
      final candidate = DateTime(y, m, day.clamp(1, last));
      if (candidate.isAfter(from)) return candidate;
      m++;
      if (m > 12) {
        m = 1;
        y++;
      }
    }
    return base.add(const Duration(days: 30));
  }

  static DateTime _nextYearlySolar(DateTime base, DateTime from) {
    var y = from.year;
    final thisYear = DateTime(y, base.month, base.day);
    if (thisYear.isAfter(from)) return thisYear;
    return DateTime(y + 1, base.month, base.day);
  }

  static DateTime _nextYearlyLunar(
    DateTime base,
    DateTime from, {
    required bool preferLeap,
  }) {
    final lunar = Solar.fromDate(base).getLunar();
    final month = lunar.getMonth().abs();
    final day = lunar.getDay();
    final leap = preferLeap || lunar.getMonth() < 0;

    var y = from.year;
    for (var i = 0; i < 3; i++) {
      final solar = _solarForLunar(y, month, day, preferLeap: leap);
      if (solar != null && solar.isAfter(from)) return solar;
      y++;
    }
    return base.add(const Duration(days: 365));
  }

  static DateTime? _solarForLunar(
    int year,
    int month,
    int day, {
    required bool preferLeap,
  }) {
    Solar? solar;
    try {
      if (preferLeap) {
        solar = Lunar.fromYmd(year, -month, day).getSolar();
      } else {
        solar = Lunar.fromYmd(year, month, day).getSolar();
      }
    } catch (_) {
      try {
        solar = Lunar.fromYmd(year, month, day).getSolar();
      } catch (_) {
        return null;
      }
    }
    return DateTime(solar.getYear(), solar.getMonth(), solar.getDay());
  }
}
