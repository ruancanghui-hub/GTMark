import 'reminder_advance.dart';
import 'reminder_kind.dart';
import 'reminder_repeat.dart';
import '../content/poem_resolver.dart';
import '../date/lunar_birthday.dart';

/// 本地提醒实体（LOOP-003）。
class PersonalReminder {
  const PersonalReminder({
    required this.id,
    required this.title,
    required this.date,
    this.hour = 9,
    this.minute = 0,
    this.notifyEnabled = true,
    this.notifyPending = false,
    this.note,
    this.source = 'manual',
    this.matterId,
    this.completed = false,
    this.advanceMinutesList = kDefaultAdvanceMinutes,
    this.repeatRule = ReminderRepeatRule.none,
    this.lunarLeapPreferred = false,
    this.kind = ReminderKind.event,
    this.lunarBirthdayAnchor,
    this.birthdayRelation,
    this.anniversarySubtype,
    this.countdownTheme,
    this.allDay = false,
    this.category = 'general',
  });

  final String id;
  final String title;
  final DateTime date;
  final int hour;
  final int minute;
  final bool notifyEnabled;
  final bool notifyPending;
  final String? note;
  final String source;
  final String? matterId;
  final bool completed;
  final List<int> advanceMinutesList;
  final ReminderRepeatRule repeatRule;

  /// 农历每年重复时，是否优先匹配闰月（false = 常月）。
  final bool lunarLeapPreferred;
  final ReminderKind kind;
  final LunarBirthdayAnchor? lunarBirthdayAnchor;

  /// 生日关系（SPEC-013）：parent/elder/spouse/peer/child/self
  final String? birthdayRelation;

  /// 纪念日类型（SPEC-013）：wedding/love/family/work/custom
  final String? anniversarySubtype;

  /// 倒数日主题（SPEC-013）：time/travel/exam
  final String? countdownTheme;
  final bool allDay;
  final String category;

  bool get isAnniversaryKind =>
      kind == ReminderKind.birthday ||
      kind == ReminderKind.anniversary ||
      kind == ReminderKind.countdown;

  DateTime get dateTimeLocal =>
      DateTime(date.year, date.month, date.day, hour, minute);

  /// 各提前量对应的触发时刻（基于下次发生日，去重、仅未来由通知层过滤）。
  List<DateTime> notifyDateTimesLocal([DateTime? from]) {
    final next = effectiveNextDate(from);
    final base = DateTime(next.year, next.month, next.day, hour, minute);
    final slots = advanceMinutesList.isEmpty ? [0] : advanceMinutesList;
    return slots
        .map((m) => base.subtract(Duration(minutes: m)))
        .toSet()
        .toList()
      ..sort();
  }

  /// 兼容旧字段读取。
  int get advanceMinutes =>
      advanceMinutesList.isEmpty ? 0 : advanceMinutesList.first;

  static String isoDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String serialize() => [
    id,
    title,
    isoDate(date),
    '$hour',
    '$minute',
    notifyEnabled ? '1' : '0',
    notifyPending ? '1' : '0',
    source,
    matterId ?? '',
    completed ? '1' : '0',
    note ?? '',
    formatAdvanceMinutesList(advanceMinutesList),
    repeatRule.name,
    lunarLeapPreferred ? '1' : '0',
    kind.name,
    lunarBirthdayAnchor?.serialize() ?? '',
    birthdayRelation ?? '',
    anniversarySubtype ?? '',
    countdownTheme ?? '',
    allDay ? '1' : '0',
    category,
  ].join('\t');

  static PersonalReminder? deserialize(String line) {
    if (line.trim().isEmpty) return null;
    final p = line.split('\t');
    if (p.length < 9) return _legacyPipe(line);
    final dp = p[2].split('-');
    if (dp.length != 3) return null;
    final y = int.tryParse(dp[0]);
    final mo = int.tryParse(dp[1]);
    final d = int.tryParse(dp[2]);
    if (y == null || mo == null || d == null) return null;
    return PersonalReminder(
      id: p[0],
      title: p[1],
      date: DateTime(y, mo, d),
      hour: int.tryParse(p[3]) ?? 9,
      minute: int.tryParse(p[4]) ?? 0,
      notifyEnabled: p[5] == '1',
      notifyPending: p[6] == '1',
      source: p[7],
      matterId: p[8].isEmpty ? null : p[8],
      completed: p.length > 9 && p[9] == '1',
      note: p.length > 10 && p[10].isNotEmpty ? p[10] : null,
      advanceMinutesList: p.length > 11
          ? parseAdvanceMinutesList(p[11])
          : List<int>.from(kDefaultAdvanceMinutes),
      repeatRule: p.length > 12
          ? ReminderRepeatRule.fromName(p[12])
          : ReminderRepeatRule.none,
      lunarLeapPreferred: p.length > 13 && p[13] == '1',
      kind: p.length > 14 ? ReminderKind.fromName(p[14]) : ReminderKind.event,
      lunarBirthdayAnchor: p.length > 15
          ? LunarBirthdayAnchor.deserialize(p[15])
          : null,
      birthdayRelation: p.length > 16 && p[16].isNotEmpty ? p[16] : null,
      anniversarySubtype: p.length > 17 && p[17].isNotEmpty ? p[17] : null,
      countdownTheme: p.length > 18 && p[18].isNotEmpty ? p[18] : null,
      allDay: p.length > 19 && p[19] == '1',
      category: p.length > 20 && p[20].isNotEmpty ? p[20] : 'general',
    );
  }

