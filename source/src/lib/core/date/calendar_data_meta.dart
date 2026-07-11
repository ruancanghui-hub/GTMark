/// 历法与节假日数据口径（SPEC-019）。
abstract final class CalendarDataMeta {
  static const huangliSource = '传统黄历 · lunar 1.7.8';
  static const holidaySource = '国务院法定节假日 · lunar 1.7.8';
  static const holidayDataThroughYear = 2026;

  static String huangliUpdatedAt(DateTime date) =>
      '$huangliSource · 本地计算 · ${date.year}';

  static String holidayUpdatedAt() =>
      '$holidaySource · 数据至 $holidayDataThroughYear 年';
}
