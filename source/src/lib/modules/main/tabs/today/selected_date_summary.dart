import 'package:flutter/material.dart';

import '../../../../core/date/day_info.dart';
import '../../../../shared/theme/jichen_tokens.dart';

class SelectedDateSummary extends StatelessWidget {
  const SelectedDateSummary({
    super.key,
    required this.info,
    required this.onOpenDetail,
  });

  final DayInfo info;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpenDetail,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: JichenTokens.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${info.date.day}',
                style: context.jichenTitle1(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${info.date.month}月${info.date.day}日 · ${info.weekdayLabel}',
                    style: context.jichenTitle3().copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(info.lunarLabel, style: context.jichenBody()),
                  Text(
                    '${info.ganZhiDay} · 属${info.shengXiao}',
                    style: context.jichenCaption(),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: JichenTokens.labelSecondary),
          ],
        ),
      ),
    );
  }
}
