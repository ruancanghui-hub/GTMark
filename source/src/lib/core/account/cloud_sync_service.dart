import 'dart:convert';

import '../../shared/utils/sp_utils.dart';
import '../backup/backup_service.dart';
import '../backup/backup_snapshot.dart';
import 'account_session.dart';

/// 提醒/纪念日云端同步（SPEC-021 / LOOP-006）。
abstract final class CloudSyncService {
  static const _table = 'jichen_user_data';
  static const _optInKey = 'jichen_cloud_sync_opt_in';

  static bool get optInEnabled =>
      SpUtils.getBool(_optInKey, defValue: false);

  static Future<void> setOptIn(bool enabled) async {
    await SpUtils.putBool(_optInKey, enabled);
  }

  static Future<DateTime?> lastCloudUpdatedAt() async {
    if (!AccountSession.isSignedIn) return null;
    final row = await AccountSession.client
        .from(_table)
        .select('updated_at')
        .maybeSingle();
    if (row == null) return null;
    final raw = row['updated_at'];
    if (raw is! String) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

  /// 上传当前本地快照（需已登录且 opt-in）。
  static Future<void> pushToCloud() async {
    _ensureReady();
    final snapshot = BackupService.captureCurrent();
    final payload = snapshot.toJson();
    final uid = AccountSession.userId!;
    await AccountSession.client.from(_table).upsert({
      'user_id': uid,
      'backup_json': payload,
    });
  }

  /// 从云端拉取并合并（同 ID 跳过，与本地导入一致）。
  static Future<CloudPullResult> pullAndMerge() async {
    _ensureReady();
    final uid = AccountSession.userId!;
    final row = await AccountSession.client
        .from(_table)
        .select('backup_json, updated_at')
        .eq('user_id', uid)
        .maybeSingle();
    if (row == null || row['backup_json'] == null) {
      return const CloudPullResult(empty: true);
    }
    final json = row['backup_json'];
    Map<String, dynamic> map;
    if (json is Map<String, dynamic>) {
      map = json;
    } else if (json is Map) {
      map = Map<String, dynamic>.from(json);
    } else if (json is String) {
      map = jsonDecode(json) as Map<String, dynamic>;
    } else {
      throw StateError('云端数据格式异常');
    }
    final snapshot = BackupSnapshot.fromJson(map);
    if (snapshot == null) {
      throw StateError('云端备份版本不兼容');
    }
    final preview = BackupService.previewImport(snapshot);
    if (!preview.valid) {
      return CloudPullResult(
        empty: false,
        skipped: true,
        preview: preview,
      );
    }
    final result = await BackupService.applyImport(snapshot);
    final updatedRaw = row['updated_at'];
    final updatedAt = updatedRaw is String ? DateTime.tryParse(updatedRaw) : null;
    return CloudPullResult(
      empty: false,
      importResult: result,
      preview: preview,
      cloudUpdatedAt: updatedAt?.toLocal(),
    );
  }

  static void _ensureReady() {
    if (!AccountSession.isConfigured) {
      throw StateError('未配置云端服务');
    }
    if (!AccountSession.isSignedIn) {
      throw StateError('请先登录账号');
    }
    if (!optInEnabled) {
      throw StateError('请先在账号同步页开启云端同步');
    }
  }
}

class CloudPullResult {
  const CloudPullResult({
    this.empty = false,
    this.skipped = false,
    this.importResult,
    this.preview,
    this.cloudUpdatedAt,
  });

  final bool empty;
  final bool skipped;
  final BackupImportResult? importResult;
  final BackupImportPreview? preview;
  final DateTime? cloudUpdatedAt;
}
