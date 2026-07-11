import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/weather/weather_day_info.dart';
import 'package:lianji/core/weather/weather_service.dart';
import 'package:lianji/core/zeji/zeji_engine.dart';
import 'package:lianji/core/zeji/zeji_matter.dart';

void main() {
  tearDown(() {
    WeatherService.debugOverride = null;
  });

  test('WeatherDayInfo risk labels thresholds', () {
    final rainy = WeatherDayInfo(
      date: DateTime(2026, 6, 21),
      precipitationProbMax: 70,
      tempMaxC: 36,
      tempMinC: -1,
      aqi: 160,
    );
    expect(rainy.riskLabels, contains('可能有雨'));
    expect(rainy.riskLabels, contains('高温'));
    expect(rainy.riskLabels, contains('低温'));
    expect(rainy.riskLabels, contains('空气差'));
  });

  test('ZejiEngine applies weather penalty and labels', () {
    WeatherService.debugOverride = {
      '2026-06-21': WeatherDayInfo(
        date: DateTime(2026, 6, 21),
        precipitationProbMax: 80,
      ),
    };
    final q = ZejiQuery(
      matterId: 'MAT-08',
      start: DateTime(2026, 6, 21),
      end: DateTime(2026, 6, 21),
      ignoreWeather: false,
    );
    final result = ZejiEngine.search(q, weatherByDate: WeatherService.debugOverride);
    expect(result.recommendations, isNotEmpty);
    final hit = result.recommendations.any(
      (r) => r.weatherRiskLabels.contains('可能有雨'),
    );
    expect(hit, isTrue);
  });

  test('ZejiEngine festival conflict affects score not card pill', () {
    final qixi = ZejiQuery(
      matterId: 'MAT-08',
      start: DateTime(2026, 8, 19),
      end: DateTime(2026, 8, 19),
    );
    final plain = ZejiQuery(
      matterId: 'MAT-08',
      start: DateTime(2026, 8, 18),
      end: DateTime(2026, 8, 18),
    );
    final qixiResult = ZejiEngine.search(qixi);
    final plainResult = ZejiEngine.search(plain);
    expect(qixiResult.recommendations, isNotEmpty);
    expect(qixiResult.recommendations.first.festivalConflict, isTrue);
    expect(
      qixiResult.recommendations.first.reason,
      contains('节日·七夕节'),
    );
    expect(
      qixiResult.recommendations.first.score,
      lessThan(plainResult.recommendations.first.score),
    );
  });
}
