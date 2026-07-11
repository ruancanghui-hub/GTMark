import 'package:flutter/material.dart';

import '../../shared/theme/jichen_tokens.dart';

/// 导出/导入备份时输入密码。
Future<String?> showBackupPasswordDialog(
  BuildContext context, {
  required String title,
  String? confirmLabel,
  bool confirmMatch = false,
}) async {
  final ctrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  String? error;
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setLocal) {
          return AlertDialog(
            title: Text(title, style: ctx.jichenTitle3()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: ctrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '备份密码',
                    hintText: '至少 6 位，请牢记',
                  ),
                ),
                if (confirmMatch) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: confirmLabel ?? '再次输入密码',
                    ),
                  ),
                ],
                if (error != null) ...[
                  const SizedBox(height: 8),
                  Text(error!, style: TextStyle(color: JichenTokens.jiText)),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () {
                  final p = ctrl.text;
                  if (p.length < 6) {
                    setLocal(() => error = '密码至少 6 位');
                    return;
                  }
                  if (confirmMatch && p != confirmCtrl.text) {
                    setLocal(() => error = '两次密码不一致');
                    return;
                  }
                  Navigator.pop(ctx, p);
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    },
  );
}
