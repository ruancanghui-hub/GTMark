import 'package:flutter/material.dart';

import '../../core/date/date_input_parser.dart';
import '../../shared/theme/jichen_tokens.dart';

/// 日期搜索跳转（LOOP-001）。
Future<DateTime?> showDateSearchSheet(BuildContext context) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: JichenTokens.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => const _DateSearchBody(),
  );
}

class _DateSearchBody extends StatefulWidget {
  const _DateSearchBody();

  @override
  State<_DateSearchBody> createState() => _DateSearchBodyState();
}

class _DateSearchBodyState extends State<_DateSearchBody> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final msg = DateInputParser.validateMessage(_controller.text);
    if (msg != null) {
      setState(() => _error = msg);
      return;
    }
    Navigator.pop(context, DateInputParser.parse(_controller.text));
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
          Text('跳转日期', style: context.jichenTitle3()),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: '2026-06-21 或 2026年6月21日',
              errorText: _error,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: JichenTokens.accent,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('跳转'),
          ),
        ],
      ),
    );
  }
}
