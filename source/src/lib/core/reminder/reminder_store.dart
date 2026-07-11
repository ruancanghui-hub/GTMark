import 'package:get/get.dart';

import '../../shared/utils/sp_utils.dart';
import '../reminder/notification_service.dart';
import 'personal_reminder.dart';
import 'reminder_kind.dart';
import 'reminder_repeat.dart';

/// 来自择吉的提醒预填（LOOP-002 → LOOP-003 桥接）。
class ReminderDraft {
  const ReminderDraft({
    required this.title,
    required this.date,
    required this.source,
    this.matterId,
    this.note,
    this.hour = 9,
    this.minute = 0,
    this.notifyEnabled = true,
  });

  final String title;
  final DateTime date;
  final String source;
  final String? matterId;
  final String? note;
  final int hour;
  final int minute;
  final bool notifyEnabled;

  PersonalReminder toReminder({String? id}) {
    return PersonalReminder(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: DateTime(date.year, date.month, date.day),
      hour: hour,
      minute: minute,
      notifyEnabled: notifyEnabled,
      note: note,
      source: source,
      matterId: matterId,
    );
  }
}

/// 本地个人提醒存储。
abstract final class ReminderStore {
  static const _draftKey = 'jichen_reminder_draft';
  static const _listKey = 'jichen_personal_reminders_v2';

  static final revision = 0.obs;

  static List<PersonalReminder> loadAll() {
    final raw = SpUtils.getString(_listKey, defValue: '') ?? '';
    if (raw.isEmpty) return _migrateLegacy();
    return raw
        .split('\n')
        .map(PersonalReminder.deserialize)
        .whereType<PersonalReminder>()
        .toList();
  }

  static List<PersonalReminder> plansOn(DateTime date) {
    final key = PersonalReminder.isoDate(date);
    final items = loadAll()
        .where(
          (item) =>
              item.kind == ReminderKind.event &&
              PersonalReminder.isoDate(item.date) == key,
        )
        .toList();
    items.sort((a, b) {
      if (a.allDay != b.allDay) return a.allDay ? -1 : 1;
      return (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute);
    });
    return items;
  }

  static List<PersonalReminder> _migrateLegacy() {
    final legacy =
        SpUtils.getString('jichen_personal_reminders', defValue: '') ?? '';
    if (legacy.isEmpty) return [];
    final items = legacy
        .split('\n')
        .map(PersonalReminder.deserialize)
        .whereType<PersonalReminder>()
        .toList();
    if (items.isNotEmpty) _persist(items);
    return items;
  }

  static Future<void> _persist(List<PersonalReminder> items) async {
    await SpUtils.putString(
      _listKey,
      items.map((e) => e.serialize()).join('\n'),
    );
  }

  static ReminderDraft? get pendingDraft {
    final raw = SpUtils.getString(_draftKey, defValue: '') ?? '';
    if (raw.isEmpty) return null;
    final p = raw.split('\t');
    if (p.length < 3) return null;
    final dp = p[2].split('-');
    final y = int.tryParse(dp[0]);
    final mo = int.tryParse(dp[1]);
    final d = int.tryParse(dp[2]);
    if (y == null || mo == null || d == null) return null;
    return ReminderDraft(
      title: p[0],
      source: p[1],
      date: DateTime(y, mo, d),
      matterId: p.length > 3 && p[3].isNotEmpty ? p[3] : null,
    );
  }

  static Future<void> setPendingDraft(ReminderDraft draft) async {
    final line =
        '${draft.title}\t${draft.source}\t${PersonalReminder.isoDate(draft.date)}\t${draft.matterId ?? ''}';
    await SpUtils.putString(_draftKey, line);
  }

  static Future<void> clearPendingDraft() async {
    await SpUtils.putString(_draftKey, '');
  }

