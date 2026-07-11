import 'package:flutter/material.dart';

import '../../../../shared/theme/jichen_tokens.dart';
import '../../../../shared/ui/jichen_cultural_header.dart';

/// 提醒页红色顶栏（骨架稿）。
class ReminderHeader extends StatelessWidget {
  const ReminderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return JichenCulturalHeader(
      title: '提醒',
      subtitle: '管理个人提醒与节日祝福提醒，不错过重要节日与良辰',
      subtitleStyle: context.jichenFootnote(
        color: Colors.white.withValues(alpha: 0.9),
        weight: FontWeight.w400,
      ),
    );
  }
}
