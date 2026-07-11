import 'package:flutter_test/flutter_test.dart';
import 'package:qingbushui/core/hydration/goal_calculator.dart';
import 'package:qingbushui/core/hydration/models.dart';

void main() {
  test('60kg 中等活动量应得到合理饮水目标', () {
    final goal = GoalCalculator.calculateDailyGoalMl(
      weightKg: 60,
      activityLevel: ActivityLevel.medium,
    );
    expect(goal, greaterThanOrEqualTo(1500));
    expect(goal, lessThanOrEqualTo(4000));
    expect(goal, 2310);
  });

  test('低活动量系数小于高活动量', () {
    final low = GoalCalculator.calculateDailyGoalMl(
      weightKg: 70,
      activityLevel: ActivityLevel.low,
    );
    final high = GoalCalculator.calculateDailyGoalMl(
      weightKg: 70,
      activityLevel: ActivityLevel.high,
    );
    expect(high, greaterThan(low));
  });
}
