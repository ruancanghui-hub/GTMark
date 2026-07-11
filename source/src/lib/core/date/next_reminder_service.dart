import '../content/poem_resolver.dart';
import '../prefs/festival_reminder_prefs.dart';
import '../reminder/personal_reminder.dart';
import '../reminder/reminder_kind.dart';
import '../reminder/reminder_store.dart';
import 'day_info_service.dart';

/// 下一条 / 最近纪念日预览（LOOP-001 / LOOP-004）。
class NextReminderPreview {
  const NextReminderPreview({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.daysUntil,
    this.isPersonal = false,
    this.kind,
    this.personalReminder,
  });

  final String title;
  final String subtitle;
  final DateTime date;
  final int daysUntil;
  final bool isPersonal;
  final ReminderKind? kind;
  final PersonalReminder? personalReminder;
}

abstract final class NextReminderService {
  static DateTime _baseDay(DateTime? from) {
    final now = from ?? DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 最近生日 / 纪念日 / 倒数日（独立卡片）。
  static NextReminderPreview? nearestAnniversary({DateTime? from}) {
    final base = _baseDay(from);
    NextReminderPreview? best;
    for (final r in ReminderStore.loadAll()) {
      if (r.completed || !r.isAnniversaryKind) continue;
      final days = r.daysUntilNext(base);
      if (days < 0 || days > 30) continue;
      if (best == null || days < best.daysUntil) {
        best = _previewFrom(r, base, days);
      }
    }
    return best;
  }

  /// 下一条事件提醒或内置节日（不含纪念日类）。
  static NextReminderPreview? nearestEventOrFestival({DateTime? from}) {
    final base = _baseDay(from);

    NextReminderPreview? bestEvent;
    for (final r in ReminderStore.loadAll()) {
      if (r.completed || r.isAnniversaryKind) continue;
      final days = r.daysUntilNext(base);
      if (days < 0) continue;
      if (bestEvent == null || days < bestEvent.daysUntil) {
        bestEvent = _previewFrom(r, base, days);
      }
    }
    if (bestEvent != null) return bestEvent;

    for (var offset = 1; offset <= 366; offset++) {
      final d = base.add(Duration(days: offset));
      final id = PoemResolver.resolveIdForDate(d);
      if (id == null || !FestivalReminderPrefs.entries.containsKey(id)) {
        continue;
      }
      if (!FestivalReminderPrefs.isEnabled(id)) continue;
      final info = DayInfoService.build(d);
      return NextReminderPreview(
        title: FestivalReminderPrefs.entries[id]!,
        subtitle: info.festivalName ?? info.lunarLabel,
        date: d,
        daysUntil: offset,
      );
    }
    return null;
  }

  /// 兼容旧调用。
  static NextReminderPreview? nearest({DateTime? from}) =>
      nearestEventOrFestival(from: from);

  static NextReminderPreview _previewFrom(
    PersonalReminder r,
    DateTime base,
    int days,
  ) {
    final next = r.effectiveNextDate(base);
    final info = DayInfoService.build(next);
    final lunarPart = r.lunarBirthdayAnchor != null
        ? '农历${r.lunarBirthdayAnchor!.label}'
        : info.lunarLabel;
    final subtitle = switch (r.kind) {
      ReminderKind.birthday => '$lunarPart · 对应 ${next.year}/${next.month}/${next.day}',
      ReminderKind.countdown => '倒数日 · $lunarPart',
      ReminderKind.anniversary => '纪念日 · $lunarPart',
      ReminderKind.event => info.lunarLabel,
    };
    return NextReminderPreview(
      title: r.title,
      subtitle: subtitle,
      date: next,
      daysUntil: days,
      isPersonal: true,
      kind: r.kind,
      personalReminder: r,
    );
  }
}
