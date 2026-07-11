import '../../shared/utils/sp_utils.dart';

/// 备份相关用户偏好（导出时间、提示开关）。
abstract final class BackupPrefs {
  static const _lastExportKey = 'jichen_last_backup_export_at';
  static const _promptOffKey = 'jichen_backup_prompt_off';
  static const _rollbackKey = 'jichen_backup_rollback_json';

  static DateTime? get lastExportAt {
    final raw = SpUtils.getString(_lastExportKey, defValue: '') ?? '';
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  static bool get promptDisabled =>
      SpUtils.getBool(_promptOffKey, defValue: false);

  static Future<void> markExported(DateTime at) async {
    await SpUtils.putString(_lastExportKey, at.toUtc().toIso8601String());
  }

  static Future<void> setPromptDisabled(bool off) async {
    await SpUtils.putBool(_promptOffKey, off);
  }

  static Future<void> saveRollbackJson(String json) async {
    await SpUtils.putString(_rollbackKey, json);
  }

  static String? get rollbackJson =>
      SpUtils.getString(_rollbackKey, defValue: '')?.nullIfEmpty;

  static Future<void> clearRollback() async {
    await SpUtils.putString(_rollbackKey, '');
  }
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
