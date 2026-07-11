import '../date/day_info.dart';
import '../date/day_info_service.dart';
import '../date/holiday_mark.dart';
import '../date/lunar_helper.dart';
import '../reminder/reminder_store.dart';
import '../weather/weather_day_info.dart';
import '../weather/weather_service.dart';
import 'zeji_matter.dart';
import 'zeji_result.dart';

/// 黄历择吉引擎（产品口径评分，非玄学承诺）。
abstract final class ZejiEngine {
  static const _obviousJiBlock = ['诸事不宜'];

  static ZejiSearchResult search(
    ZejiQuery query, {
    Map<String, WeatherDayInfo>? weatherByDate,
  }) {
    final err = ZejiQuery.validateRange(query.start, query.end);
    if (err != null) {
      return ZejiSearchResult(
        query: query,
        recommendations: const [],
        note: err,
      );
    }

    final matter = ZejiMatter.byId(query.matterId);
    final candidates = <_ScoredDay>[];
    var day = _dateOnly(query.start);
    final end = _dateOnly(query.end);
    var scanned = 0;
    String? weatherSource;

    while (!day.isAfter(end)) {
      scanned++;
      final info = DayInfoService.build(day);
      final weather = WeatherService.forDate(day, weatherByDate);
      if (weather != null && weatherSource == null) {
        weatherSource = weather.sourceCaption;
      }
      final scored = _scoreDay(info, matter, query, weather: weather);
      if (scored != null) candidates.add(scored);
      day = day.add(const Duration(days: 1));
    }

    candidates.sort((a, b) => b.score.compareTo(a.score));
    final top = candidates.take(3).toList();
    final sparse = top.length < 3 && top.isNotEmpty;

    final recs = top
        .map(
          (s) => ZejiRecommendation(
            date: s.date,
            score: s.score,
            reason: s.reason,
            matchedYi: s.matchedYi,
            workAdjust: s.workAdjust,
            restDay: s.restDay,
            weatherRiskLabels: s.weatherRiskLabels,
            festivalConflict: s.festivalConflict,
            festivalConflictLabel: s.festivalConflictLabel,
            reminderConflict: s.reminderConflict,
            reminderConflictLabel: s.reminderConflictLabel,
            sparseHint: sparse,
          ),
        )
        .toList();

    String? note;
    if (recs.isEmpty) {
      note = '这个范围内没有合适日期，可尝试扩大范围、改用「通用」或忽略天气。';
    } else if (sparse) {
      note = '符合条件的日期较少，以下为当前最佳候选。';
    }

    return ZejiSearchResult(
      query: query,
      recommendations: recs,
      scannedDays: scanned,
      note: note,
      weatherSource: query.ignoreWeather ? null : weatherSource,
    );
  }

  static _ScoredDay? _scoreDay(
    DayInfo info,
    ZejiMatter matter,
    ZejiQuery query, {
    WeatherDayInfo? weather,
  }) {
    if (!info.hasHuangli && matter.hardFilter) return null;

    if (query.skipWorkdayAdjust &&
        info.holidayMark.kind == HolidayMarkKind.workAdjust) {
      return null;
    }

    if (query.weekendOnly &&
        info.date.weekday != DateTime.saturday &&
        info.date.weekday != DateTime.sunday) {
      return null;
    }

    for (final block in _obviousJiBlock) {
      if (info.ji.any((j) => j.contains(block))) return null;
    }

    if (matter.hardFilter) {
      for (final kw in matter.jiBlockKeywords) {
        if (info.ji.any((j) => j.contains(kw))) return null;
      }
    }

    var score = 0;
    final matchedYi = <String>[];

    if (matter.hardFilter) {
      for (final yi in info.yi) {
        for (final kw in matter.yiKeywords) {
          if (yi.contains(kw)) {
            score += 2;
            if (!matchedYi.contains(yi)) matchedYi.add(yi);
          }
        }
      }
      if (matchedYi.isEmpty) return null;
    } else {
      score = 1;
      if (info.yi.isNotEmpty) {
        matchedYi.addAll(info.yi.take(2));
        score += info.yi.length.clamp(0, 2);
      }
    }

    final workAdjust = info.holidayMark.kind == HolidayMarkKind.workAdjust;
    final restDay = info.holidayMark.kind == HolidayMarkKind.rest;

    final festivalConflict =
        info.festivalName != null && info.festivalName!.isNotEmpty && !restDay;
    final festivalConflictLabel = festivalConflict
        ? '节日·${info.festivalName}'
        : null;
    if (festivalConflict) score -= 1;

    final reminderHit = ReminderStore.conflictNear(info.date);
    if (reminderHit.conflict) score -= 1;

    final weatherRiskLabels = <String>[];
    if (!query.ignoreWeather && weather != null) {
      weatherRiskLabels.addAll(weather.riskLabels);
      if (weather.hasRisk) score -= 1;
    }

    final reason = _buildReason(
      info: info,
      matchedYi: matchedYi,
      workAdjust: workAdjust,
      restDay: restDay,
      ignoreWeather: query.ignoreWeather,
      weatherRiskLabels: weatherRiskLabels,
      festivalConflictLabel: festivalConflictLabel,
      reminderConflictLabel: reminderHit.label,
    );

    return _ScoredDay(
      date: info.date,
      score: score,
      reason: reason,
      matchedYi: matchedYi,
      workAdjust: workAdjust,
      restDay: restDay,
      weatherRiskLabels: weatherRiskLabels,
      festivalConflict: festivalConflict,
      festivalConflictLabel: festivalConflictLabel,
      reminderConflict: reminderHit.conflict,
      reminderConflictLabel: reminderHit.label,
    );
  }

  static String _buildReason({
    required DayInfo info,
    required List<String> matchedYi,
    required bool workAdjust,
    required bool restDay,
    required bool ignoreWeather,
    required List<String> weatherRiskLabels,
    String? festivalConflictLabel,
    String? reminderConflictLabel,
  }) {
    final parts = <String>[];
    parts.add(lunarMonthDayLabel(info.date));
    if (matchedYi.isNotEmpty) {
      parts.add('宜${matchedYi.take(2).join('、')}');
    } else {
      parts.add('综合黄历评分较佳');
    }
    if (workAdjust) {
      parts.add('调休上班日');
    } else if (restDay) {
      parts.add('法定休息日');
    } else {
      parts.add('无调休冲突');
    }
    if (festivalConflictLabel != null) {
      parts.add('遇$festivalConflictLabel');
    }
    if (reminderConflictLabel != null) parts.add(reminderConflictLabel);
    if (ignoreWeather) {
      parts.add('未纳入天气');
    } else if (weatherRiskLabels.isNotEmpty) {
      parts.add(weatherRiskLabels.join('、'));
    } else {
      parts.add('暂无天气风险');
    }
    return '${parts.join('；')}。';
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}

class _ScoredDay {
  const _ScoredDay({
    required this.date,
    required this.score,
    required this.reason,
    required this.matchedYi,
    required this.workAdjust,
    required this.restDay,
    required this.weatherRiskLabels,
    required this.festivalConflict,
    this.festivalConflictLabel,
    required this.reminderConflict,
    this.reminderConflictLabel,
  });

  final DateTime date;
  final int score;
  final String reason;
  final List<String> matchedYi;
  final bool workAdjust;
  final bool restDay;
  final List<String> weatherRiskLabels;
  final bool festivalConflict;
  final String? festivalConflictLabel;
  final bool reminderConflict;
  final String? reminderConflictLabel;
}
