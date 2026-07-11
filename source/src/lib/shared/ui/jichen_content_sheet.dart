import 'package:flutter/material.dart';

import '../theme/jichen_tokens.dart';

/// 骨架稿白卡内容区（仅顶部大圆角、轻阴影、与红头叠层）。
class JichenContentSheet extends StatelessWidget {
  const JichenContentSheet({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 22, 16, 24),
    this.overlap = 24,
    this.bottomRadius = 0,
  });

  final Widget child;
  final EdgeInsets padding;
  final double overlap;
  final double bottomRadius;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -overlap),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: JichenTokens.surface,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(JichenTokens.sheetTopRadius),
              bottom: Radius.circular(bottomRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
