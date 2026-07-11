import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/date/lunar_helper.dart';

void main() {
  test('公历日转农历五月十二样式（含农历前缀）', () {
    final date = DateTime(2026, 5, 12);
    expect(lunarDisplayLabel(date), '农历三月廿六');
    expect(lunarLabelForSolar(date), '农历三月廿六');
    expect(lunarMonthDayLabel(date), '三月廿六');
    expect(lunarDisplayLabel(date, includePrefix: false), '三月廿六');
  });

  test('含年份的农历展示', () {
    final date = DateTime(2026, 5, 12);
    expect(
      lunarDisplayLabel(date, includeYear: true),
      '农历二〇二六年三月廿六',
    );
  });

  test('不再输出 Lunar Y-M-D 数字格式', () {
    final date = DateTime(2026, 5, 12);
    expect(lunarLabelForSolar(date), isNot(contains('Lunar')));
    expect(lunarLabelForSolar(date), startsWith('农历'));
  });

  test('月历格农历日名', () {
    expect(lunarDayShortName(DateTime(2026, 5, 12)), '廿六');
  });
}
