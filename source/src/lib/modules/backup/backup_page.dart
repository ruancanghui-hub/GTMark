import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../main/main_controller.dart';
import '../../core/backup/backup_parse_failure.dart';
import '../../core/backup/backup_prefs.dart';
import '../../core/backup/backup_service.dart';
import '../../core/backup/backup_snapshot.dart';
import '../../shared/theme/jichen_tokens.dart';
import '../../shared/ui/jichen_secondary_scaffold.dart';

import 'backup_password_dialog.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  static const _privacyNote = '''
您的提醒、纪念日、收藏日期与天气城市设置均保存在本机。导出备份为 AES-256 加密 JSON，请设置并牢记备份密码；忘记密码将无法恢复文件内容。

备份文件不含账号密码；导入前会预览数量，失败不会覆盖现有数据；导入后可撤销最近一次操作。
''';

  bool _busy = false;
  BackupImportPreview? _preview;
  BackupSnapshot? _pendingSnapshot;
  String? _error;

  BackupLocalStats get _stats => BackupService.currentStats();

  bool get _isEmpty =>
      _stats.totalReminders == 0 && _stats.favorites == 0 && !_stats.hasCity;

  String _formatLastExport() {
    final at = BackupPrefs.lastExportAt;
    if (at == null) return '尚未导出';
    return DateFormat('yyyy-MM-dd HH:mm').format(at.toLocal());
  }

  Future<void> _export() async {
    if (_busy) return;
    final password = await showBackupPasswordDialog(
      context,
      title: '设置备份密码',
      confirmMatch: true,
      confirmLabel: '再次输入密码',
    );
    if (password == null || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final snapshot = BackupService.captureCurrent();
      final shared = await BackupService.shareExportFile(snapshot, password);
      if (!mounted) return;
      setState(() {});
      if (!shared) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('已取消导出，可稍后重试')));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = '导出失败：$e');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickImport() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _preview = null;
      _pendingSnapshot = null;
    });
    try {
      final raw = await BackupService.pickAndReadImportFile();
      if (!mounted) return;
      if (raw == null) return;
      await _parseImportRaw(raw);
    } catch (e) {
      if (mounted) {
        final lower = e.toString().toLowerCase();
        final permissionLike =
            lower.contains('permission') ||
            lower.contains('denied') ||
            lower.contains('access') ||
            lower.contains('authorized');
        setState(
          () => _error = permissionLike
              ? '无法读取所选文件，请检查存储权限后重新选择'
              : '读取文件失败，请重新选择备份文件',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _parseImportRaw(String raw, {String? password}) async {
    try {
      final snapshot = BackupService.parse(raw, password: password);
      final preview = BackupService.previewImport(snapshot);
      if (!mounted) return;
      setState(() {
        _pendingSnapshot = snapshot;
        _preview = preview;
        _error = null;
      });
    } on BackupParseFailure catch (e) {
      if (!mounted) return;
      if (password == null &&
          (e.message.contains('加密') || BackupService.looksEncrypted(raw))) {
        setState(() => _busy = false);
        final pwd = await showBackupPasswordDialog(context, title: '输入备份密码');
        if (pwd == null || !mounted) return;
        setState(() => _busy = true);
        await _parseImportRaw(raw, password: pwd);
        return;
      }
      setState(() => _error = e.message);
    }
  }

  Future<void> _confirmImport() async {
    final snapshot = _pendingSnapshot;
    if (snapshot == null || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await BackupService.applyImport(snapshot);
      if (!mounted) return;
      setState(() {
        _preview = null;
        _pendingSnapshot = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '已导入 ${result.addedReminders} 条提醒'
            '${result.skippedReminders > 0 ? '，跳过 ${result.skippedReminders} 条重复' : ''}'
            '${result.addedFavorites > 0 ? '，新增 ${result.addedFavorites} 个收藏日期' : ''}',
          ),
          action: SnackBarAction(label: '撤销', onPressed: _undoImport),
        ),
      );
    } on BackupParseFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      if (mounted) setState(() => _error = '导入失败，现有数据未改动：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _undoImport() async {
    final ok = await BackupService.undoLastImport();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(ok ? '已撤销最近一次导入' : '没有可撤销的导入')));
    if (ok) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return JichenSecondaryScaffold(
      title: '数据备份',
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Section(
            title: '本地数据',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatRow(label: '事件提醒', value: '${_stats.reminders} 条'),
                _StatRow(
                  label: '生日/纪念日/倒数',
                  value: '${_stats.anniversaries} 条',
                ),
                _StatRow(label: '收藏日期', value: '${_stats.favorites} 个'),
                _StatRow(label: '天气城市', value: _stats.hasCity ? '已设置' : '未设置'),
                const SizedBox(height: 8),
                Text(
                  '上次导出：${_formatLastExport()}',
                  style: context.jichenCaption(),
                ),
                if (_isEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    '暂无提醒、纪念日或收藏日期可备份。创建提醒或收藏日期后，可在此导出 JSON 文件，换机或重装时恢复。',
                    style: context.jichenCaption(),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).maybePop();
                      Get.find<MainController>().switchTab(0);
                    },
                    child: const Text('回日历添加提醒'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Section(
            title: '导出与导入',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: _busy ? null : _export,
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_file),
                  label: const Text('导出备份文件'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _pickImport,
                  icon: _busy && _preview == null
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: const Text('选择备份文件导入'),
                ),
                if (_preview != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    '导入预览',
                    style: context.jichenBody().copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '备份时间：${DateFormat('yyyy-MM-dd HH:mm').format(_preview!.exportedAt ?? DateTime.now())}',
                    style: context.jichenCaption(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '文件含 ${_preview!.importReminders} 条提醒、'
                    '${_preview!.importAnniversaries} 条纪念日、'
                    '${_preview!.importFavorites} 个收藏日期'
                    '${_preview!.importHasCity ? '、城市设置' : ''}',
                    style: context.jichenBody(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '将新增 ${_preview!.addReminders} 条提醒'
                    '${_preview!.skipReminders > 0 ? '，跳过 ${_preview!.skipReminders} 条同 ID' : ''}'
                    '${_preview!.addFavorites > 0 ? '，合并 ${_preview!.addFavorites} 个收藏' : ''}',
                    style: context.jichenCaption(),
                  ),
                  if (_preview!.willSyncSettings) ...[
                    const SizedBox(height: 4),
                    Text(
                      '还将同步：天气城市、节日提醒开关、通知与择吉偏好',
                      style: context.jichenCaption(),
                    ),
                  ],
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: (_busy || !_preview!.valid)
                        ? null
                        : _confirmImport,
                    child: const Text('确认导入'),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: context.jichenBody().copyWith(
                      color: JichenTokens.jiText,
                    ),
                  ),
                  TextButton(
                    onPressed: _busy ? null : _pickImport,
                    child: const Text('重新选择文件'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Section(
            title: '隐私说明',
            child: Text(_privacyNote, style: context.jichenCaption()),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('不再提示定期备份', style: context.jichenBody()),
            value: BackupPrefs.promptDisabled,
            activeTrackColor: JichenTokens.accent.withValues(alpha: 0.5),
            thumbColor: WidgetStateProperty.all(JichenTokens.accent),
            onChanged: (v) async {
              await BackupPrefs.setPromptDisabled(v);
              if (mounted) setState(() {});
            },
          ),
          if (BackupPrefs.rollbackJson != null)
            TextButton(
              onPressed: _busy ? null : _undoImport,
              child: const Text('撤销最近一次导入'),
            ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: JichenTokens.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.jichenTitle3()),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.jichenBody()),
          Text(value, style: context.jichenCaption()),
        ],
      ),
    );
  }
}
