import 'dart:developer' as developer;
import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lianji/main.dart' as app;
import 'package:lianji/modules/main/today_controller.dart';

const _sampleCount = 5;

final class _GateSample {
  const _GateSample({required this.feedbackUs, required this.gridUs});

  final int feedbackUs;
  final int gridUs;
}

int _percentile(List<int> values, double percentile) {
  final sorted = [...values]..sort();
  final rank = (percentile * sorted.length).ceil().clamp(1, sorted.length);
  return sorted[rank - 1];
}

String _summary(String path, List<_GateSample> samples) {
  final feedback = samples.map((sample) => sample.feedbackUs).toList();
  final grid = samples.map((sample) => sample.gridUs).toList();
  return 'PERF month_switch path=$path samples=${samples.length} '
      'feedback_median_us=${_percentile(feedback, 0.5)} '
      'feedback_p95_us=${_percentile(feedback, 0.95)} '
      'feedback_max_us=${_percentile(feedback, 1)} '
      'grid_median_us=${_percentile(grid, 0.5)} '
      'grid_p95_us=${_percentile(grid, 0.95)} '
      'grid_max_us=${_percentile(grid, 1)}';
}

bool _sameMonth(DateTime left, DateTime right) =>
    left.year == right.year && left.month == right.month;

Future<_GateSample> _switchMonth(
  WidgetTester tester,
  TodayController controller,
  DateTime target,
) async {
  int? feedbackRasterUs;
  int? gridRasterUs;
  var actionStartUs = -1;
  int? gridReadyUs;
  Object? timingError;

  void timingsCallback(List<FrameTiming> timings) {
    if (actionStartUs < 0 || timingError != null) return;
    for (final timing in timings) {
      final buildStartUs = timing.timestampInMicroseconds(
        FramePhase.buildStart,
      );
      final rasterFinishUs = timing.timestampInMicroseconds(
        FramePhase.rasterFinish,
      );
      if (buildStartUs < actionStartUs) continue;
      if (rasterFinishUs < buildStartUs || rasterFinishUs < actionStartUs) {
        timingError = StateError(
          'Invalid monotonic frame timing: action=$actionStartUs '
          'buildStart=$buildStartUs rasterFinish=$rasterFinishUs',
        );
        return;
      }
      // setDisplayMonth synchronously publishes the target month and loading
      // state before Dart can begin another frame, so the first post-action
      // frame is the first truthful feedback frame.
      feedbackRasterUs ??= rasterFinishUs;
      final readyUs = gridReadyUs;
      if (readyUs != null && buildStartUs >= readyUs) {
        gridRasterUs ??= rasterFinishUs;
      }
    }
  }

  // Register before the production action so the first eligible frame cannot
  // be missed. Timeline.now and FrameTiming timestamps share the engine's
  // monotonic microsecond clock.
  SchedulerBinding.instance.addTimingsCallback(timingsCallback);
  try {
    actionStartUs = developer.Timeline.now;
    controller.setDisplayMonth(target);

    for (var i = 0; i < 500 && gridReadyUs == null; i++) {
      await tester.pump(const Duration(milliseconds: 4));
      if (timingError != null) throw timingError!;
      final grid = controller.monthGrid.value;
      if (gridReadyUs == null &&
          grid != null &&
          _sameMonth(grid.month, target)) {
        // This observation happens after the just-completed build. Requiring
        // a subsequent frame's buildStart to follow this timestamp proves
        // that the measured raster contains the target grid.
        gridReadyUs = developer.Timeline.now;
      }
    }
    if (gridReadyUs != null) {
      // Render one frame known to contain the ready target grid. The engine
      // may batch FrameTiming delivery for up to one second, so wait only for
      // reporting after the frame; this wait is never part of either metric.
      await tester.pump();
      await Future<void>.delayed(const Duration(seconds: 2));
    }
    if (timingError != null) throw timingError!;
    expect(
      feedbackRasterUs,
      isNotNull,
      reason: 'No post-action feedback FrameTiming was reported',
    );
    expect(
      gridReadyUs,
      isNotNull,
      reason: 'Target month grid did not become ready',
    );
    expect(
      gridRasterUs,
      isNotNull,
      reason: 'No target-grid FrameTiming was reported',
    );
    final feedbackUs = feedbackRasterUs! - actionStartUs;
    final gridUs = gridRasterUs! - actionStartUs;
    expect(feedbackUs, isNonNegative);
    expect(gridUs, isNonNegative);
    return _GateSample(feedbackUs: feedbackUs, gridUs: gridUs);
  } finally {
    SchedulerBinding.instance.removeTimingsCallback(timingsCallback);
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('month switch meets feedback and final-grid raster gates', (
    tester,
  ) async {
    await app.main();
    final homeReady = find.byTooltip('搜索日期');
    for (var i = 0; i < 300 && homeReady.evaluate().isEmpty; i++) {
      final consentButton = find.text('同意并继续');
      if (consentButton.evaluate().isNotEmpty) {
        await tester.tap(consentButton);
      }
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(homeReady, findsOneWidget);

    final controller = Get.find<TodayController>();
    final now = DateTime.now();
    final targets = List.generate(
      _sampleCount,
      (index) => DateTime(now.year, now.month + index + 1),
    );

    // Each distinct target is first loaded on demand, then revisited from the
    // controller cache. Both paths still use the production setDisplayMonth,
    // widget build/layout and engine raster pipeline.
    final onDemand = <_GateSample>[];
    for (final target in targets) {
      onDemand.add(await _switchMonth(tester, controller, target));
    }
    final cached = <_GateSample>[];
    for (final target in targets) {
      cached.add(await _switchMonth(tester, controller, target));
    }

    // ignore: avoid_print
    print(_summary('cross_range_on_demand', onDemand));
    // ignore: avoid_print
    print(_summary('cached', cached));

    for (final sample in [...onDemand, ...cached]) {
      expect(
        sample.feedbackUs,
        lessThanOrEqualTo(300000),
        reason: 'Month title plus loading feedback raster must be <=300ms',
      );
      expect(
        sample.gridUs,
        lessThanOrEqualTo(1500000),
        reason: 'Final month-grid raster must be <=1500ms',
      );
    }
  });
}
