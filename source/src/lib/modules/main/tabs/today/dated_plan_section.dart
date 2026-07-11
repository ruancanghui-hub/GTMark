import 'package:flutter/material.dart';

import '../../../../core/reminder/personal_reminder.dart';
import '../../../../shared/theme/jichen_tokens.dart';

class DatedPlanSection extends StatelessWidget {
  const DatedPlanSection({
    super.key,
    required this.date,
    required this.plans,
    required this.onAdd,
    required this.onEdit,
    required this.onComplete,
  });

  final DateTime date;
  final List<PersonalReminder> plans;
  final VoidCallback onAdd;
  final ValueChanged<PersonalReminder> onEdit;
  final ValueChanged<PersonalReminder> onComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('当日计划', style: context.jichenTitle3()),
                    const SizedBox(height: 2),
                    Text(
                      '${date.month}月${date.day}日',
                      style: context.jichenCaption(),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('添加计划'),
              ),
            ],
          ),
          if (plans.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('这一天还没有计划', style: context.jichenBody()),
            )
          else
            ...plans.map(
              (plan) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: JichenTokens.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  minTileHeight: 52,
                  contentPadding: const EdgeInsets.only(left: 14, right: 4),
                  title: Text(
                    plan.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.jichenBody(weight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    plan.allDay
                        ? '全天'
                        : '${plan.hour.toString().padLeft(2, '0')}:${plan.minute.toString().padLeft(2, '0')}',
                    style: context.jichenCaption(),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: '编辑${plan.title}',
                        onPressed: () => onEdit(plan),
                        icon: const Icon(Icons.edit_outlined, size: 20),
                      ),
                      IconButton(
                        tooltip: '完成${plan.title}',
                        onPressed: () => onComplete(plan),
                        icon: Icon(
                          plan.completed
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          size: 21,
                          color: JichenTokens.yiText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
