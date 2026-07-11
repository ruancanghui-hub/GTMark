import 'package:lunar/lunar.dart';

/// 农历生日锚点（月日，不含年）。
class LunarBirthdayAnchor {
  const LunarBirthdayAnchor({
    required this.month,
    required this.day,
    this.isLeapMonth = false,
  });

  /// 农历月 1–12（常月序）。
  final int month;
  final int day;
  final bool isLeapMonth;

  int get signedMonth => isLeapMonth ? -month : month;

  String get label {
    final m = Lunar.fromYmd(2020, signedMonth, day.clamp(1, 29));
    return '${m.getMonthInChinese()}月${m.getDayInChinese()}';
  }

  static LunarBirthdayAnchor? fromSolar(DateTime solar) {
    final lunar = Solar.fromDate(solar).getLunar();
    return LunarBirthdayAnchor(
      month: lunar.getMonth().abs(),
      day: lunar.getDay(),
      isLeapMonth: lunar.getMonth() < 0,
    );
  }

  static LunarBirthdayAnchor? deserialize(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final p = raw.split(':');
    if (p.length != 3) return null;
    final month = int.tryParse(p[0]);
    final day = int.tryParse(p[1]);
    if (month == null || day == null) return null;
    return LunarBirthdayAnchor(
      month: month,
      day: day,
      isLeapMonth: p[2] == '1',
    );
  }

  String serialize() => '$month:$day:${isLeapMonth ? 1 : 0}';
}

/// 农历生日 ↔ 公历换算（LOOP-004）。
abstract final class LunarBirthdayCalendar {
  static int referenceLunarYear([DateTime? from]) {
    final d = from ?? DateTime.now();
    return Solar.fromDate(d).getLunar().getYear();
  }

  /// 给定农历年的可选月份（含闰月）。
  static List<({int signedMonth, String label, int dayCount})> monthOptions(
    int lunarYear,
  ) {
    final months = LunarYear.fromYear(lunarYear).getMonths();
    return months.map((m) {
      final signed = m.getMonth();
      final leap = signed < 0;
      final sample = Lunar.fromYmd(lunarYear, signed, 1);
      final name = sample.getMonthInChinese();
      final label = leap ? '闰$name' : name;
      return (
        signedMonth: signed,
        label: '$label月',
        dayCount: m.getDayCount(),
      );
    }).toList();
  }

  static DateTime? solarOnLunarDate(
    int lunarYear,
    int signedMonth,
    int day,
  ) {
    try {
      final s = Lunar.fromYmd(lunarYear, signedMonth, day).getSolar();
      return DateTime(s.getYear(), s.getMonth(), s.getDay());
    } catch (_) {
      return null;
    }
  }

  /// 下一次公历发生日（含当天）。
  static DateTime nextSolarOccurrence(
    LunarBirthdayAnchor anchor,
    DateTime from,
  ) {
    final base = DateTime(from.year, from.month, from.day);
    final startLunarYear = Solar.fromDate(base).getLunar().getYear();
    for (var i = 0; i < 4; i++) {
      final dt = solarOnLunarDate(
        startLunarYear + i,
        anchor.signedMonth,
        anchor.day,
      );
      if (dt != null && !dt.isBefore(base)) return dt;
    }
    return base;
  }

  static String solarCaption(LunarBirthdayAnchor anchor, DateTime from) {
    final next = nextSolarOccurrence(anchor, from);
    return '对应今年公历 ${next.year}年${next.month}月${next.day}日';
  }
}
