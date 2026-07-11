import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../shared/utils/sp_utils.dart';
import '../prefs/date_favorites.dart';
import '../prefs/festival_reminder_prefs.dart';
import '../prefs/jichen_prefs.dart';
import '../reminder/reminder_kind.dart';
import '../reminder/reminder_store.dart';
import 'backup_crypto.dart';
import 'backup_format.dart';
import 'backup_parse_failure.dart';
import 'backup_prefs.dart';
import 'backup_snapshot.dart';

class BackupImportResult {
  const BackupImportResult({
    required this.addedReminders,
    required this.skippedReminders,
    required this.addedFavorites,
  });

  final int addedReminders;
  final int skippedReminders;
  final int addedFavorites;
}

/// 本地备份导出、导入与回滚（LOOP-006）。
abstract final class BackupService {
  static BackupLocalStats currentStats() {
    final items = ReminderStore.loadAll();
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
      favorites: DateFavorites.count,
      hasCity: JichenPrefs.weatherCityName.isNotEmpty,
    );
  }

  static BackupSnapshot captureCurrent() {
    return BackupSnapshot(
      version: BackupFormat.version,
      exportedAt: DateTime.now(),
      reminderLines: ReminderStore.loadAll().map((e) => e.serialize()).toList(),
      favoriteDates: DateFavorites.allSorted(),
      prefs: _prefsToMap(),
      festivalDisabled: FestivalReminderPrefs.disabledIds(),
    );
  }

  static Map<String, dynamic> _prefsToMap() => {
        'xiaonianRegion': JichenPrefs.xiaonianRegion.storageKey,
        'skipWorkdayAdjust': JichenPrefs.skipWorkdayAdjust,
        'notifyMasterEnabled': JichenPrefs.notifyMasterEnabled,
        'weatherCityName': JichenPrefs.weatherCityName,
        'weatherLat': JichenPrefs.weatherLat,
        'weatherLon': JichenPrefs.weatherLon,
      };

  static String encodePretty(BackupSnapshot snapshot) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(snapshot.toJson());
  }

  static String exportFileName([DateTime? at]) {
    final t = at ?? DateTime.now();
    final stamp =
        '${t.year}${t.month.toString().padLeft(2, '0')}${t.day.toString().padLeft(2, '0')}-'
        '${t.hour.toString().padLeft(2, '0')}${t.minute.toString().padLeft(2, '0')}${t.second.toString().padLeft(2, '0')}';
    return '${BackupFormat.encryptedFormatId}-$stamp.json';
  }

  static String encodeEncrypted(BackupSnapshot snapshot, String password) {
    final plain = encodePretty(snapshot);
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(BackupCrypto.encryptPayload(plain, password));
  }

  /// 解析备份文本；加密文件需传 [password]。失败抛 [BackupParseFailure]。
  static BackupSnapshot parse(String raw, {String? password}) {
    if (raw.length > BackupFormat.maxBytes) {
      throw BackupParseFailure('备份文件过大（上限 ${BackupFormat.maxBytes ~/ 1024 ~/ 1024}MB）');
    }
    final dynamic decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      throw BackupParseFailure('不是有效的 JSON 备份文件');
    }
    if (decoded is! Map<String, dynamic>) {
      throw BackupParseFailure('备份结构不正确');
    }
    if (BackupCrypto.isEncryptedEnvelope(decoded)) {
      if (password == null || password.isEmpty) {
        throw BackupParseFailure('该备份已加密，请输入备份密码');
      }
      final plain = BackupCrypto.decryptPayload(decoded, password);
      return parse(plain);
    }
    final snapshot = BackupSnapshot.fromJson(decoded);
    if (snapshot == null) {
      throw BackupParseFailure('不支持的备份版本或格式，请使用 ${BackupFormat.formatId}');
    }
    return snapshot;
  }

  static BackupImportPreview previewImport(BackupSnapshot snapshot) {
    final incoming = snapshot.parseReminders();
    final existingIds = ReminderStore.loadAll().map((e) => e.id).toSet();
    var add = 0;
    var skip = 0;
    var importEvents = 0;
    var importAnn = 0;
    for (final r in incoming) {
      if (r.kind == ReminderKind.event) {
        importEvents++;
      } else {
        importAnn++;
      }
      if (existingIds.contains(r.id)) {
        skip++;
      } else {
        add++;
      }
    }
    final existingFav = DateFavorites.allSorted().toSet();
    final addFav =
        snapshot.favoriteDates.where((d) => !existingFav.contains(d)).length;
    final willSync = _prefsWillChange(snapshot.prefs) ||
        snapshot.festivalDisabled.toSet() !=
            FestivalReminderPrefs.disabledIds().toSet();
    return BackupImportPreview(
      exportedAt: snapshot.exportedAt,
      importReminders: importEvents,
      importAnniversaries: importAnn,
      importFavorites: snapshot.favoriteDates.length,
      importHasCity: snapshot.stats().hasCity,
      addReminders: add,
      skipReminders: skip,
      addFavorites: addFav,
      willSyncSettings: willSync,
    );
  }

  static bool _prefsWillChange(Map<String, dynamic> prefs) {
    if (prefs.isEmpty) return false;
    final region = prefs['xiaonianRegion'] as String?;
    if (region != null && region != JichenPrefs.xiaonianRegion.storageKey) {
      return true;
    }
    if (prefs.containsKey('skipWorkdayAdjust') &&
        (prefs['skipWorkdayAdjust'] == true) != JichenPrefs.skipWorkdayAdjust) {
      return true;
    }
    if (prefs.containsKey('notifyMasterEnabled') &&
        (prefs['notifyMasterEnabled'] != false) !=
            JichenPrefs.notifyMasterEnabled) {
      return true;
    }
    final city = prefs['weatherCityName'] as String?;
    final lat = prefs['weatherLat'];
    final lon = prefs['weatherLon'];
    if (city != null &&
        city.isNotEmpty &&
        lat is num &&
        lon is num &&
        (city != JichenPrefs.weatherCityName ||
            lat.toDouble() != JichenPrefs.weatherLat ||
            lon.toDouble() != JichenPrefs.weatherLon)) {
      return true;
    }
    return false;
  }

  static Future<bool> shareExportFile(
    BackupSnapshot snapshot,
    String password,
  ) async {
    final path = await writeTempExportFile(snapshot, password);
    final result = await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(
            path,
            mimeType: 'application/json',
            name: exportFileName(snapshot.exportedAt),
          ),
        ],
        subject: '吉辰万年历数据备份',
        text: '吉辰万年历加密备份（${BackupFormat.encryptedFormatId}）',
      ),
    );
    if (result.status == ShareResultStatus.success ||
        result.status == ShareResultStatus.unavailable) {
      await BackupPrefs.markExported(snapshot.exportedAt);
      return true;
    }
    return false;
  }

  static Future<BackupImportResult> applyImport(BackupSnapshot snapshot) async {
    final preview = previewImport(snapshot);
    if (!preview.valid) {
      throw BackupParseFailure('没有可导入的新数据');
    }

    final rollbackJson = encodePretty(captureCurrent());
    await BackupPrefs.saveRollbackJson(rollbackJson);

    try {
      final incoming = snapshot.parseReminders();
      final merge = await ReminderStore.importMerge(incoming);
      final addedFav = await DateFavorites.importMerge(snapshot.favoriteDates);
      await _applyPrefs(snapshot.prefs);
      await FestivalReminderPrefs.replaceDisabled(
        snapshot.festivalDisabled.toSet(),
      );
      return BackupImportResult(
        addedReminders: merge.added,
        skippedReminders: merge.skipped,
        addedFavorites: addedFav,
      );
    } catch (e) {
      await _restoreFromJson(rollbackJson);
      await BackupPrefs.clearRollback();
      rethrow;
    }
  }

  static Future<bool> undoLastImport() async {
    final raw = BackupPrefs.rollbackJson;
    if (raw == null) return false;
    try {
      await _restoreFromJson(raw);
      await BackupPrefs.clearRollback();
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _restoreFromJson(String raw) async {
    final snapshot = parse(raw);
    await ReminderStore.replaceAll(snapshot.parseReminders());
    await DateFavorites.replaceAll(snapshot.favoriteDates);
    await _applyPrefs(snapshot.prefs);
    await FestivalReminderPrefs.replaceDisabled(
      snapshot.festivalDisabled.toSet(),
    );
  }

  static Future<void> _applyPrefs(Map<String, dynamic> prefs) async {
    final regionKey = prefs['xiaonianRegion'] as String?;
    if (regionKey != null) {
      await JichenPrefs.setXiaonianRegion(
        XiaonianRegion.fromStorage(regionKey),
      );
    }
    if (prefs.containsKey('skipWorkdayAdjust')) {
      await JichenPrefs.setSkipWorkdayAdjust(
        prefs['skipWorkdayAdjust'] == true,
      );
    }
    if (prefs.containsKey('notifyMasterEnabled')) {
      await JichenPrefs.setNotifyMasterEnabled(
        prefs['notifyMasterEnabled'] != false,
      );
    }
    final city = prefs['weatherCityName'] as String?;
    final lat = prefs['weatherLat'];
    final lon = prefs['weatherLon'];
    if (city != null && city.isNotEmpty && lat is num && lon is num) {
      await JichenPrefs.setWeatherCity(city, lat.toDouble(), lon.toDouble());
    }
  }

  static Future<String> writeTempExportFile(
    BackupSnapshot snapshot,
    String password,
  ) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${exportFileName(snapshot.exportedAt)}');
    await file.writeAsString(encodeEncrypted(snapshot, password), flush: true);
    return file.path;
  }

  static bool looksEncrypted(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> &&
          BackupCrypto.isEncryptedEnvelope(decoded);
    } catch (_) {
      return false;
    }
  }

  static Future<String?> pickAndReadImportFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: !kIsWeb,
      withReadStream: false,
    );
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.single;
    if (file.bytes != null) {
      return utf8.decode(file.bytes!, allowMalformed: false);
    }
    final path = file.path;
    if (path == null) return null;
    final f = File(path);
    if (!await f.exists()) return null;
    final len = await f.length();
    if (len > BackupFormat.maxBytes) {
      throw BackupParseFailure('备份文件过大');
    }
    return f.readAsString();
  }

  /// 测试/调试：清空全部用户数据。
  static Future<void> clearAllUserDataForTest() async {
    await SpUtils.putString('jichen_personal_reminders_v2', '');
    ReminderStore.revision.value++;
    await DateFavorites.replaceAll([]);
    await BackupPrefs.clearRollback();
  }
}