  static PersonalReminder? _legacyPipe(String line) {
    final p = line.split('|');
    if (p.length < 2) return null;
    final dp = p[1].split('-');
    if (dp.length != 3) return null;
    final y = int.tryParse(dp[0]);
    final mo = int.tryParse(dp[1]);
    final d = int.tryParse(dp[2]);
    if (y == null || mo == null || d == null) return null;
    return PersonalReminder(
      id: p.length > 2
          ? p[2]
          : DateTime.now().millisecondsSinceEpoch.toString(),
      title: p[0],
      date: DateTime(y, mo, d),
      source: 'legacy',
    );
  }

  PersonalReminder copyWith({
    String? title,
    DateTime? date,
    int? hour,
    int? minute,
    bool? notifyEnabled,
    bool? notifyPending,
    String? note,
    bool? completed,
    int? advanceMinutes,
    List<int>? advanceMinutesList,
    ReminderRepeatRule? repeatRule,
    bool? lunarLeapPreferred,
    ReminderKind? kind,
    LunarBirthdayAnchor? lunarBirthdayAnchor,
    String? birthdayRelation,
    String? anniversarySubtype,
    String? countdownTheme,
    bool? allDay,
    String? category,
  }) {
    return PersonalReminder(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      notifyEnabled: notifyEnabled ?? this.notifyEnabled,
      notifyPending: notifyPending ?? this.notifyPending,
      note: note ?? this.note,
      source: source,
      matterId: matterId,
      completed: completed ?? this.completed,
      advanceMinutesList:
          advanceMinutesList ??
          (advanceMinutes != null ? [advanceMinutes] : this.advanceMinutesList),
      repeatRule: repeatRule ?? this.repeatRule,
      lunarLeapPreferred: lunarLeapPreferred ?? this.lunarLeapPreferred,
      kind: kind ?? this.kind,
      lunarBirthdayAnchor: lunarBirthdayAnchor ?? this.lunarBirthdayAnchor,
      birthdayRelation: birthdayRelation ?? this.birthdayRelation,
      anniversarySubtype: anniversarySubtype ?? this.anniversarySubtype,
      countdownTheme: countdownTheme ?? this.countdownTheme,
      allDay: allDay ?? this.allDay,
      category: category ?? this.category,
    );
  }

  DateTime effectiveNextDate([DateTime? from]) {
    final base = from ?? DateTime.now();
    final today = DateTime(base.year, base.month, base.day);
    final d = DateTime(date.year, date.month, date.day);
    if (!d.isBefore(today)) return d;
    if (repeatRule != ReminderRepeatRule.none) {
      return ReminderRepeat.nextAfter(this, today) ?? d;
    }
    return d;
  }

  int daysUntilNext([DateTime? from]) {
    final base = from ?? DateTime.now();
    final today = DateTime(base.year, base.month, base.day);
    return effectiveNextDate(today).difference(today).inDays;
  }

  int daysUntil(DateTime from) => daysUntilNext(from);

  /// 个人事项 → 诗句库 ID（bd_* / an_* / cd_*）。
  String? get personalPoemId {
    switch (kind) {
      case ReminderKind.birthday:
        return birthdayRelation == null
            ? null
            : PoemResolver.personalBirthdayId(birthdayRelation!);
      case ReminderKind.anniversary:
        return anniversarySubtype == null
            ? null
            : PoemResolver.personalAnniversaryId(anniversarySubtype!);
      case ReminderKind.countdown:
        return PoemResolver.personalCountdownId(countdownTheme ?? 'time');
      case ReminderKind.event:
        return null;
    }
  }
}

enum ReminderGroup { today, future, past }

ReminderGroup groupOf(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final d = DateTime(date.year, date.month, date.day);
  if (d == today) return ReminderGroup.today;
  if (d.isAfter(today)) return ReminderGroup.future;
  return ReminderGroup.past;
}

ReminderGroup groupOfReminder(PersonalReminder reminder) =>
    groupOf(reminder.effectiveNextDate());
