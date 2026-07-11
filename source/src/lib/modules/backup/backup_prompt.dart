import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/routes/app_routes.dart';
import '../../core/backup/backup_prefs.dart';
import '../../core/reminder/reminder_store.dart';

/// 首次提醒 / 30 天未备份轻提示（LOOP-006 下一步）。
abstract final class BackupPrompt {
  static Future<void> maybeShow(BuildContext context) async {
    if (BackupPrefs.promptDisabled) return;
    final count = ReminderStore.loadAll().length;
    if (count == 0) return;

    final last = BackupPrefs.lastExportAt;
    final isFirst = last == null && count == 1;
    final stale = last != null && DateTime.now().difference(last).inDays >= 30;
    if (!isFirst && !stale) return;
    if (!context.mounted) return;

    final message = isFirst ? '已创建提醒，建议导出备份以防丢失' : '距上次备份已超过 30 天，建议再次导出';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: '去备份',
          onPressed: () => Modular.to.pushNamed('${AppRoutes.main}backup'),
        ),
      ),
    );
  }
}
