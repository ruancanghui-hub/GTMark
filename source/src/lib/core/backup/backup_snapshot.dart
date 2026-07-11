import '../reminder/personal_reminder.dart';
import '../reminder/reminder_kind.dart';
import 'backup_format.dart';

/// 本地数据快照统计（数据与备份页展示）。
class BackupLocalStats {
  const BackupLocalStats({
    required this.reminders,
    required this.anniversaries,
    required this.favorites,
    required this.hasCity,
  });

  final int reminders;
  final int anniversaries;
  final int favorites;
  final bool hasCity;

  int get totalReminders => reminders + anniversaries;
}

/// 导入预览（合并策略：同 ID 跳过）。
class BackupImportPreview {
  const BackupImportPreview({
    required this.exportedAt,
    required this.importReminders,
    required this.importAnniversaries,
    required this.importFavorites,
    required this.importHasCity,
    required this.addReminders,
    required this.skipReminders,
    required this.addFavorites,
    required this.willSyncSettings,
  });

  final DateTime? exportedAt;
  final int importReminders;
  final int importAnniversaries;
  final int importFavorites;
  final bool importHasCity;
  final int addReminders;
  final int skipReminders;
  final int addFavorites;
  final bool willSyncSettings;

  bool get valid => addReminders > 0 || addFavorites > 0 || willSyncSettings;
}

/// 可序列化的备份快照。
class BackupSnapshot {
  const BackupSnapshot({
    required this.version,
    required this.exportedAt,
    required this.reminderLines,
    required this.favoriteDates,
    required this.prefs,
    required this.festivalDisabled,
  });

  final int version;
  final DateTime exportedAt;
  final List<String> reminderLines;
  final List<String> favoriteDates;
  final Map<String, dynamic> prefs;
  final List<String> festivalDisabled;

  List<PersonalReminder> parseReminders() {
    return reminderLines
        .map(PersonalReminder.deserialize)
        .whereType<PersonalReminder>()
        .toList();
  }

  BackupLocalStats stats() {
    final items = parseReminders();
    var events = 0;
    var ann = 0;
    for (final r in items) {
      if (r.kind == ReminderKind.event) {
        events++;
      } else {
        ann++;
      }
    }
    return BackupLocalStats(
      reminders: events,
      anniversaries: ann,
      favorites: favoriteDates.length,
      hasCity: (prefs['weatherCityName'] as String?)?.isNotEmpty == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'format': BackupFormat.formatId,
        'version': version,
        'exportedAt': exportedAt.toUtc().toIso8601String(),
        'data': {
          'reminders': reminderLines,
          'favoriteDates': favoriteDates,
          'prefs': prefs,
          'festivalReminderDisabled': festivalDisabled,
        },
      };

  static BackupSnapshot? fromJson(Map<String, dynamic> json) {
    if (json['format'] != BackupFormat.formatId) return null;
    final version = json['version'];
    if (version is! int || version != BackupFormat.version) return null;
    final exportedRaw = json['exportedAt'];
    if (exportedRaw is! String) return null;
    final exportedAt = DateTime.tryParse(exportedRaw);
    if (exportedAt == null) return null;
    final data = json['data'];
    if (data is! Map) return null;
    final reminders = data['reminders'];
    final favorites = data['favoriteDates'];
    final prefs = data['prefs'];
    final disabled = data['festivalReminderDisabled'];
    if (reminders is! List || favorites is! List || prefs is! Map) return null;
    if (disabled is! List) return null;
    final reminderLines = reminders.map((e) => e.toString()).toList();
    if (reminderLines.length > 500) return null;
    final favoriteDates = favorites.map((e) => e.toString()).toList();
    if (favoriteDates.length > 2000) return null;
    final festivalDisabled = disabled.map((e) => e.toString()).toList();
    return BackupSnapshot(
      version: version,
      exportedAt: exportedAt.toLocal(),
      reminderLines: reminderLines,
      favoriteDates: favoriteDates,
      prefs: Map<String, dynamic>.from(prefs),
      festivalDisabled: festivalDisabled,
    );
  }
}
