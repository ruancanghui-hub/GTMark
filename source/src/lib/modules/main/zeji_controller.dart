import 'package:get/get.dart';

import '../../core/prefs/jichen_prefs.dart';
import '../../core/weather/weather_day_info.dart';
import '../../core/weather/weather_service.dart';
import '../../core/zeji/zeji_engine.dart';
import '../../core/zeji/zeji_matter.dart';
import '../../core/zeji/zeji_result.dart';

/// 择吉 Tab 状态（LOOP-002）。
class ZejiController extends GetxController {
  final matterIds = <String>['MAT-01'].obs;
  final rangePreset = ZejiRangePreset.days30.obs;
  final customStart = DateTime.now().obs;
  final customEnd = DateTime.now().add(const Duration(days: 29)).obs;
  final weekendOnly = false.obs;
  final ignoreWeather = false.obs;
  final loading = false.obs;
  final errorMessage = RxnString();
  final lastResult = Rxn<ZejiSearchResult>();
  final hasSearched = false.obs;
  static const Duration _minimumLoadingDuration = Duration(milliseconds: 520);

  String get primaryMatterId =>
      matterIds.isNotEmpty ? matterIds.first : 'MAT-01';

  ZejiMatter get matter => ZejiMatter.byId(primaryMatterId);

  List<ZejiMatter> get selectedMatters =>
      matterIds.map(ZejiMatter.byId).toList(growable: false);

  String get matterDescription {
    if (matterIds.length <= 1) {
      return matter.description;
    }
    final names = selectedMatters.map((m) => m.name).join('、');
    return '已选 $names；将合并各事项宜忌后推荐吉日。';
  }

  String get matterResultLabel {
    if (matterIds.length <= 1) return matter.name;
    return selectedMatters.map((m) => m.name).join('、');
  }

  bool isMatterSelected(String id) => matterIds.contains(id);

  ZejiQuery buildQuery({String? overrideMatterId}) {
    final id = overrideMatterId ?? primaryMatterId;
    final skip = JichenPrefs.skipWorkdayAdjust;
    switch (rangePreset.value) {
      case ZejiRangePreset.days7:
        return ZejiQuery.preset7(
          matterId: id,
          skipWorkdayAdjust: skip,
          weekendOnly: weekendOnly.value,
        ).copyWith(ignoreWeather: ignoreWeather.value);
      case ZejiRangePreset.days30:
        return ZejiQuery.preset30(
          matterId: id,
          skipWorkdayAdjust: skip,
          weekendOnly: weekendOnly.value,
        ).copyWith(ignoreWeather: ignoreWeather.value);
      case ZejiRangePreset.custom:
        return ZejiQuery(
          matterId: id,
          start: DateTime(
            customStart.value.year,
            customStart.value.month,
            customStart.value.day,
          ),
          end: DateTime(
            customEnd.value.year,
            customEnd.value.month,
            customEnd.value.day,
          ),
          skipWorkdayAdjust: skip,
          weekendOnly: weekendOnly.value,
          ignoreWeather: ignoreWeather.value,
        );
    }
  }

  Future<void> search({ZejiQuery? query}) async {
    if (query != null) {
      await _runSingleSearch(query);
      return;
    }

    if (matterIds.length <= 1) {
      await _runSingleSearch(buildQuery());
      return;
    }

    await _runMergedSearch();
  }

  Future<void> _runSingleSearch(ZejiQuery q) async {
    final validation = ZejiQuery.validateRange(q.start, q.end);
    if (validation != null) {
      errorMessage.value = validation;
      lastResult.value = null;
      hasSearched.value = true;
      return;
    }

    loading.value = true;
    errorMessage.value = null;
    final loadingStartedAt = DateTime.now();

    try {
      final weatherMap = await _loadWeather(q);
      final result = ZejiEngine.search(q, weatherByDate: weatherMap);
      lastResult.value = result;
      hasSearched.value = true;
    } catch (e) {
      errorMessage.value = '计算异常，请重试（已保留筛选条件）';
    } finally {
      await _keepLoadingVisibleSince(loadingStartedAt);
      loading.value = false;
    }
  }

  Future<void> _runMergedSearch() async {
    final base = buildQuery();
    final validation = ZejiQuery.validateRange(base.start, base.end);
    if (validation != null) {
      errorMessage.value = validation;
      lastResult.value = null;
      hasSearched.value = true;
      return;
    }

    loading.value = true;
    errorMessage.value = null;
    final loadingStartedAt = DateTime.now();

    try {
      final weatherMap = await _loadWeather(base);
      final byDate = <DateTime, ZejiRecommendation>{};
      var scanned = 0;
      String? weatherSource;

      for (final id in matterIds) {
        final q = buildQuery(overrideMatterId: id);
        final partial = ZejiEngine.search(q, weatherByDate: weatherMap);
        scanned = partial.scannedDays > scanned ? partial.scannedDays : scanned;
        weatherSource ??= partial.weatherSource;
        for (final rec in partial.recommendations) {
          final key = DateTime(rec.date.year, rec.date.month, rec.date.day);
          final prev = byDate[key];
          if (prev == null || rec.score > prev.score) {
            byDate[key] = rec;
          }
        }
      }

      final merged = byDate.values.toList()
        ..sort((a, b) => b.score.compareTo(a.score));
      final top = merged.take(3).toList();

      String? note;
      if (top.isEmpty) {
        note = '这个范围内没有合适日期，可尝试扩大范围、改用「通用」或忽略天气。';
      } else if (top.length < 3) {
        note = '符合条件的日期较少，以下为当前最佳候选。';
      }

      lastResult.value = ZejiSearchResult(
        query: base,
        recommendations: top,
        scannedDays: scanned,
        note: note,
        weatherSource: weatherSource,
      );
      hasSearched.value = true;
    } catch (e) {
      errorMessage.value = '计算异常，请重试（已保留筛选条件）';
    } finally {
      await _keepLoadingVisibleSince(loadingStartedAt);
      loading.value = false;
    }
  }

  Future<void> _keepLoadingVisibleSince(DateTime startedAt) async {
    final elapsed = DateTime.now().difference(startedAt);
    if (elapsed >= _minimumLoadingDuration) return;
    await Future<void>.delayed(_minimumLoadingDuration - elapsed);
  }

  Future<Map<String, WeatherDayInfo>?> _loadWeather(ZejiQuery q) async {
    if (q.ignoreWeather) return null;
    return WeatherService.fetchForRange(q.start, q.end);
  }

  Future<void> expandRange() async {
    final prev = lastResult.value?.query ?? buildQuery();
    final expanded = prev.expandByDays(30);
    rangePreset.value = ZejiRangePreset.custom;
    customStart.value = expanded.start;
    customEnd.value = expanded.end;
    await search(query: expanded);
  }

  Future<void> switchToGeneric() async {
    matterIds.value = ['MAT-08'];
    await search();
  }

  Future<void> retryIgnoreWeather() async {
    ignoreWeather.value = true;
    await search();
  }

  void toggleMatter(String id) {
    if (matterIds.contains(id)) {
      if (matterIds.length > 1) {
        matterIds.remove(id);
      }
      return;
    }
    matterIds.add(id);
  }

  void selectRange(ZejiRangePreset preset) => rangePreset.value = preset;

  void setWeekendOnly(bool value) => weekendOnly.value = value;
}
