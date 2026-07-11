/// ISO 8601 周次（周一为一周起始）。
int isoWeekNumber(DateTime date) {
  final local = DateTime(date.year, date.month, date.day);
  final dayNr = (local.weekday + 6) % 7;
  final thursday = local.add(Duration(days: 3 - dayNr));
  final yearStart = DateTime(thursday.year, 1, 1);
  final firstThursday = yearStart.add(
    Duration(days: (4 - yearStart.weekday + 7) % 7),
  );
  return 1 + (thursday.difference(firstThursday).inDays ~/ 7);
}
