import 'package:flutter/material.dart';

import '../theme/jichen_tokens.dart';

/// 吉辰二级页统一外壳：暖白背景、圆形返回按钮、标题基线和品牌红焦点色。
class JichenSecondaryScaffold extends StatelessWidget {
  const JichenSecondaryScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.onBack,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 24),
    this.backgroundColor = JichenTokens.background,
    this.scrollable = true,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final VoidCallback? onBack;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = scrollable
        ? ListView(padding: padding, children: [body])
        : Padding(padding: padding, child: body);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 12, 4),
              child: Row(
                children: [
                  JichenBackButton(onPressed: onBack),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.jichenTitle2().copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  ...actions,
                ],
              ),
            ),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}

class JichenBackButton extends StatelessWidget {
  const JichenBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: '返回',
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: JichenTokens.labelPrimary,
        side: const BorderSide(color: JichenTokens.cardBorder),
        fixedSize: const Size(38, 38),
        minimumSize: const Size(38, 38),
        padding: EdgeInsets.zero,
      ),
      icon: const Icon(Icons.chevron_left_rounded, size: 26),
    );
  }
}
