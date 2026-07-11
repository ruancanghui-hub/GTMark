import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/prefs/festival_reminder_prefs.dart';
import '../../../../shared/theme/jichen_tokens.dart';
import 'festival_reminder_icons.dart';

/// 节日提醒单行（骨架稿）。
class ReminderFestivalRow extends StatelessWidget {
  const ReminderFestivalRow({
    super.key,
    required this.id,
    required this.name,
    required this.onChanged,
  });

  final String id;
  final String name;
  final ValueChanged<bool> onChanged;

  static Color _iconBg(String id) => switch (id) {
        'tf_chunjie' => const Color(0xFFFFEBEE),
        'tf_qingming' => const Color(0xFFE8F5E9),
        'tf_duanwu' => const Color(0xFFFFF3E0),
        'tf_zhongqiu' => const Color(0xFFFFF8E1),
        'tf_yuanxiao' => const Color(0xFFFFF3E0),
        'tf_chongyang' => const Color(0xFFFFF9C4),
        _ => const Color(0xFFF2F2F7),
      };

  static Color _iconColor(String id) => switch (id) {
        'tf_chunjie' => JichenTokens.accent,
        'tf_qingming' => const Color(0xFF43A047),
        'tf_duanwu' => const Color(0xFFE65100),
        'tf_zhongqiu' => const Color(0xFFF9A825),
        'tf_yuanxiao' => const Color(0xFFFF7043),
        'tf_chongyang' => const Color(0xFFFBC02D),
        _ => JichenTokens.labelSecondary,
      };

  @override
  Widget build(BuildContext context) {
    final enabled = FestivalReminderPrefs.isEnabled(id);
    final lunar = festivalLunarHint(id);
    final decorIcon = festivalReminderIcon(id);
    final iconColor = _iconColor(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: JichenTokens.surface,
        borderRadius: BorderRadius.circular(JichenTokens.chipRadius),
        border: Border.all(color: JichenTokens.cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Positioned(
              right: 56,
              top: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.06,
                child: HugeIcon(
                  icon: decorIcon,
                  size: 72,
                  color: iconColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _iconBg(id),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: HugeIcon(
                      icon: festivalReminderIcon(id),
                      size: 22,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: context.jichenBody(weight: FontWeight.w600),
                        ),
                        if (lunar.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(lunar, style: context.jichenCaption()),
                        ],
                      ],
                    ),
                  ),
                  Switch(
                    value: enabled,
                    activeTrackColor: JichenTokens.accent.withValues(alpha: 0.45),
                    thumbColor: WidgetStateProperty.all(JichenTokens.accent),
                    onChanged: onChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
