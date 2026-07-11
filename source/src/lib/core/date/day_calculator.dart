import 'package:lianji/l10n/gen/app_localizations.dart';

/// 对齐需求：本地日历日差；展示「今天」「第1天」等。
int calculateDays(String isoDate, String type) {
  final target = _startOfLocalDay(DateTime.parse(isoDate));
  final today = _startOfLocalDay(DateTime.now());
  if (type == DayEventType.countup) {
    final diff = today.difference(target).inDays;
    return diff >= 0 ? diff : 0;
  }
  final diff = target.difference(today).inDays;
  return diff >= 0 ? diff : 0;
}

/// 卡片/详情主数字旁说明：今天、第1天、或天数文本（与界面语言一致）。
///
/// 行为：
/// - countdown + 今天是"今天"，未来是"N天"，过去是"N天"（已过天数）
/// - countup + 今天是"第1天"，未来是"第N天"
String dayDisplayLabelLocalized(
  String isoDate,
  String type,
  AppLocalizations l10n,
) {
  final target = _startOfLocalDay(DateTime.parse(isoDate));
  final today = _startOfLocalDay(DateTime.now());
  if (type == DayEventType.countdown) {
    final diff = target.difference(today).inDays;
    if (diff == 0) return l10n.dayLabelToday;
    if (diff < 0) return '${diff.abs()}'; // past countdown: show elapsed days
    return '$diff';
  }
  final diff = today.difference(target).inDays;
  if (diff == 0) return l10n.dayLabelCountupFirst;
  return '${diff + 1}';
}

/// 旧版固定中文；新代码请使用 [dayDisplayLabelLocalized]。
@Deprecated('Use dayDisplayLabelLocalized with AppLocalizations')
String dayDisplayLabel(String isoDate, String type) {
  final target = _startOfLocalDay(DateTime.parse(isoDate));
  final today = _startOfLocalDay(DateTime.now());
  if (type == DayEventType.countdown) {
    final diff = target.difference(today).inDays;
    if (diff == 0) return '今天';
    if (diff < 0) return '0';
    return '$diff';
  }
  final diff = today.difference(target).inDays;
  if (diff == 0) return '第1天';
  return '${diff + 1}';
}

/// 是否用大字展示「今天」「第1天」（非纯数字）
bool isSpecialDayLabel(String isoDate, String type) {
  final target = _startOfLocalDay(DateTime.parse(isoDate));
  final today = _startOfLocalDay(DateTime.now());
  if (type == DayEventType.countdown) {
    return target.difference(today).inDays == 0;
  }
  return today.difference(target).inDays == 0;
}

/// 排序：与今天日历距离（绝对值）升序。
int daysDistanceFromToday(String isoDate) {
  final target = _startOfLocalDay(DateTime.parse(isoDate));
  final today = _startOfLocalDay(DateTime.now());
  return (target.difference(today).inDays).abs();
}

/// 目标日相对「参考日」的本地日历日差：`target - reference`（天）。
/// 用于今日摘要窗口（例如倒计时 0…7 天内）。
int signedCalendarDaysUntilTarget(String isoDate, DateTime referenceDay) {
  final target = _startOfLocalDay(DateTime.parse(isoDate).toLocal());
  final ref = _startOfLocalDay(referenceDay.toLocal());
  return target.difference(ref).inDays;
}

DateTime _startOfLocalDay(DateTime dt) {
  final l = dt.toLocal();
  return DateTime(l.year, l.month, l.day);
}

class DayEventType {
  static const countdown = 'countdown';
  static const countup = 'countup';
}

/// 标准里程碑定义（天）
const _standardMilestones = [
  7,    // 一周
  30,   // 一个月
  100,  // 百日
  365,  // 一周年
  500,  // 500天
  1000, // 千日
  1500,
  2000,
  3650, // 十周年
];

/// 计算距今天数对应的里程碑值。
/// 如果恰好等于一个标准里程碑，返回该值；否则返回最接近的较大标准里程碑。
int calculateMilestone(int days) {
  for (final m in _standardMilestones) {
    if (days <= m) return m;
  }
  // 超过所有标准里程碑，按年递增
  final years = (days / 365).ceil();
  return years * 365;
}

/// 检查是否已达到里程碑。
/// 当 actualDays >= milestone 时返回 i18n 里程碑文本，否则返回 null。
String? milestoneReached(AppLocalizations l10n, int milestone, int actualDays) {
  return actualDays >= milestone ? l10n.milestoneReached : null;
}
