import 'holiday_mark.dart';

/// 单日历法摘要（LOOP-001）。
class DayInfo {
  const DayInfo({
    required this.date,
    required this.weekdayLabel,
    required this.lunarLabel,
    required this.lunarDayName,
    required this.ganZhiDay,
    required this.shengXiao,
    required this.chongDesc,
    required this.positionXi,
    required this.positionCai,
    required this.plainYi,
    required this.plainJi,
    required this.holidayMark,
    this.jieQi,
    this.festivalName,
    this.festivalId,
    this.yi = const [],
    this.ji = const [],
    this.isToday = false,
  });

  final DateTime date;
  final String weekdayLabel;
  final String lunarLabel;
  final String lunarDayName;
  final String ganZhiDay;
  final String shengXiao;
  final String chongDesc;
  final String positionXi;
  final String positionCai;
  final String plainYi;
  final String plainJi;
  final HolidayMarkInfo holidayMark;
  final String? jieQi;
  final String? festivalName;
  final String? festivalId;
  final List<String> yi;
  final List<String> ji;
  final bool isToday;

  bool get hasHuangli => yi.isNotEmpty || ji.isNotEmpty;

  String get yiSummary =>
      yi.isEmpty ? '暂无' : yi.take(4).join(' · ');

  String get jiSummary =>
      ji.isEmpty ? '暂无' : ji.take(4).join(' · ');

  /// 月历格第三行：休/班/节日/节气文字（完整显示，不截断）。
  String? get calendarMarkText {
    if (holidayMark.shortLabel != null) return holidayMark.shortLabel;
    if (festivalName != null) return festivalName;
    if (jieQi != null && jieQi!.isNotEmpty) return jieQi;
    return null;
  }
}
