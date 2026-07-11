import 'package:flutter/material.dart';

import '../theme/jichen_tokens.dart';
import 'jichen_cultural_header.dart';

/// 骨架稿白卡（圆角 + 阴影）。
class JichenOverlaySheetCard extends StatelessWidget {
  const JichenOverlaySheetCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 22, 16, 24),
    this.bottomRadius = 16,
  });

  final Widget child;
  final EdgeInsets padding;
  final double bottomRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
    );
  }
}

/// 顶栏背景 + 白卡内容叠层（择吉 / 提醒 / 我的共用）。
class JichenHeaderStackSheet extends StatelessWidget {
  const JichenHeaderStackSheet({
    super.key,
    required this.header,
    required this.child,
    this.horizontalPadding = 16,
    this.overlap = 40,
    this.bottomRadius = 16,
  });

  final Widget header;
  final Widget child;
  final double horizontalPadding;
  final double overlap;
  final double bottomRadius;

  @override
  Widget build(BuildContext context) {
    final sheetTop = JichenCulturalHeader.sheetStartTop(
      context,
      overlap: overlap,
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        header,
        Padding(
          padding: EdgeInsets.only(
            top: sheetTop,
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          child: JichenOverlaySheetCard(
            bottomRadius: bottomRadius,
            child: child,
          ),
        ),
      ],
    );
  }
}