  /// 保存并处理通知权限；返回 (saved, notifyPending)。
  static Future<({bool saved, bool notifyPending})> save(
    PersonalReminder reminder,
  ) async {
    var r = reminder;
    var notifyPending = false;
    if (r.notifyEnabled) {
      final scheduled = await NotificationService.scheduleIfAllowed(r);
      if (!scheduled) notifyPending = true;
      r = r.copyWith(notifyPending: notifyPending);
    }
    final all = loadAll()..add(r);
    await _persist(all);
    await clearPendingDraft();
    revision.value++;
    return (saved: true, notifyPending: notifyPending);
  }

  static Future<void> update(PersonalReminder updated) async {
    final all = loadAll();
    final i = all.indexWhere((e) => e.id == updated.id);
    if (i < 0) return;
    await NotificationService.cancel(all[i]);
    var r = updated;
    if (r.notifyEnabled) {
      final ok = await NotificationService.scheduleIfAllowed(r);
      r = r.copyWith(notifyPending: !ok && r.notifyEnabled);
    } else {
      r = r.copyWith(notifyPending: false);
    }
    all[i] = r;
    await _persist(all);
    revision.value++;
  }

  static Future<void> delete(String id) async {
    final all = loadAll();
    final item = all.where((e) => e.id == id).firstOrNull;
    if (item != null) await NotificationService.cancel(item);
    all.removeWhere((e) => e.id == id);
    await _persist(all);
    revision.value++;
  }

  /// 导入合并：同 ID 跳过（LOOP-006）。
  static Future<({int added, int skipped})> importMerge(
    List<PersonalReminder> incoming,
  ) async {
    final all = loadAll();
    final existingIds = all.map((e) => e.id).toSet();
    var added = 0;
    var skipped = 0;
    for (final r in incoming) {
      if (existingIds.contains(r.id)) {
        skipped++;
        continue;
      }
      all.add(r);
      existingIds.add(r.id);
      added++;
      if (r.notifyEnabled) {
        final scheduled = await NotificationService.scheduleIfAllowed(r);
        if (!scheduled) {
          final i = all.indexWhere((e) => e.id == r.id);
          if (i >= 0) {
            all[i] = r.copyWith(notifyPending: true);
          }
        }
      }
    }
    if (added > 0) await _persist(all);
    if (added > 0 || skipped > 0) revision.value++;
    return (added: added, skipped: skipped);
  }

  /// 全量替换（回滚导入）。
  static Future<void> replaceAll(List<PersonalReminder> items) async {
    final old = loadAll();
    for (final r in old) {
      await NotificationService.cancel(r);
    }
    await _persist(items);
    for (final r in items) {
      if (r.notifyEnabled) {
        await NotificationService.scheduleIfAllowed(r);
      }
    }
    revision.value++;
  }

  static Future<bool> saveFromDraft(ReminderDraft draft) async {
    final result = await save(draft.toReminder());
    return result.saved;
  }

  static Future<void> complete(PersonalReminder reminder) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (reminder.repeatRule != ReminderRepeatRule.none) {
      final next = ReminderRepeat.nextAfter(reminder, today);
      if (next != null) {
        await update(reminder.copyWith(date: next, completed: false));
        return;
      }
    }
    await update(reminder.copyWith(completed: true));
  }

  static Future<void> postpone(
    PersonalReminder reminder,
    DateTime newDate,
  ) async {
    await update(
      reminder.copyWith(
        date: DateTime(newDate.year, newDate.month, newDate.day),
        completed: false,
      ),
    );
  }

  /// 择吉冲突：±[withinDays] 天内已有提醒。
  static ({bool conflict, String? label}) conflictNear(
    DateTime date, {
    int withinDays = 1,
  }) {
    final target = DateTime(date.year, date.month, date.day);
    for (final r in loadAll()) {
      if (r.completed) continue;
      final d = DateTime(r.date.year, r.date.month, r.date.day);
      final diff = d.difference(target).inDays.abs();
      if (diff <= withinDays) {
        final dayWord = diff == 0 ? '当天' : '相差 $diff 天';
        return (conflict: true, label: '与「${r.title}」$dayWord');
      }
    }
    return (conflict: false, label: null);
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
