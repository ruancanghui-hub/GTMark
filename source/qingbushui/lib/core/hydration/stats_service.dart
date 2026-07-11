import 'models.dart';

class StatsService {
  const StatsService();

  int totalForDay(List<IntakeRecord> records, DateTime day) {
    return records
        .where((r) => _isSameDay(r.recordedAt, day))
        .fold<int>(0, (sum, r) => sum + r.volumeMl);
  }

  List<int> totalsForDays(List<IntakeRecord> records, List<DateTime> days) {
    return days.map((d) => totalForDay(records, d)).toList();
  }

  int streakDays(List<IntakeRecord> records, int dailyGoalMl, DateTime today) {
    var streak = 0;
    var cursor = DateTime(today.year, today.month, today.day);
    while (true) {
      final total = totalForDay(records, cursor);
      if (total < (dailyGoalMl * 0.8).round()) break;
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
