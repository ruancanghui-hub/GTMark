import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/content/content_repository.dart';
import '../../core/date/calendar_month_service.dart';
import '../../core/prefs/jichen_prefs.dart';

/// 今日 Tab 状态：月历选中日期、展示月份与月历缓存。
typedef MonthGridLoader = Future<CalendarMonthGrid> Function(DateTime month);

class CalendarMonthBuildRequest {
  const CalendarMonthBuildRequest({
    required this.monthMillisecondsSinceEpoch,
    required this.todayMillisecondsSinceEpoch,
    required this.festivalNames,
    required this.xiaonianRegionStorageKey,
  });

  final int monthMillisecondsSinceEpoch;
  final int todayMillisecondsSinceEpoch;
  final Map<String, String> festivalNames;
  final String xiaonianRegionStorageKey;
}

CalendarMonthGrid _buildMonthGrid(CalendarMonthBuildRequest request) =>
    CalendarMonthService.buildWithSnapshot(
      DateTime.fromMillisecondsSinceEpoch(request.monthMillisecondsSinceEpoch),
      today: DateTime.fromMillisecondsSinceEpoch(
        request.todayMillisecondsSinceEpoch,
      ),
      festivalNames: request.festivalNames,
      xiaonianRegion: XiaonianRegion.fromStorage(
        request.xiaonianRegionStorageKey,
      ),
    );

Future<CalendarMonthGrid> loadCalendarMonthOffMainIsolate(DateTime month) {
  final request = CalendarMonthBuildRequest(
    monthMillisecondsSinceEpoch: DateTime(
      month.year,
      month.month,
    ).millisecondsSinceEpoch,
    todayMillisecondsSinceEpoch: DateTime.now().millisecondsSinceEpoch,
    festivalNames: ContentRepository.instance.festivalNameSnapshot(),
    xiaonianRegionStorageKey: JichenPrefs.xiaonianRegion.storageKey,
  );
  return compute(_buildMonthGrid, request);
}

class TodayController extends GetxController {
  TodayController({MonthGridLoader? monthLoader})
    : _monthLoader = monthLoader ?? loadCalendarMonthOffMainIsolate {
    unawaited(_loadDisplayedMonth());
  }

  final MonthGridLoader _monthLoader;

  @override
  void onInit() {
    super.onInit();
    _prefsWorker = ever(JichenPrefs.prefsTick, (_) => invalidateMonthCache());
  }

  final selectedDate = DateTime.now().obs;
  final displayMonth = DateTime(DateTime.now().year, DateTime.now().month).obs;
  final monthGrid = Rx<CalendarMonthGrid?>(null);
  final monthGridLoading = true.obs;
  final monthGridError = RxnString();

  final _monthCache = <String, CalendarMonthGrid>{};
  Worker? _prefsWorker;
  int _loadGeneration = 0;
  bool _disposed = false;

  @override
  void onClose() {
    _disposed = true;
    _loadGeneration++;
    _prefsWorker?.dispose();
    _prefsWorker = null;
    super.onClose();
  }

  static void _log(String message) {
    if (kDebugMode) debugPrint('[TodayCalendar] $message');
  }

  void invalidateMonthCache() {
    if (_disposed) return;
    _monthCache.clear();
    unawaited(_loadDisplayedMonth());
  }

  Future<void> _loadDisplayedMonth() async {
    if (_disposed) return;
    final generation = ++_loadGeneration;
    final month = displayMonth.value;
    final key = CalendarMonthService.monthKey(month);
    monthGrid.value = null;
    monthGridError.value = null;
    monthGridLoading.value = true;
    final sw = Stopwatch()..start();
    try {
      final cached = _monthCache[key];
      if (cached != null) {
        // Keep loading visible for one frame even on a cache hit so the title
        // change has immediate, truthful feedback instead of a stale grid.
        await Future<void>.delayed(const Duration(milliseconds: 16));
      }
      final grid = cached ?? await _monthLoader(month);
      if (_disposed || generation != _loadGeneration) return;
      _monthCache[key] = grid;
      monthGrid.value = grid;
      _log('load month=$key hit=${cached != null} ${sw.elapsedMilliseconds}ms');
    } catch (error) {
      if (_disposed || generation != _loadGeneration) return;
      monthGridError.value = error.toString();
      _log('load month=$key failed=$error ${sw.elapsedMilliseconds}ms');
    } finally {
      if (!_disposed && generation == _loadGeneration) {
        monthGridLoading.value = false;
      }
    }
  }

  void retryMonthGrid() {
    if (_disposed) return;
    unawaited(_loadDisplayedMonth());
  }

  void selectDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    selectedDate.value = normalized;
    selectedDate.refresh();
    final month = DateTime(normalized.year, normalized.month);
    if (month.year != displayMonth.value.year ||
        month.month != displayMonth.value.month) {
      setDisplayMonth(month);
    }
  }

  void goToday() {
    final now = DateTime.now();
    selectDate(now);
  }

  void setDisplayMonth(DateTime month) {
    final sw = Stopwatch()..start();
    displayMonth.value = DateTime(month.year, month.month);
    unawaited(_loadDisplayedMonth());
    _log(
      'setDisplayMonth ${CalendarMonthService.monthKey(month)} ${sw.elapsedMilliseconds}ms',
    );
  }

  void prevMonth() {
    final m = displayMonth.value;
    setDisplayMonth(DateTime(m.year, m.month - 1));
  }

  void nextMonth() {
    final m = displayMonth.value;
    setDisplayMonth(DateTime(m.year, m.month + 1));
  }

  void goToMonth(DateTime date) {
    setDisplayMonth(DateTime(date.year, date.month));
  }
}
