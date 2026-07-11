import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../shared/theme/jichen_tokens.dart';
import '../../../../shared/ui/jichen_section_title.dart';

/// 我的页设置行（骨架稿）。
class MineSettingTile extends StatelessWidget {
  const MineSettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.compact = false,
    this.inGroup = false,
  });

  final List<List<dynamic>> icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  /// 协议区：无圆形图标底。
  final bool compact;
  /// 分组卡内：无独立外框。
  final bool inGroup;

  @override
  Widget build(BuildContext context) {
    final row = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: inGroup ? 12 : (compact ? 4 : 12),
            vertical: inGroup ? 14 : (compact ? 14 : 12),
          ),
          child: Row(
            children: [
              if (!compact)
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: JichenTokens.iconCircleBg,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: HugeIcon(
                    icon: icon,
                    size: 22,
                    color: JichenTokens.accent,
                  ),
                )
              else
                SizedBox(
                  width: 28,
                  child: HugeIcon(
                    icon: icon,
                    size: 20,
                    color: JichenTokens.accent,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.jichenBody(weight: FontWeight.w600),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: context.jichenCaption()),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (showChevron && onTap != null)
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  size: 18,
                  color: JichenTokens.labelSecondary,
                ),
            ],
          ),
        ),
      ),
    );

    if (inGroup || compact) return row;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: JichenTokens.surface,
        borderRadius: BorderRadius.circular(JichenTokens.chipRadius),
        border: Border.all(color: JichenTokens.cardBorder),
      ),
      child: row,
    );
  }
}

/// 分组标题（红色竖条）。
typedef MineSectionTitle = JichenSectionTitle;
