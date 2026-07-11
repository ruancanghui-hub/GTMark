import 'dart:convert';

import 'package:http/http.dart' as http;

import '../prefs/jichen_prefs.dart';
import 'weather_service.dart';

/// 天气城市（手动 / 定位 / 搜索）。
class WeatherCity {
  const WeatherCity({
    required this.name,
    required this.lat,
    required this.lon,
    this.admin1,
  });

  final String name;
  final double lat;
  final double lon;
  final String? admin1;

  String get displayLabel =>
      admin1 != null && admin1!.isNotEmpty ? '$name · $admin1' : name;
}

/// 城市预设 + Open-Meteo 地理编码 + 定位。
abstract final class WeatherCityService {
  static const presets = <WeatherCity>[
    WeatherCity(name: '北京', lat: 39.9042, lon: 116.4074, admin1: '北京'),
    WeatherCity(name: '上海', lat: 31.2304, lon: 121.4737, admin1: '上海'),
    WeatherCity(name: '广州', lat: 23.1291, lon: 113.2644, admin1: '广东'),
    WeatherCity(name: '深圳', lat: 22.5431, lon: 114.0579, admin1: '广东'),
    WeatherCity(name: '成都', lat: 30.5728, lon: 104.0668, admin1: '四川'),
    WeatherCity(name: '杭州', lat: 30.2741, lon: 120.1551, admin1: '浙江'),
    WeatherCity(name: '武汉', lat: 30.5928, lon: 114.3055, admin1: '湖北'),
    WeatherCity(name: '西安', lat: 34.3416, lon: 108.9398, admin1: '陕西'),
  ];

  static Future<List<WeatherCity>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return presets;
    final lower = q.toLowerCase();
    final local = presets
        .where(
          (c) =>
              c.name.contains(q) ||
              (c.admin1?.contains(q) ?? false) ||
              c.name.toLowerCase().contains(lower),
        )
        .toList();
    try {
      final uri = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search'
        '?name=${Uri.encodeQueryComponent(q)}'
        '&count=8&language=zh&country=CN',
      );
      final resp = await http.get(uri).timeout(const Duration(seconds: 6));
      if (resp.statusCode != 200) return local;
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final results = (json['results'] as List?) ?? [];
      final remote = results.map((e) {
        final m = e as Map<String, dynamic>;
        return WeatherCity(
          name: m['name'] as String? ?? q,
          lat: (m['latitude'] as num).toDouble(),
          lon: (m['longitude'] as num).toDouble(),
          admin1: m['admin1'] as String?,
        );
      }).toList();
      if (remote.isEmpty) return local;
      return remote;
    } catch (_) {
      return local;
    }
  }

  static Future<bool> applyCity(WeatherCity city) async {
    await JichenPrefs.setWeatherCity(
      city.displayLabel,
      city.lat,
      city.lon,
    );
    await WeatherService.clearCache();
    return true;
  }
}
