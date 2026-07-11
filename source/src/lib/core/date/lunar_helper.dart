import 'package:lunar/lunar.dart';

/// 农历月日（不含「农历」前缀与年份）：五月十二、闰四月十二。
String lunarMonthDayLabel(DateTime localDate) {
  final lunar = _lunarOf(localDate);
  final leapPrefix = lunar.getMonth() < 0 ? '闰' : '';
  return '$leapPrefix${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}';
}

/// 农历展示文案。
///
/// 默认 `农历五月十二`；[includeYear] 为 true 时 `农历二〇二六年五月十二`。
String lunarDisplayLabel(
  DateTime localDate, {
  bool includeYear = false,
  bool includePrefix = true,
}) {
  final lunar = _lunarOf(localDate);
  final leapPrefix = lunar.getMonth() < 0 ? '闰' : '';
  final body = '$leapPrefix${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}';
  if (includeYear) {
    final withYear = '${lunar.getYearInChinese()}年$body';
    return includePrefix ? '农历$withYear' : withYear;
  }
  return includePrefix ? '农历$body' : body;
}

/// 公历日转农历展示字符串（全局统一中文农历样式）。
String lunarLabelForSolar(DateTime localDate) => lunarDisplayLabel(localDate);

/// 月历格农历日名（初五、十五等）。
String lunarDayShortName(DateTime localDate) {
  return _lunarOf(localDate).getDayInChinese();
}

Lunar _lunarOf(DateTime localDate) {
  final local = DateTime(localDate.year, localDate.month, localDate.day);
  return Solar.fromDate(local).getLunar();
}
