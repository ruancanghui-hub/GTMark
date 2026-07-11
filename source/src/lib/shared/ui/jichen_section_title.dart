import 'package:flutter/material.dart';

import '../theme/jichen_tokens.dart';

/// 区块标题（左侧红条 + 可选尾部）。
class JichenSectionTitle extends StatelessWidget {
  const JichenSectionTitle({
    super.key,
    required this.title,
    this.trailing,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: JichenTokens.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Text(title, style: context.jichenBody(weight: FontWeight.w700)),
              if (subtitle != null) ...[
                const SizedBox(width: 4),
                Text(subtitle!, style: context.jichenCaption()),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
