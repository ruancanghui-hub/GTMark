import 'package:lunar/lunar.dart';

import '../content/content_repository.dart';
import '../content/poem_resolver.dart';
import '../prefs/jichen_prefs.dart';
import 'holiday_mark.dart';
import 'lunar_helper.dart';

/// 月历格轻量数据（不算宜忌黄历，翻月更快）。
class CalendarCellInfo {
  const CalendarCellInfo({
    required this.date,
    required this.inMonth,
    required this.lunarDayName,
    required this.holidayMark,
    this.festivalName,
    this.jieQi,
    this.isToday = false,
  });

  final DateTime date;
  final bool inMonth;
  final String lunarDayName;
  final HolidayMarkInfo holidayMark;
  final String? festivalName;
  final String? jieQi;
  final bool isToday;

  bool get isWeekend =>
      date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

  bool get isFestival => festivalName != null;

  bool get isRestDay => holidayMark.kind == HolidayMarkKind.rest;

  bool get isWorkAdjust => holidayMark.kind == HolidayMarkKind.workAdjust;

  /// 节日 / 节气文案（不含调休「休·节日」类标记）。
  String? get markText {
    if (festivalName != null && festivalName!.isNotEmpty) return festivalName;
    if (jieQi != null && jieQi!.isNotEmpty) return jieQi;
    return null;
  }
}

/// 整月网格（含上下月补位格）。
class CalendarMonthGrid {
  const CalendarMonthGrid({required this.month, required this.cells});

  final DateTime month;
  final List<CalendarCellInfo> cells;
}

/// 按月预计算月历格，供首页缓存复用。
abstract final class CalendarMonthService {
  static const _weekStartSunday = true;
  static const epochYear = 1901;
  static const lastYear = 2049;
  static const monthCount = (lastYear - epochYear + 1) * 12;

  static String monthKey(DateTime month) =>
      '${month.year}-${month.month.toString().padLeft(2, '0')}';

  static int monthToPage(DateTime month) =>
      (month.year - epochYear) * 12 + (month.month - 1);

  static DateTime pageToMonth(int page) {
    final clamped = page.clamp(0, monthCount - 1);
    return DateTime(epochYear + clamped ~/ 12, clamped % 12 + 1);
  }

  static CalendarMonthGrid build(DateTime month, {DateTime? today}) {
    return buildWithSnapshot(
      month,
      today: today,
      festivalNames: ContentRepository.instance.festivalNameSnapshot(),
      xiaonianRegion: JichenPrefs.xiaonianRegion,
    );
  }

  /// 只依赖显式快照的构建入口，供后台 isolate 安全调用。
  static CalendarMonthGrid buildWithSnapshot(
    DateTime month, {
    DateTime? today,
    required Map<String, String> festivalNames,
    required XiaonianRegion xiaonianRegion,
  }) {
    final now = today ?? DateTime.now();
    final todayLocal = DateTime(now.year, now.month, now.day);
    final anchor = DateTime(month.year, month.month);
    final first = DateTime(anchor.year, anchor.month, 1);
    final daysInMonth = DateTime(anchor.year, anchor.month + 1, 0).day;
    final leading = _weekStartSunday ? first.weekday % 7 : (first.weekday - 1);
    final totalCells = ((leading + daysInMonth + 6) ~/ 7) * 7;
    final prevMonthLast = DateTime(anchor.year, anchor.month, 0).day;

    final cells = <CalendarCellInfo>[];
    for (var index = 0; index < totalCells; index++) {
      late final DateTime date;
      late final bool inMonth;

      if (index < leading) {
        final day = prevMonthLast - leading + index + 1;
        final pm = DateTime(anchor.year, anchor.month - 1);
        date = DateTime(pm.year, pm.month, day);
        inMonth = false;
      } else if (index >= leading + daysInMonth) {
        final day = index - leading - daysInMonth + 1;
        final nm = DateTime(anchor.year, anchor.month + 1);
        date = DateTime(nm.year, nm.month, day);
        inMonth = false;
      } else {
        final day = index - leading + 1;
        date = DateTime(anchor.year, anchor.month, day);
        inMonth = true;
      }

      cells.add(
        _buildCell(
          date,
          inMonth: inMonth,
          today: todayLocal,
          festivalNames: festivalNames,
          xiaonianRegion: xiaonianRegion,
        ),
      );
    }

    return CalendarMonthGrid(month: anchor, cells: cells);
  }

  static CalendarCellInfo _buildCell(
    DateTime date, {
    required bool inMonth,
    required DateTime today,
    required Map<String, String> festivalNames,
    required XiaonianRegion xiaonianRegion,
  }) {
    final local = DateTime(date.year, date.month, date.day);
    final lunar = Lunar.fromDate(local);
    final jq = lunar.getJieQi().trim();
    final holidayMark = HolidayMarkService.resolve(local);

    return CalendarCellInfo(
      date: local,
      inMonth: inMonth,
      lunarDayName: lunarDayShortName(local),
      holidayMark: holidayMark,
      festivalName: inMonth
          ? _festivalName(
              local,
              lunar,
              festivalNames: festivalNames,
              xiaonianRegion: xiaonianRegion,
            )
          : null,
      jieQi: inMonth && jq.isNotEmpty ? jq : null,
      isToday: local == today,
    );
  }

  static String? _festivalName(
    DateTime date,
    Lunar lunar, {
    required Map<String, String> festivalNames,
    required XiaonianRegion xiaonianRegion,
  }) {
    final resolvedId = PoemResolver.resolveIdForDate(
      date,
      xiaonianRegion: xiaonianRegion,
    );
    if (resolvedId == 'tf_xiaonian') {
      return PoemResolver.xiaonianDisplayName(date) ?? '小年';
    }
    if (resolvedId != null) {
      final name = festivalNames[resolvedId];
      if (name != null) return name;
    }
    final fs = [...lunar.getFestivals(), ...lunar.getOtherFestivals()];
    if (fs.isNotEmpty) return fs.first;
    return null;
  }
}
