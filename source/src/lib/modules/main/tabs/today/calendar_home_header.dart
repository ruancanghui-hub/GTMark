import 'package:flutter/material.dart';

import '../../../../shared/theme/jichen_tokens.dart';

class CalendarHomeHeader extends StatelessWidget {
  const CalendarHomeHeader({
    super.key,
    required this.month,
    required this.onMonthTap,
    required this.onSearchDate,
    required this.onAddPlan,
    required this.onOpenReminders,
    required this.reminderCount,
  });

  final DateTime month;
  final VoidCallback onMonthTap;
  final VoidCallback onSearchDate;
  final VoidCallback onAddPlan;
  final VoidCallback onOpenReminders;
  final int reminderCount;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 6),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onMonthTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(
                    '吉辰万年历',
                    style: context.jichenTitle3().copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: '搜索日期',
              onPressed: onSearchDate,
              icon: const Icon(Icons.search_rounded),
            ),
            _ReminderPill(onTap: onOpenReminders, count: reminderCount),
            IconButton(
              tooltip: '为所选日期添加计划',
              onPressed: onAddPlan,
              icon: const Icon(Icons.add_rounded, color: JichenTokens.accent),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderPill extends StatelessWidget {
  const _ReminderPill({required this.onTap, required this.count});

  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: JichenTokens.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_none_rounded, size: 18),
            const SizedBox(width: 4),
            Text(
              '提醒',
              style: context.jichenFootnote(color: JichenTokens.labelPrimary),
            ),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Container(
                constraints: const BoxConstraints(minWidth: 16),
                height: 16,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: JichenTokens.accent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count > 9 ? '9+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
