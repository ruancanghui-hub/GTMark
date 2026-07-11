import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lianji/core/date/calendar_month_service.dart';
import 'package:lianji/core/prefs/jichen_prefs.dart';
import 'package:lianji/modules/main/tabs/today_tab.dart';
import 'package:lianji/modules/main/today_controller.dart';

CalendarMonthGrid _grid(DateTime month) => CalendarMonthGrid(
  month: DateTime(month.year, month.month),
  cells: const [],
);

void main() {
  tearDown(Get.reset);

  test(
    'setDisplayMonth publishes month and loading before async grid',
    () async {
      final pending = Completer<CalendarMonthGrid>();
      final controller = TodayController(monthLoader: (_) => pending.future);
      final target = DateTime(2032, 8);

      controller.setDisplayMonth(target);

      expect(controller.displayMonth.value, DateTime(2032, 8));
      expect(controller.monthGrid.value, isNull);
      expect(controller.monthGridLoading.value, isTrue);

      pending.complete(_grid(target));
      await Future<void>.delayed(Duration.zero);
      expect(controller.monthGrid.value?.month, DateTime(2032, 8));
      expect(controller.monthGridLoading.value, isFalse);
    },
  );

  test('failed month load can be retried', () async {
    var attempts = 0;
    final controller = TodayController(
      monthLoader: (month) async {
        attempts++;
        if (attempts == 1) throw StateError('calendar unavailable');
        return _grid(month);
      },
    );

    await Future<void>.delayed(Duration.zero);
    expect(controller.monthGridError.value, isNotNull);

    controller.retryMonthGrid();
    await Future<void>.delayed(Duration.zero);
    expect(attempts, 2);
    expect(controller.monthGrid.value, isNotNull);
    expect(controller.monthGridError.value, isNull);
  });

  test('later month result wins when requests finish out of order', () async {
    final pending = <String, Completer<CalendarMonthGrid>>{};
    final controller = TodayController(
      monthLoader: (month) =>
          (pending[CalendarMonthService.monthKey(month)] ??=
                  Completer<CalendarMonthGrid>())
              .future,
    );
    final first = DateTime(2032, 8);
    final second = DateTime(2032, 9);

    controller.setDisplayMonth(first);
    controller.setDisplayMonth(second);
    pending['2032-09']!.complete(_grid(second));
    await Future<void>.delayed(Duration.zero);
    pending['2032-08']!.complete(_grid(first));
    await Future<void>.delayed(Duration.zero);

    expect(controller.displayMonth.value, second);
    expect(controller.monthGrid.value?.month, second);
    expect(controller.monthGridLoading.value, isFalse);
  });

  test(
    'completed request does not publish after controller disposal',
    () async {
      final pending = Completer<CalendarMonthGrid>();
      final controller = TodayController(monthLoader: (_) => pending.future);
      final beforeGrid = controller.monthGrid.value;
      final beforeLoading = controller.monthGridLoading.value;

      controller.onClose();
      pending.complete(_grid(DateTime.now()));
      await Future<void>.delayed(Duration.zero);

      expect(controller.monthGrid.value, same(beforeGrid));
      expect(controller.monthGridLoading.value, beforeLoading);
    },
  );

  test('preference changes do not reload a deleted controller', () async {
    var loadCount = 0;
    final controller = Get.put(
      TodayController(
        monthLoader: (month) async {
          loadCount++;
          return _grid(month);
        },
      ),
    );
    await Future<void>.delayed(Duration.zero);
    final beforeGrid = controller.monthGrid.value;
    final beforeLoading = controller.monthGridLoading.value;
    final beforeError = controller.monthGridError.value;

    expect(loadCount, 1);
    expect(await Get.delete<TodayController>(), isTrue);

    JichenPrefs.prefsTick.value++;
    await Future<void>.delayed(Duration.zero);

    expect(loadCount, 1);
    expect(controller.monthGrid.value, same(beforeGrid));
    expect(controller.monthGridLoading.value, beforeLoading);
    expect(controller.monthGridError.value, beforeError);
  });

  testWidgets('TodayTab replaces fixed-height loading feedback with grid', (
    tester,
  ) async {
    final pending = Completer<CalendarMonthGrid>();
    Get.put(TodayController(monthLoader: (_) => pending.future));
    await tester.pumpWidget(
      const GetMaterialApp(home: Scaffold(body: TodayTab())),
    );

    expect(find.byKey(const Key('month-grid-loading')), findsOneWidget);
    final slotHeight = tester
        .getSize(find.byKey(const Key('month-grid-slot')))
        .height;
    expect(slotHeight, greaterThanOrEqualTo(300));
    expect(slotHeight, lessThan(470));

    pending.complete(_grid(DateTime.now()));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const Key('month-grid')), findsOneWidget);
    expect(find.byKey(const Key('month-grid-loading')), findsNothing);
  });

  testWidgets('TodayTab exposes retry after month load failure', (
    tester,
  ) async {
    var attempts = 0;
    Get.put(
      TodayController(
        monthLoader: (month) async {
          attempts++;
          if (attempts == 1) throw StateError('failed');
          return _grid(month);
        },
      ),
    );
    await tester.pumpWidget(
      const GetMaterialApp(home: Scaffold(body: TodayTab())),
    );
    await tester.pump();

    expect(find.byKey(const Key('month-grid-error')), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('month-grid-error')),
        matching: find.text('重试'),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(attempts, 2);
    expect(find.byKey(const Key('month-grid')), findsOneWidget);
  });
}
