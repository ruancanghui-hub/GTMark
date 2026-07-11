import 'reminder_repeat.dart';

/// 提醒/纪念日类型（LOOP-004）。
enum ReminderKind {
  event('事件提醒'),
  birthday('生日'),
  anniversary('纪念日'),
  countdown('倒数日');

  const ReminderKind(this.label);
  final String label;

  static ReminderKind fromName(String? raw) {
    if (raw == null || raw.isEmpty) return ReminderKind.event;
    return ReminderKind.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => ReminderKind.event,
    );
  }

  /// 新建时的默认重复规则。
  ReminderRepeatRule get defaultRepeat {
    switch (this) {
      case ReminderKind.birthday:
        return ReminderRepeatRule.yearlyLunar;
      case ReminderKind.anniversary:
        return ReminderRepeatRule.yearlySolar;
      case ReminderKind.countdown:
      case ReminderKind.event:
        return ReminderRepeatRule.none;
    }
  }
}
