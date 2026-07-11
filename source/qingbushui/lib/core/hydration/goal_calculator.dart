import 'models.dart';

class GoalCalculator {
  static const int minGoalMl = 1500;
  static const int maxGoalMl = 4000;

  static double activityFactor(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.low:
        return 1.0;
      case ActivityLevel.medium:
        return 1.1;
      case ActivityLevel.high:
        return 1.2;
    }
  }

  static double climateFactor(Climate climate) {
    switch (climate) {
      case Climate.cold:
        return 0.95;
      case Climate.mild:
        return 1.0;
      case Climate.hot:
        return 1.1;
    }
  }

  static double genderFactor(Gender gender) {
    return gender == Gender.male ? 1.05 : 1.0;
  }

  static int calculateDailyGoalMl({
    required double weightKg,
    required ActivityLevel activityLevel,
    Gender gender = Gender.female,
    Climate climate = Climate.mild,
  }) {
    final base =
        weightKg *
        35 *
        activityFactor(activityLevel) *
        genderFactor(gender) *
        climateFactor(climate);
    final rounded = base.round();
    if (rounded < minGoalMl) return minGoalMl;
    if (rounded > maxGoalMl) return maxGoalMl;
    return rounded;
  }
}
