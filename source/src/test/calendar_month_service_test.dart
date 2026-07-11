import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/content/content_repository.dart';
import 'package:lianji/core/content/poem_resolver.dart';
import 'package:lianji/core/date/calendar_month_service.dart';
import 'package:lianji/core/date/day_info_service.dart';
import 'package:lianji/core/prefs/jichen_prefs.dart';
import 'package:lianji/modules/main/today_controller.dart';

const _snapshotPoems = '''
{
  "version": 1,
  "festivals": {
    "tf_duanwu": {
      "name": "龙舟端午佳节",
      "category": "traditional",
      "tone": "festive",
      "poems": [{
        "id": "tf_duanwu-01",
        "text": "端午临中夏。",
        "author": "李隆基",
        "source": "端午",
        "default": true
      }]
    }
  }
}
''';

const _snapshotBlessings = '{"version":1,"templates":{}}';

List<String?> _festivalNames(CalendarMonthGrid grid) => grid.cells
    .where((cell) => cell.inMonth)
    .map((cell) => cell.festivalName)
    .toList(growable: false);

void main() {
  setUp(() async {
    ContentRepository.instance.resetForTest();
    await ContentRepository.instance.init(
      poemsJson: _snapshotPoems,
      blessingsJson: _snapshotBlessings,
    );
    JichenPrefs.xiaonianRegion = XiaonianRegion.both;
  });

  test('CalendarMonthService builds full week rows for June 2026', () {
    final grid = CalendarMonthService.build(DateTime(2026, 6));
    expect(grid.cells.length % 7, 0);
    expect(grid.cells.length, greaterThanOrEqualTo(35));
    final inMonth = grid.cells.where((c) => c.inMonth).length;
    expect(inMonth, 30);
  });

  test('one month build scans each solar term at most once per year', () {
    PoemResolver.debugResetCaches();

    CalendarMonthService.build(DateTime(2026, 6));

    expect(PoemResolver.debugSolarTermScanCount(2026, '清明'), 1);
    expect(PoemResolver.debugSolarTermScanCount(2025, '冬至'), 1);
  });

  test('festival mark is not truncated', () {
    final grid = CalendarMonthService.build(DateTime(2026, 6));
    final duanwu = grid.cells.firstWhere((c) => c.inMonth && c.date.day == 19);
    expect(duanwu.markText, isNotNull);
    expect(duanwu.markText, contains('端午'));
    expect(duanwu.markText!.contains('…'), isFalse);
  });

  test('calendarMarkText uses full festival name', () {
    final info = DayInfoService.build(DateTime(2026, 6, 23));
    if (info.festivalName != null && info.festivalName!.length > 5) {
      expect(info.calendarMarkText, info.festivalName);
    }
  });

  test(
    'production isolate loader preserves repository festival names',
    () async {
      final month = DateTime(2026, 6);

      final mainIsolate = CalendarMonthService.build(month);
      final offMainIsolate = await loadCalendarMonthOffMainIsolate(month);

      expect(_festivalNames(offMainIsolate), _festivalNames(mainIsolate));
      expect(
        offMainIsolate.cells
            .firstWhere((cell) => cell.date.day == 19)
            .festivalName,
        '龙舟端午佳节',
      );
    },
  );

  for (final region in XiaonianRegion.values) {
    test(
      'production isolate loader preserves ${region.storageKey} xiaonian preference',
      () async {
        JichenPrefs.xiaonianRegion = region;
        final month = DateTime(2026, 2);

        final mainIsolate = CalendarMonthService.build(month);
        final offMainIsolate = await loadCalendarMonthOffMainIsolate(month);

        expect(_festivalNames(offMainIsolate), _festivalNames(mainIsolate));
      },
    );
  }
}
