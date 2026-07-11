import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/content/content_repository.dart';
import 'package:lianji/core/content/poem_resolver.dart';
import 'package:lianji/core/date/calendar_month_service.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    ContentRepository.instance.resetForTest();
    await ContentRepository.instance.init();
  });

  test('diagnostic: repeated distinct month builds', () {
    final elapsedMs = <int>[];
    for (var round = 0; round < 2; round++) {
      for (var month = 1; month <= 12; month++) {
        // A production compute invocation starts in a fresh isolate.
        PoemResolver.debugResetCaches();
        final stopwatch = Stopwatch()..start();
        final grid = CalendarMonthService.build(DateTime(2026, month));
        stopwatch.stop();
        expect(grid.cells.length % 7, 0);
        expect(grid.cells.length, greaterThanOrEqualTo(28));
        elapsedMs.add(stopwatch.elapsedMilliseconds);
      }
    }

    // ignore: avoid_print
    print('PERF CalendarMonthService distinct_month_build_ms=$elapsedMs');
  });
}
