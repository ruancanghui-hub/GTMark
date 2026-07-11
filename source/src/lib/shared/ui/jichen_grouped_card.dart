import 'package:flutter/material.dart';

import '../theme/jichen_tokens.dart';

/// 骨架稿分组白卡（区内列表项用分割线，非独立边框）。
class JichenGroupedCard extends StatelessWidget {
  const JichenGroupedCard({
    super.key,
    required this.children,
    this.margin = const EdgeInsets.only(bottom: 16),
  });

  final List<Widget> children;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i < children.length - 1) {
        rows.add(
          const Divider(
            height: 1,
            thickness: 1,
            indent: 68,
            endIndent: 12,
            color: JichenTokens.cardBorder,
          ),
        );
      }
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: JichenTokens.surface,
        borderRadius: BorderRadius.circular(JichenTokens.cardRadius),
        border: Border.all(color: JichenTokens.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rows,
      ),
    );
  }
}

/// 协议区分组卡（图标无圆底、分割线从左缘起）。
class JichenCompactGroupedCard extends StatelessWidget {
  const JichenCompactGroupedCard({
    super.key,
    required this.children,
    this.margin = const EdgeInsets.only(bottom: 16),
  });

  final List<Widget> children;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i < children.length - 1) {
        rows.add(
          const Divider(
            height: 1,
            thickness: 1,
            indent: 36,
            endIndent: 12,
            color: JichenTokens.cardBorder,
          ),
        );
      }
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: JichenTokens.surface,
        borderRadius: BorderRadius.circular(JichenTokens.cardRadius),
        border: Border.all(color: JichenTokens.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rows,
      ),
    );
  }
}
