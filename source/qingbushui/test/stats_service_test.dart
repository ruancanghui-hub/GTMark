import 'package:flutter_test/flutter_test.dart';
import 'package:qingbushui/core/hydration/models.dart';
import 'package:qingbushui/core/hydration/stats_service.dart';

void main() {
  final stats = StatsService();
  final day = DateTime(2026, 7, 11, 12);

  test('当日总量应正确累加', () {
    final records = [
      IntakeRecord(
        id: '1',
        recordedAt: day,
        drinkType: DrinkType.water,
        volumeMl: 200,
      ),
      IntakeRecord(
        id: '2',
        recordedAt: day.add(const Duration(hours: 1)),
        drinkType: DrinkType.tea,
        volumeMl: 300,
      ),
      IntakeRecord(
        id: '3',
        recordedAt: day.subtract(const Duration(days: 1)),
        drinkType: DrinkType.water,
        volumeMl: 500,
      ),
    ];
    expect(stats.totalForDay(records, day), 500);
  });

  test('连续打卡应统计达标天数', () {
    final goal = 2000;
    final records = <IntakeRecord>[];
    for (var i = 0; i < 3; i++) {
      final d = DateTime(2026, 7, 11).subtract(Duration(days: i));
      records.add(
        IntakeRecord(
          id: '$i',
          recordedAt: d,
          drinkType: DrinkType.water,
          volumeMl: 1800,
        ),
      );
    }
    expect(stats.streakDays(records, goal, DateTime(2026, 7, 11)), 3);
  });
}
