/// 本地备份文件格式（LOOP-006 / SPEC-018）。
abstract final class BackupFormat {
  static const formatId = 'jichen-backup-v1';
  static const encryptedFormatId = 'jichen-backup-v1-enc';
  static const version = 1;
  static const maxBytes = 5 * 1024 * 1024;
}
