import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lianji/core/date/calendar_month_service.dart';
import 'package:lianji/core/date/day_info_service.dart';
import 'package:lianji/core/date/holiday_mark.dart';
import 'package:lianji/modules/date_detail/date_search_sheet.dart';
import 'package:lianji/modules/main/main_controller.dart';
import 'package:lianji/modules/main/tabs/today_tab.dart';
import 'package:lianji/modules/main/today_controller.dart';
import 'package:lianji/shared/utils/sp_utils.dart';
import 'package:lianji/widgets/month_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpCalendarHome(
  WidgetTester tester, {
  required DateTime month,
  double width = 390,
}) async {
  tester.view.physicalSize = Size(width, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  Get.reset();
  final controller = Get.put(
    TodayController(
      monthLoader: (value) async => CalendarMonthService.build(value),
    ),
  );
  controller.selectDate(DateTime(month.year, month.month, 1));
  await tester.pumpWidget(
    const GetMaterialApp(home: Scaffold(body: TodayTab())),
  );
  for (var i = 0; i < 200; i++) {
    await tester.pump(const Duration(milliseconds: 10));
    if (find.byKey(const Key('month-grid')).evaluate().isNotEmpty) break;
  }
  expect(find.byKey(const Key('month-grid')), findsOneWidget);
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtils.getInstance();
    await SpUtils.clear();
  });

  testWidgets('MonthCalendar shows lunar day name', (tester) async {
    final grid = CalendarMonthService.build(DateTime(2026, 6));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: MonthCalendar(
              grid: grid,
              selected: DateTime(2026, 6, 21),
              onSelect: (_) {},
            ),
          ),
        ),
      ),
    );
    final info = DayInfoService.build(DateTime(2026, 6, 21));
    expect(find.text(info.lunarDayName), findsOneWidget);
    expect(find.text('21'), findsOneWidget);
  });

  testWidgets('MonthCalendar exposes each in-month date as a labeled button', (
    tester,
  ) async {
    final grid = CalendarMonthService.build(DateTime(2026, 6));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: MonthCalendar(
              grid: grid,
              selected: DateTime(2026, 6, 21),
              onSelect: (_) {},
            ),
          ),
        ),
      ),
    );

    final date = find.bySemanticsLabel(RegExp(r'^2026年6月21日，农历'));
    expect(date, findsOneWidget);
    final semantics = tester.getSemantics(date);
    expect(semantics.flagsCollection.isButton, isTrue);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
  });

  testWidgets('DateSearchSheet rejects invalid input', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (ctx) => Scaffold(
            body: TextButton(
              onPressed: () => showDateSearchSheet(ctx),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '2026-13-01');
    await tester.tap(find.text('跳转'));
    await tester.pump();

    expect(find.textContaining('格式无效'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('calendar home search changes date only for valid input', (
    tester,
  ) async {
    await pumpCalendarHome(tester, month: DateTime(2026, 7));
    final controller = Get.find<TodayController>();

    await tester.tap(find.byTooltip('搜索日期'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '2026-13-01');
    await tester.tap(find.text('跳转'));
    await tester.pump();

    expect(controller.selectedDate.value, DateTime(2026, 7, 1));
    expect(find.textContaining('格式无效'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '2026-08-18');
    await tester.tap(find.text('跳转'));
    await tester.pumpAndSettle();

    expect(controller.selectedDate.value, DateTime(2026, 8, 18));
  });

  testWidgets('date semantics includes every available calendar marker', (
    tester,
  ) async {
    final date = DateTime(2026, 10, 1);
    final grid = CalendarMonthGrid(
      month: DateTime(2026, 10),
      cells: [
        CalendarCellInfo(
          date: date,
          inMonth: true,
          lunarDayName: '八月廿一',
          holidayMark: const HolidayMarkInfo(
            kind: HolidayMarkKind.rest,
            name: '国庆节',
          ),
          festivalName: '中秋节',
          jieQi: '寒露',
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MonthCalendar(
            grid: grid,
            selected: date,
            planDateKeys: const {'2026-10-01'},
            onSelect: (_) {},
          ),
        ),
      ),
    );

    expect(
      find.bySemanticsLabel('2026年10月1日，农历八月廿一，节日中秋节，节气寒露，休，国庆节，有计划'),
      findsOneWidget,
    );
  });

  testWidgets('selecting a date updates summary and plus prefill', (
    tester,
  ) async {
    await pumpCalendarHome(tester, month: DateTime(2026, 7));
    await tester.tap(find.text('18').first);
    await tester.pump();

    expect(find.textContaining('7月18日'), findsOneWidget);
    await tester.tap(find.byTooltip('为所选日期添加计划'));
    await tester.pumpAndSettle();
    expect(find.textContaining('2026年7月18日'), findsOneWidget);
  });

  testWidgets('calendar renders a marker for dates with plans', (tester) async {
    final grid = CalendarMonthService.build(DateTime(2026, 7));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: MonthCalendar(
              grid: grid,
              selected: DateTime(2026, 7, 1),
              planDateKeys: const {'2026-07-18'},
              onSelect: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('plan-marker-2026-07-18')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('calendar home has no overflow at 360px', (tester) async {
    await pumpCalendarHome(tester, month: DateTime(2026, 7), width: 360);
    expect(find.text('2026年 7月'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('calendar home swipes horizontally between months', (
    tester,
  ) async {
    await pumpCalendarHome(tester, month: DateTime(2026, 7));

    await tester.drag(
      find.byKey(const Key('month-grid-slot')),
      const Offset(-260, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('2026年 8月'), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('month-grid-slot')),
      const Offset(260, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('2026年 7月'), findsOneWidget);
  });

  testWidgets('首页查吉日入口切换到择吉 Tab', (tester) async {
    await pumpCalendarHome(tester, month: DateTime(2026, 7), width: 360);
    final mainController = Get.put(MainController());

    await tester.drag(find.byType(ListView).first, const Offset(0, -900));
    await tester.pump();
    expect(find.text('查吉日'), findsOneWidget);
    await tester.tap(find.text('查吉日'));
    await tester.pump();

    expect(mainController.currentIndex.value, 1);
    expect(tester.takeException(), isNull);
  });
}
