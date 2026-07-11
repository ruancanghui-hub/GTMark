import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../core/account/account_session.dart';
import '../../core/account/cloud_sync_service.dart';
import '../../core/account/supabase_env.dart';
import '../../shared/theme/jichen_tokens.dart';

/// 账号登录与云端同步（SPEC-021 / LOOP-006）。
class AccountSyncPage extends StatefulWidget {
  const AccountSyncPage({super.key});

  @override
  State<AccountSyncPage> createState() => _AccountSyncPageState();
}

class _AccountSyncPageState extends State<AccountSyncPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _signUpMode = false;
  bool _busy = false;
  String? _error;
  DateTime? _cloudUpdatedAt;

  @override
  void initState() {
    super.initState();
    AccountSession.signedInTick.listen((_) {
      if (mounted) setState(() {});
    });
    _refreshCloudMeta();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _refreshCloudMeta() async {
    if (!AccountSession.isSignedIn) return;
    try {
      final at = await CloudSyncService.lastCloudUpdatedAt();
      if (mounted) setState(() => _cloudUpdatedAt = at);
    } catch (_) {}
  }

  Future<void> _submitAuth() async {
    if (_busy) return;
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    if (email.isEmpty || password.length < 6) {
      setState(() => _error = '请输入邮箱与至少 6 位密码');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (_signUpMode) {
        await AccountSession.signUpWithEmail(email, password);
      } else {
        await AccountSession.signInWithEmail(email, password);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_signUpMode ? '注册成功' : '登录成功')),
      );
      await _refreshCloudMeta();
    } catch (e) {
      if (mounted) setState(() => _error = '登录失败：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    await AccountSession.signOut();
    if (mounted) {
      setState(() => _cloudUpdatedAt = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已退出登录')),
      );
    }
  }

  Future<void> _push() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await CloudSyncService.pushToCloud();
      await _refreshCloudMeta();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已上传到云端')),
      );
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pull() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await CloudSyncService.pullAndMerge();
      if (!mounted) return;
      if (result.empty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('云端暂无数据')),
        );
      } else if (result.skipped) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('云端数据与本地一致，无需合并')),
        );
      } else {
        final r = result.importResult!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '已从云端合并 ${r.addedReminders} 条提醒'
              '${r.addedFavorites > 0 ? '、${r.addedFavorites} 个收藏' : ''}',
            ),
          ),
        );
      }
      await _refreshCloudMeta();
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configured = SupabaseEnv.isConfigured;
    final signedIn = AccountSession.isSignedIn;
    final optIn = CloudSyncService.optInEnabled;

    return Scaffold(
      backgroundColor: JichenTokens.background,
      appBar: AppBar(
        title: Text('账号同步', style: context.jichenTitle3()),
        backgroundColor: JichenTokens.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            '登录后可将提醒、纪念日与收藏同步至云端，换机时在「从云端恢复」合并数据。'
            '同步需您主动开启；未开启时数据仅保存在本机。',
            style: context.jichenCaption(),
          ),
          const SizedBox(height: 16),
          if (!configured)
            _card(
              child: Text(
                '未配置 Supabase（编译时传入 SUPABASE_URL 与 SUPABASE_ANON_KEY）。'
                '当前仅支持本地加密备份。',
                style: context.jichenBody(),
              ),
            )
          else if (!signedIn) ...[
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _signUpMode ? '注册邮箱账号' : '邮箱登录',
                    style: context.jichenTitle3(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: '邮箱'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: '密码（至少 6 位）'),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, style: TextStyle(color: JichenTokens.jiText)),
                  ],
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _busy ? null : _submitAuth,
                    child: Text(_signUpMode ? '注册' : '登录'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _signUpMode = !_signUpMode),
                    child: Text(_signUpMode ? '已有账号？去登录' : '没有账号？注册'),
                  ),
                ],
              ),
            ),
          ] else ...[
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('已登录', style: context.jichenTitle3()),
                  const SizedBox(height: 8),
                  Text(AccountSession.userEmail ?? '', style: context.jichenBody()),
                  if (_cloudUpdatedAt != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '云端最近更新：${DateFormat('yyyy-MM-dd HH:mm').format(_cloudUpdatedAt!)}',
                        style: context.jichenCaption(),
                      ),
                    ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('开启云端同步', style: context.jichenBody()),
                    subtitle: Text(
                      '开启后您可使用上传/恢复；数据经 HTTPS 存于 Supabase',
                      style: context.jichenCaption(),
                    ),
                    value: optIn,
                    activeTrackColor: JichenTokens.accent.withValues(alpha: 0.5),
                    thumbColor: WidgetStateProperty.all(JichenTokens.accent),
                    onChanged: (v) async {
                      await CloudSyncService.setOptIn(v);
                      if (mounted) setState(() {});
                    },
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: (_busy || !optIn) ? null : _push,
                    child: const Text('上传到云端'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: (_busy || !optIn) ? null : _pull,
                    child: const Text('从云端恢复'),
                  ),
                  TextButton(onPressed: _signOut, child: const Text('退出登录')),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, style: TextStyle(color: JichenTokens.jiText)),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: JichenTokens.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
