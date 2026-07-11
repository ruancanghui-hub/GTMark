import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';
import 'stats_service.dart';

class HydrationStore extends ChangeNotifier {
  HydrationStore();

  static final ValueNotifier<int> themeListenable = ValueNotifier(0);
  static SharedPreferences? _prefs;
  static HydrationStore? _instance;

  final StatsService stats = const StatsService();
  final _uuid = const Uuid();

  UserProfile? _profile;
  List<IntakeRecord> _records = [];
  VolumeUnit _unit = VolumeUnit.oz;
  ThemeMode _themeMode = ThemeMode.system;
  ReminderPrefs _reminders = const ReminderPrefs();

  UserProfile? get profile => _profile;
  List<IntakeRecord> get records => List.unmodifiable(_records);
  VolumeUnit get unit => _unit;
  ThemeMode get themeMode => _themeMode;
  ReminderPrefs get reminders => _reminders;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _instance = HydrationStore();
    await _instance!._load();
  }

  static ThemeMode currentThemeMode() {
    return _instance?._themeMode ?? ThemeMode.system;
  }

  Future<void> _load() async {
    final p = _prefs!;
    final profileJson = p.getString('profile');
    if (profileJson != null) {
      final map = jsonDecode(profileJson) as Map<String, dynamic>;
      _profile = UserProfile(
        weightKg: (map['weightKg'] as num).toDouble(),
        activityLevel: ActivityLevel.values[map['activityLevel'] as int],
        dailyGoalMl: map['dailyGoalMl'] as int,
        onboardingDone: map['onboardingDone'] as bool,
        gender: Gender.values[map['gender'] as int? ?? 0],
        climate: Climate.values[map['climate'] as int? ?? 1],
      );
    }
    final recordsJson = p.getStringList('records') ?? [];
    _records = recordsJson.map((s) {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return IntakeRecord(
        id: m['id'] as String,
        recordedAt: DateTime.parse(m['recordedAt'] as String),
        drinkType: DrinkType.values[m['drinkType'] as int],
        volumeMl: m['volumeMl'] as int,
        note: m['note'] as String?,
      );
    }).toList();
    _unit = VolumeUnit.values[p.getInt('unit') ?? VolumeUnit.oz.index];
    _themeMode = ThemeMode.values[p.getInt('themeMode') ?? 0];
    final reminderJson = p.getString('reminders');
    if (reminderJson != null) {
      final m = jsonDecode(reminderJson) as Map<String, dynamic>;
      _reminders = ReminderPrefs(
        enabled: m['enabled'] as bool? ?? true,
        wakeUp: m['wakeUp'] as bool? ?? true,
        beforeMeal: m['beforeMeal'] as bool? ?? true,
        afterMeal: m['afterMeal'] as bool? ?? true,
        bedtime: m['bedtime'] as bool? ?? true,
        muteAtNight: m['muteAtNight'] as bool? ?? true,
        muteEndHour: m['muteEndHour'] as int? ?? 7,
        muteEndMinute: m['muteEndMinute'] as int? ?? 0,
      );
    }
    notifyListeners();
  }

  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;
    await _prefs!.setString(
      'profile',
      jsonEncode({
        'weightKg': profile.weightKg,
        'activityLevel': profile.activityLevel.index,
        'dailyGoalMl': profile.dailyGoalMl,
        'onboardingDone': profile.onboardingDone,
        'gender': profile.gender.index,
        'climate': profile.climate.index,
      }),
    );
    notifyListeners();
  }

  Future<void> saveReminders(ReminderPrefs prefs) async {
    _reminders = prefs;
    await _prefs!.setString(
      'reminders',
      jsonEncode({
        'enabled': prefs.enabled,
        'wakeUp': prefs.wakeUp,
        'beforeMeal': prefs.beforeMeal,
        'afterMeal': prefs.afterMeal,
        'bedtime': prefs.bedtime,
        'muteAtNight': prefs.muteAtNight,
        'muteEndHour': prefs.muteEndHour,
        'muteEndMinute': prefs.muteEndMinute,
      }),
    );
    notifyListeners();
  }

  Future<void> addIntake({
    required DrinkType drinkType,
    required int volumeMl,
    String? note,
    DateTime? at,
  }) async {
    final record = IntakeRecord(
      id: _uuid.v4(),
      recordedAt: at ?? DateTime.now(),
      drinkType: drinkType,
      volumeMl: volumeMl,
      note: note,
    );
    _records = [record, ..._records];
    await _persistRecords();
    notifyListeners();
  }

  Future<void> _persistRecords() async {
    await _prefs!.setStringList(
      'records',
      _records
          .map(
            (r) => jsonEncode({
              'id': r.id,
              'recordedAt': r.recordedAt.toIso8601String(),
              'drinkType': r.drinkType.index,
              'volumeMl': r.volumeMl,
              'note': r.note,
            }),
          )
          .toList(),
    );
  }

  int todayTotal([DateTime? day]) {
    return stats.totalForDay(_records, day ?? DateTime.now());
  }

  Future<void> setUnit(VolumeUnit unit) async {
    _unit = unit;
    await _prefs!.setInt('unit', unit.index);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs!.setInt('themeMode', mode.index);
    themeListenable.value++;
    notifyListeners();
  }

  static HydrationStore of() {
    final i = _instance;
    if (i == null) throw StateError('HydrationStore not initialized');
    return i;
  }
}
