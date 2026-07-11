import '../../core/reminder/personal_reminder.dart';
import '../../core/reminder/reminder_kind.dart';

/// 分享预览页路由参数（LOOP-008）。
enum ShareCardKind {
  dateDetail('日期详情'),
  zeji('择吉推荐'),
  blessing('祝福联动'),
  anniversary('纪念日');

  const ShareCardKind(this.label);
  final String label;
}

class ShareCardArgs {
  const ShareCardArgs({
    required this.date,
    this.kind = ShareCardKind.dateDetail,
    this.matterName,
    this.zejiReason,
    this.yiLabels = const [],
    this.blessingText,
    this.festivalId,
    this.personalPoemId,
    this.daysUntil,
    this.reminderKind,
    this.caption,
  });

  final DateTime date;
  final ShareCardKind kind;
  final String? matterName;
  final String? zejiReason;
  final List<String> yiLabels;
  final String? blessingText;
  final String? festivalId;
  final String? personalPoemId;
  final int? daysUntil;
  final ReminderKind? reminderKind;
  final String? caption;

  factory ShareCardArgs.dateDetail(DateTime date) => ShareCardArgs(
        date: date,
        kind: ShareCardKind.dateDetail,
      );

  factory ShareCardArgs.zeji({
    required DateTime date,
    required String matterName,
    required String reason,
    List<String> yiLabels = const [],
  }) =>
      ShareCardArgs(
        date: date,
        kind: ShareCardKind.zeji,
        matterName: matterName,
        zejiReason: reason,
        yiLabels: yiLabels,
      );

  factory ShareCardArgs.blessing({
    required DateTime date,
    required String blessingText,
    String? festivalId,
  }) =>
      ShareCardArgs(
        date: date,
        kind: ShareCardKind.blessing,
        blessingText: blessingText,
        festivalId: festivalId,
      );

  factory ShareCardArgs.fromReminder(PersonalReminder reminder) {
    final next = reminder.effectiveNextDate();
    return ShareCardArgs(
      date: next,
      kind: ShareCardKind.anniversary,
      matterName: reminder.title,
      personalPoemId: reminder.personalPoemId,
      daysUntil: reminder.daysUntilNext(),
      reminderKind: reminder.kind,
    );
  }

  factory ShareCardArgs.today() => ShareCardArgs(date: DateTime.now());
}
