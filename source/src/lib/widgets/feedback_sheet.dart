import 'package:flutter/material.dart';

import '../shared/theme/jichen_tokens.dart';
import '../shared/utils/sp_utils.dart';

/// 本机意见反馈（黄历缺失等场景入口，LOOP-001 失败恢复）。
Future<void> showFeedbackSheet(
  BuildContext context, {
  String preset = '',
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: JichenTokens.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => _FeedbackBody(preset: preset),
  );
}

class _FeedbackBody extends StatefulWidget {
  const _FeedbackBody({required this.preset});

  final String preset;

  @override
  State<_FeedbackBody> createState() => _FeedbackBodyState();
}

class _FeedbackBodyState extends State<_FeedbackBody> {
  late final TextEditingController _controller;
  String _type = 'bug';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.preset);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写反馈内容')),
      );
      return;
    }
    final entry =
        '${DateTime.now().toIso8601String()}|$_type|${text.replaceAll('|', '/')}';
    final prev = SpUtils.getString('jichen_feedback_log', defValue: '') ?? '';
    final next = prev.isEmpty ? entry : '$prev\n$entry';
    await SpUtils.putString('jichen_feedback_log', next);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已保存到本机，感谢反馈')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('意见反馈', style: context.jichenTitle3()),
          const SizedBox(height: 8),
          Text(
            '内容仅保存在本设备，便于排查黄历或节假日数据问题。',
            style: context.jichenCaption(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _type,
            decoration: InputDecoration(
              labelText: '类型',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: const [
              DropdownMenuItem(value: 'bug', child: Text('数据问题')),
              DropdownMenuItem(value: 'feature', child: Text('功能建议')),
              DropdownMenuItem(value: 'other', child: Text('其他')),
            ],
            onChanged: (v) => setState(() => _type = v ?? 'bug'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: '反馈内容',
              hintText: '请说明日期、期望与实际现象',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: JichenTokens.accent,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }
}
