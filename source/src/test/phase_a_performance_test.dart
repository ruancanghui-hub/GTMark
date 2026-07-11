import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/date/calendar_month_service.dart';
import 'package:lianji/core/date/day_info_service.dart';
import 'package:lianji/modules/main/today_controller.dart';

({int medianUs, int maxUs}) _stats(List<int> samples) {
  final sorted = [...samples]..sort();
  return (medianUs: sorted[sorted.length ~/ 2], maxUs: sorted.last);
}

void main() {
  test('Phase A month switching publishes loading within 300ms', () async {
    final controller = TodayController(
      monthLoader: (month) async => CalendarMonthGrid(
        month: DateTime(month.year, month.month),
        cells: const [],
      ),
    );
    final months = List.generate(12, (index) => DateTime(2027, index + 1));

    final samplesUs = <int>[];
    for (final month in months) {
      final stopwatch = Stopwatch()..start();
      controller.setDisplayMonth(month);
      stopwatch.stop();
      samplesUs.add(stopwatch.elapsedMicroseconds);
      expect(controller.displayMonth.value, month);
      expect(controller.monthGrid.value, isNull);
      expect(controller.monthGridLoading.value, isTrue);
      await Future<void>.delayed(Duration.zero);
    }

    final stats = _stats(samplesUs);
    // ignore: avoid_print
    print(
      'PERF month_switch_feedback samples=${samplesUs.length} '
      'median_us=${stats.medianUs} max_us=${stats.maxUs}',
    );
    expect(stats.maxUs, lessThanOrEqualTo(300000));
  });

  test('Phase A DayInfoService local query stays within 500ms', () {
    final dates = List.generate(
      60,
      (index) => DateTime(2026, 1, 1).add(Duration(days: index * 17)),
    );
    final samplesUs = <int>[];

    // One unreported warm-up avoids counting one-time Dart VM initialization.
    DayInfoService.build(DateTime(2026, 7, 18));
    for (final date in dates) {
      final stopwatch = Stopwatch()..start();
      DayInfoService.build(date);
      stopwatch.stop();
      samplesUs.add(stopwatch.elapsedMicroseconds);
    }

    final stats = _stats(samplesUs);
    // ignore: avoid_print
    print(
      'PERF day_info_query samples=${samplesUs.length} '
      'median_us=${stats.medianUs} max_us=${stats.maxUs}',
    );
    expect(stats.maxUs, lessThanOrEqualTo(500000));
  });
}
