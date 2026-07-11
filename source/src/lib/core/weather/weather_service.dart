import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/utils/sp_utils.dart';
import '../prefs/jichen_prefs.dart';
import 'weather_day_info.dart';

/// 天气服务：Open-Meteo 预报 + 空气质量 + 本地缓存（失败不阻断择吉）。
abstract final class WeatherService {
  static const _cacheKey = 'jichen_weather_cache_v2';

  /// 测试注入，跳过网络。
  static Map<String, WeatherDayInfo>? debugOverride;

  static String _iso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static Future<void> clearCache() async {
    await SpUtils.putString(_cacheKey, '');
    await SpUtils.putString('jichen_weather_cache_v1', '');
  }

  /// 单日天气（日期详情 LOOP-005）。
  static Future<WeatherDayInfo> fetchForDate(DateTime date) async {
    final d = _dateOnly(date);
    if (debugOverride != null) {
      return debugOverride![_iso(d)] ??
          WeatherDayInfo(date: d, unavailable: true);
    }
    final map = await fetchForRange(d, d);
    return map[_iso(d)] ?? WeatherDayInfo(date: d, unavailable: true);
  }

  static Future<Map<String, WeatherDayInfo>> fetchForRange(
    DateTime start,
    DateTime end,
  ) async {
    if (debugOverride != null) return debugOverride!;

    final s = _dateOnly(start);
    final e = _dateOnly(end);
    final cached = _readCache();
    if (cached != null && _cacheCovers(cached, s, e)) {
      return cached;
    }

    try {
      final lat = JichenPrefs.weatherLat;
      final lon = JichenPrefs.weatherLon;
      final forecastUri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$lat&longitude=$lon'
        '&daily=precipitation_probability_max,temperature_2m_max,temperature_2m_min'
        '&timezone=Asia%2FShanghai'
        '&start_date=${_iso(s)}&end_date=${_iso(e)}',
      );
      final aqiUri = Uri.parse(
        'https://air-quality-api.open-meteo.com/v1/air-quality'
        '?latitude=$lat&longitude=$lon'
        '&hourly=us_aqi'
        '&timezone=Asia%2FShanghai'
        '&start_date=${_iso(s)}&end_date=${_iso(e)}',
      );

      final results = await Future.wait([
        http.get(forecastUri).timeout(const Duration(seconds: 8)),
        http.get(aqiUri).timeout(const Duration(seconds: 8)),
      ]);
      final forecastResp = results[0];
      if (forecastResp.statusCode != 200) return _fallback(cached, s, e);

      final json = jsonDecode(forecastResp.body) as Map<String, dynamic>;
      final daily = json['daily'] as Map<String, dynamic>?;
      if (daily == null) return _fallback(cached, s, e);

      final aqiByDay = _parseDailyMaxAqi(
        results[1].statusCode == 200 ? results[1].body : null,
      );

      final dates = (daily['time'] as List).cast<String>();
      final rain = (daily['precipitation_probability_max'] as List?)
          ?.cast<num?>();
      final tMax = (daily['temperature_2m_max'] as List?)?.cast<num?>();
      final tMin = (daily['temperature_2m_min'] as List?)?.cast<num?>();
      final now = DateTime.now();
      final map = <String, WeatherDayInfo>{};

      for (var i = 0; i < dates.length; i++) {
        final parts = dates[i].split('-');
        final dt = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        final key = _iso(dt);
        map[key] = WeatherDayInfo(
          date: dt,
          precipitationProbMax: rain != null && i < rain.length
              ? rain[i]?.toDouble()
              : null,
          tempMaxC:
              tMax != null && i < tMax.length ? tMax[i]?.toDouble() : null,
          tempMinC:
              tMin != null && i < tMin.length ? tMin[i]?.toDouble() : null,
          aqi: aqiByDay[key],
          fetchedAt: now,
        );
      }

      await _writeCache(map);
      return map;
    } catch (_) {
      return _fallback(cached, s, e);
    }
  }

  static Map<String, int> _parseDailyMaxAqi(String? body) {
    if (body == null || body.isEmpty) return {};
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final hourly = json['hourly'] as Map<String, dynamic>?;
      if (hourly == null) return {};
      final times = (hourly['time'] as List?)?.cast<String>() ?? [];
      final aqis = (hourly['us_aqi'] as List?)?.cast<num?>() ?? [];
      final maxByDay = <String, int>{};
      for (var i = 0; i < times.length && i < aqis.length; i++) {
        final v = aqis[i];
        if (v == null) continue;
        final day = times[i].substring(0, 10);
        final iv = v.round();
        final prev = maxByDay[day];
        if (prev == null || iv > prev) maxByDay[day] = iv;
      }
      return maxByDay;
    } catch (_) {
      return {};
    }
  }

  static WeatherDayInfo? forDate(
    DateTime date,
    Map<String, WeatherDayInfo>? map,
  ) {
    if (map == null) return null;
    return map[_iso(_dateOnly(date))];
  }

  static Map<String, WeatherDayInfo> _fallback(
    Map<String, WeatherDayInfo>? cached,
    DateTime start,
    DateTime end,
  ) {
    if (cached != null && cached.isNotEmpty) {
      return cached.map(
        (k, v) => MapEntry(k, WeatherDayInfo(
          date: v.date,
          precipitationProbMax: v.precipitationProbMax,
          tempMaxC: v.tempMaxC,
          tempMinC: v.tempMinC,
          aqi: v.aqi,
          fetchedAt: v.fetchedAt,
          offline: true,
        )),
      );
    }
    var d = start;
    final out = <String, WeatherDayInfo>{};
    while (!d.isAfter(end)) {
      out[_iso(d)] = WeatherDayInfo(date: d, unavailable: true);
      d = d.add(const Duration(days: 1));
    }
    return out;
  }

  static bool _cacheCovers(
    Map<String, WeatherDayInfo> cache,
    DateTime start,
    DateTime end,
  ) {
    var d = start;
    while (!d.isAfter(end)) {
      if (!cache.containsKey(_iso(d))) return false;
      d = d.add(const Duration(days: 1));
    }
    final first = cache.values.first.fetchedAt;
    if (first == null) return false;
    return DateTime.now().difference(first).inHours < 6;
  }

  static Map<String, WeatherDayInfo>? _readCache() {
    final raw = SpUtils.getString(_cacheKey, defValue: '') ?? '';
    if (raw.isEmpty) {
      // 兼容 v1 缓存
      final legacy = SpUtils.getString('jichen_weather_cache_v1', defValue: '') ?? '';
      if (legacy.isEmpty) return null;
      return _decodeCacheList(jsonDecode(legacy) as List);
    }
    try {
      return _decodeCacheList(jsonDecode(raw) as List);
    } catch (_) {
      return null;
    }
  }

  static Map<String, WeatherDayInfo> _decodeCacheList(List list) {
    final map = <String, WeatherDayInfo>{};
    for (final item in list) {
      final m = item as Map<String, dynamic>;
      final dateStr = m['date'] as String;
      final parts = dateStr.split('-');
      final dt = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      map[dateStr] = WeatherDayInfo(
        date: dt,
        precipitationProbMax: (m['rain'] as num?)?.toDouble(),
        tempMaxC: (m['tMax'] as num?)?.toDouble(),
        tempMinC: (m['tMin'] as num?)?.toDouble(),
        aqi: m['aqi'] as int?,
        fetchedAt: m['at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(m['at'] as int)
            : null,
        offline: true,
      );
    }
    return map;
  }

  static Future<void> _writeCache(Map<String, WeatherDayInfo> map) async {
    final list = map.entries
        .map(
          (e) => {
            'date': e.key,
            'rain': e.value.precipitationProbMax,
            'tMax': e.value.tempMaxC,
            'tMin': e.value.tempMinC,
            'aqi': e.value.aqi,
            'at': e.value.fetchedAt?.millisecondsSinceEpoch,
          },
        )
        .toList();
    await SpUtils.putString(_cacheKey, jsonEncode(list));
  }
}
