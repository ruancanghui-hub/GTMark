import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/backup/backup_parse_failure.dart';
import 'package:lianji/core/backup/backup_prefs.dart';
import 'package:lianji/core/backup/backup_service.dart';
import 'package:lianji/core/backup/backup_snapshot.dart';
import 'package:lianji/core/prefs/date_favorites.dart';
import 'package:lianji/core/prefs/festival_reminder_prefs.dart';
import 'package:lianji/core/prefs/jichen_prefs.dart';
import 'package:lianji/core/reminder/personal_reminder.dart';
import 'package:lianji/core/reminder/reminder_kind.dart';
import 'package:lianji/core/reminder/reminder_store.dart';
import 'package:lianji/shared/utils/sp_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtils.getInstance();
    await JichenPrefs.load();
    FestivalReminderPrefs.load();
    await BackupService.clearAllUserDataForTest();
    await BackupPrefs.clearRollback();
  });

  PersonalReminder sample({String id = 'r1', ReminderKind kind = ReminderKind.event}) {
    return PersonalReminder(
      id: id,
      title: kind == ReminderKind.birthday ? '妈妈生日' : '测试提醒',
      date: DateTime(2026, 6, 21),
      kind: kind,
      notifyEnabled: false,
      birthdayRelation: kind == ReminderKind.birthday ? 'parent' : null,
    );
  }

  test('encrypted backup roundtrip', () {
    final snapshot = BackupSnapshot(
      version: 1,
      exportedAt: DateTime.now(),
      reminderLines: [sample().serialize()],
      favoriteDates: ['2026-04-04'],
      prefs: {'weatherCityName': '北京', 'weatherLat': 39.9, 'weatherLon': 116.4},
      festivalDisabled: [],
    );
    final enc = BackupService.encodeEncrypted(snapshot, 'secret12');
    expect(BackupService.looksEncrypted(enc), isTrue);
    final parsed = BackupService.parse(enc, password: 'secret12');
    expect(parsed.parseReminders().length, 1);
    expect(
      () => BackupService.parse(enc, password: 'wrongpass'),
      throwsA(isA<BackupParseFailure>()),
    );
  });

  test('capture and parse roundtrip', () async {
    await ReminderStore.save(sample());
    await ReminderStore.save(sample(id: 'r2', kind: ReminderKind.anniversary));
    await DateFavorites.importMerge(['2026-01-01']);
    await JichenPrefs.setWeatherCity('上海', 31.2, 121.5);

    final snapshot = BackupService.captureCurrent();
    final json = BackupService.encodePretty(snapshot);
    final parsed = BackupService.parse(json);

    expect(parsed.parseReminders().length, 2);
    expect(parsed.favoriteDates, contains('2026-01-01'));
    expect(parsed.prefs['weatherCityName'], '上海');
  });

  test('corrupt json throws without mutating data', () async {
    await ReminderStore.save(sample());
    expect(
      () => BackupService.parse('{not json'),
      throwsA(isA<BackupParseFailure>()),
    );
    expect(ReminderStore.loadAll().length, 1);
  });

  test('wrong format rejected', () {
    expect(
      () => BackupService.parse('{"format":"other","version":1,"exportedAt":"2026-01-01T00:00:00.000Z","data":{}}'),
      throwsA(isA<BackupParseFailure>()),
    );
  });

  test('import merge skips duplicate id', () async {
    await ReminderStore.save(sample(id: 'same'));
    final export = BackupService.captureCurrent();
    await ReminderStore.delete('same');
    expect(ReminderStore.loadAll(), isEmpty);

    final preview = BackupService.previewImport(export);
    expect(preview.addReminders, 1);

    await ReminderStore.save(sample(id: 'same'));
    final preview2 = BackupService.previewImport(export);
    expect(preview2.addReminders, 0);
    expect(preview2.skipReminders, 1);

    final result = await BackupService.applyImport(export);
    expect(result.addedReminders, 0);
    expect(result.skippedReminders, 1);
    expect(ReminderStore.loadAll().length, 1);
  });

  test('import adds new reminders', () async {
    await ReminderStore.save(sample(id: 'local'));
    final incoming = BackupService.parse(
      BackupService.encodePretty(
        BackupSnapshot(
          version: 1,
          exportedAt: DateTime.now(),
          reminderLines: [sample(id: 'incoming').serialize()],
          favoriteDates: ['2026-03-03'],
          prefs: BackupService.captureCurrent().prefs,
          festivalDisabled: [],
        ),
      ),
    );
    final result = await BackupService.applyImport(incoming);
    expect(result.addedReminders, 1);
    expect(ReminderStore.loadAll().length, 2);
    expect(DateFavorites.allSorted(), contains('2026-03-03'));
  });

  test('undo restores pre-import state', () async {
    await ReminderStore.save(sample(id: 'keep'));
    final before = BackupService.captureCurrent();

    final incoming = BackupService.parse(
      BackupService.encodePretty(
        BackupSnapshot(
          version: 1,
          exportedAt: DateTime.now(),
          reminderLines: [sample(id: 'new1').serialize()],
          favoriteDates: ['2026-03-03'],
          prefs: before.prefs,
          festivalDisabled: [],
        ),
      ),
    );
    await BackupService.applyImport(incoming);
    expect(ReminderStore.loadAll().length, 2);

    final undone = await BackupService.undoLastImport();
    expect(undone, isTrue);
    expect(ReminderStore.loadAll().length, 1);
    expect(ReminderStore.loadAll().first.id, 'keep');
  });

  test('currentStats counts kinds', () async {
    await ReminderStore.save(sample(kind: ReminderKind.event));
    await ReminderStore.save(sample(id: 'b', kind: ReminderKind.birthday));
    final stats = BackupService.currentStats();
    expect(stats.reminders, 1);
    expect(stats.anniversaries, 1);
  });
}
