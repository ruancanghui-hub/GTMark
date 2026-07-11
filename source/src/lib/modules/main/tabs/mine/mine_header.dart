import 'package:flutter/material.dart';

import '../../../../shared/theme/jichen_tokens.dart';
import '../../../../shared/ui/jichen_cultural_header.dart';

/// 我的页红色顶栏（骨架稿）。
class MineHeader extends StatelessWidget {
  const MineHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return JichenCulturalHeader(
      title: '我的',
      subtitle: '管理城市、祝福模板、通知与数据设置，统一查看应用信息。',
      subtitleStyle: context.jichenFootnote(
        color: Colors.white.withValues(alpha: 0.9),
        weight: FontWeight.w400,
      ),
    );
  }
}
