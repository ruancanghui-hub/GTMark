import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/jichen_tokens.dart';

/// 新国风红色顶栏（择吉 / 提醒 / 我的共用）。
class JichenCulturalHeader extends StatelessWidget {
  const JichenCulturalHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.subtitleStyle,
  });

  final String title;
  final String subtitle;
  final TextStyle? subtitleStyle;

  static const _topBgAsset = 'assets/images/zj/top_bg.png';

  static double heightFor(double width, double safeTop) {
    final imageHeight = width * 724 / 2172;
    return math.max(imageHeight, safeTop + 112);
  }

  /// 白卡叠在顶栏上的起始 top（用于 Stack）。
  static double sheetStartTop(BuildContext context, {double overlap = 40}) {
    final mq = MediaQuery.of(context);
    return heightFor(mq.size.width, mq.padding.top) - overlap;
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final width = MediaQuery.sizeOf(context).width;
    final height = heightFor(width, top);
    final resolvedSubtitle = subtitleStyle ??
        context.jichenSubhead(
          color: Colors.white.withValues(alpha: 0.92),
          weight: FontWeight.w400,
        );

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _topBgAsset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, top + 12, 100, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: context.jichenPageHeader()),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: resolvedSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
