import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/date/day_info_service.dart';
import 'package:lianji/core/date/holiday_mark.dart';
import 'package:lianji/core/prefs/jichen_prefs.dart';

void main() {
  tearDown(() {
    DayInfoService.debugForceHuangliEmpty = false;
    JichenPrefs.xiaonianRegion = XiaonianRegion.both;
  });

  test('build includes lunar day name and shengxiao', () {
    final info = DayInfoService.build(DateTime(2026, 6, 21));
    expect(info.lunarDayName, isNotEmpty);
    expect(info.shengXiao, isNotEmpty);
    expect(info.chongDesc, isNotEmpty);
    expect(info.positionXi, isNotEmpty);
    expect(info.plainYi, contains('宜'));
    expect(info.weekdayLabel, '周日');
  });

  test('statutory rest day mark', () {
    final info = DayInfoService.build(DateTime(2026, 1, 1));
    expect(info.holidayMark.kind, HolidayMarkKind.rest);
    expect(info.holidayMark.shortLabel, contains('休'));
  });

  test('work adjust day mark exists in 2026', () {
    HolidayMarkInfo? mark;
    for (var d = 1; d <= 365; d++) {
      final date = DateTime(2026, 1, 1).add(Duration(days: d - 1));
      final m = DayInfoService.build(date).holidayMark;
      if (m.kind == HolidayMarkKind.workAdjust) {
        mark = m;
        break;
      }
    }
    expect(mark, isNotNull);
    expect(mark!.shortLabel, contains('班'));
  });

  test('huangli degraded when forced empty', () {
    DayInfoService.debugForceHuangliEmpty = true;
    final info = DayInfoService.build(DateTime(2026, 6, 21));
    expect(info.hasHuangli, isFalse);
  });

  test('xiaonian prefs change rebuilds festival name path', () {
    JichenPrefs.xiaonianRegion = XiaonianRegion.north;
    final info = DayInfoService.build(DateTime(2026, 2, 10));
    expect(info.lunarDayName, isNotEmpty);
  });
}
