enum ActivityLevel { low, medium, high }

enum Gender { female, male }

enum Climate { cold, mild, hot }

enum DrinkType {
  water,
  tea,
  coffee,
  juice,
  custom,
  milk,
  beer,
  coldDrink,
  orangeJuice,
}

enum VolumeUnit { ml, oz }

enum ContainerType { smallGlass, standardGlass, largeGlass, bottle }

class UserProfile {
  const UserProfile({
    required this.weightKg,
    required this.activityLevel,
    required this.dailyGoalMl,
    required this.onboardingDone,
    this.gender = Gender.female,
    this.climate = Climate.mild,
  });

  final double weightKg;
  final ActivityLevel activityLevel;
  final int dailyGoalMl;
  final bool onboardingDone;
  final Gender gender;
  final Climate climate;

  UserProfile copyWith({
    double? weightKg,
    ActivityLevel? activityLevel,
    int? dailyGoalMl,
    bool? onboardingDone,
    Gender? gender,
    Climate? climate,
  }) {
    return UserProfile(
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      gender: gender ?? this.gender,
      climate: climate ?? this.climate,
    );
  }
}

class IntakeRecord {
  const IntakeRecord({
    required this.id,
    required this.recordedAt,
    required this.drinkType,
    required this.volumeMl,
    this.note,
  });

  final String id;
  final DateTime recordedAt;
  final DrinkType drinkType;
  final int volumeMl;
  final String? note;

  IntakeRecord copyWith({
    String? id,
    DateTime? recordedAt,
    DrinkType? drinkType,
    int? volumeMl,
    String? note,
  }) {
    return IntakeRecord(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      drinkType: drinkType ?? this.drinkType,
      volumeMl: volumeMl ?? this.volumeMl,
      note: note ?? this.note,
    );
  }
}

class ReminderPrefs {
  const ReminderPrefs({
    this.enabled = true,
    this.wakeUp = true,
    this.beforeMeal = true,
    this.afterMeal = true,
    this.bedtime = true,
    this.muteAtNight = true,
    this.muteEndHour = 7,
    this.muteEndMinute = 0,
    this.wakeUpHour = 8,
    this.wakeUpMinute = 0,
    this.beforeMealHour = 11,
    this.beforeMealMinute = 30,
    this.afterMealHour = 13,
    this.afterMealMinute = 30,
    this.bedtimeHour = 21,
    this.bedtimeMinute = 30,
  });

  final bool enabled;
  final bool wakeUp;
  final bool beforeMeal;
  final bool afterMeal;
  final bool bedtime;
  final bool muteAtNight;
  final int muteEndHour;
  final int muteEndMinute;
  final int wakeUpHour;
  final int wakeUpMinute;
  final int beforeMealHour;
  final int beforeMealMinute;
  final int afterMealHour;
  final int afterMealMinute;
  final int bedtimeHour;
  final int bedtimeMinute;

  ReminderPrefs copyWith({
    bool? enabled,
    bool? wakeUp,
    bool? beforeMeal,
    bool? afterMeal,
    bool? bedtime,
    bool? muteAtNight,
    int? muteEndHour,
    int? muteEndMinute,
    int? wakeUpHour,
    int? wakeUpMinute,
    int? beforeMealHour,
    int? beforeMealMinute,
    int? afterMealHour,
    int? afterMealMinute,
    int? bedtimeHour,
    int? bedtimeMinute,
  }) {
    return ReminderPrefs(
      enabled: enabled ?? this.enabled,
      wakeUp: wakeUp ?? this.wakeUp,
      beforeMeal: beforeMeal ?? this.beforeMeal,
      afterMeal: afterMeal ?? this.afterMeal,
      bedtime: bedtime ?? this.bedtime,
      muteAtNight: muteAtNight ?? this.muteAtNight,
      muteEndHour: muteEndHour ?? this.muteEndHour,
      muteEndMinute: muteEndMinute ?? this.muteEndMinute,
      wakeUpHour: wakeUpHour ?? this.wakeUpHour,
      wakeUpMinute: wakeUpMinute ?? this.wakeUpMinute,
      beforeMealHour: beforeMealHour ?? this.beforeMealHour,
      beforeMealMinute: beforeMealMinute ?? this.beforeMealMinute,
      afterMealHour: afterMealHour ?? this.afterMealHour,
      afterMealMinute: afterMealMinute ?? this.afterMealMinute,
      bedtimeHour: bedtimeHour ?? this.bedtimeHour,
      bedtimeMinute: bedtimeMinute ?? this.bedtimeMinute,
    );
  }
}
