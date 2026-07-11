import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/jichen_tokens.dart';

/// 品牌 IP 版底部导航。
class JichenBottomNav extends StatelessWidget {
  const JichenBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.labels,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: JichenTokens.surface,
        border: Border(
          top: BorderSide(color: JichenTokens.separator.withValues(alpha: 0.6)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 8, 8, bottom > 0 ? 3 : 9),
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: _NavItem(
                  label: labels[i],
                  selected: currentIndex == i,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  List<List<dynamic>> get _icon {
    switch (label) {
      case '日历':
        return selected
            ? HugeIcons.strokeRoundedCalendar03
            : HugeIcons.strokeRoundedCalendar01;
      case '择吉':
        return HugeIcons.strokeRoundedSparkles;
      case '天气':
        return selected
            ? HugeIcons.strokeRoundedCloudFastWind
            : HugeIcons.strokeRoundedCloud;
      case '我的':
        return selected
            ? HugeIcons.strokeRoundedUserCircle
            : HugeIcons.strokeRoundedUser02;
      default:
        return HugeIcons.strokeRoundedCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? JichenTokens.accent.withValues(alpha: 0.10)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: HugeIcon(
                  icon: _icon,
                  size: 22,
                  color: selected
                      ? JichenTokens.accent
                      : JichenTokens.labelSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected
                      ? JichenTokens.accent
                      : JichenTokens.labelSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
