import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/date/day_info_service.dart';
import '../../core/reminder/personal_reminder.dart';
import '../reminder/reminder_editor_sheet.dart';
import '../../core/zeji/zeji_matter.dart';
import '../../core/zeji/zeji_result.dart';
import '../../shared/theme/jichen_tokens.dart';
import '../../shared/ui/jichen_buttons.dart';
import '../../shared/ui/jichen_section_title.dart';
import '../main/main_controller.dart';
import '../share/share_card_args.dart';
import '../share/share_nav.dart';

/// 择吉结果卡片列表（LOOP-002 · 骨架稿排版）。
class ZejiResultPanel extends StatelessWidget {
  const ZejiResultPanel({
    super.key,
    required this.result,
    required this.matter,
    this.matterName,
    required this.onExpandRange,
    required this.onSwitchGeneric,
    required this.onRetry,
    required this.onIgnoreWeather,
    required this.onAddReminder,
  });

  final ZejiSearchResult result;
  final ZejiMatter matter;
  final String? matterName;
  final VoidCallback onExpandRange;
  final VoidCallback onSwitchGeneric;
  final VoidCallback onRetry;
  final VoidCallback onIgnoreWeather;
  final void Function(ZejiRecommendation rec) onAddReminder;

  static const _decorIcons = [
    Icons.local_florist_outlined,
    Icons.eco_outlined,
    Icons.spa_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    if (result.isEmpty) {
      return _EmptyPanel(
        onExpandRange: onExpandRange,
        onSwitchGeneric: onSwitchGeneric,
        onRetry: onRetry,
        onIgnoreWeather: onIgnoreWeather,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        JichenSectionTitle(
          title: '推荐结果',
          trailing: const HugeIcon(
            icon: HugeIcons.strokeRoundedSparkles,
            size: 20,
            color: JichenTokens.gold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '推荐 ${result.recommendations.length} 个吉日 · 扫描 ${result.scannedDays} 天',
          style: context.jichenCaption(),
        ),
        if (result.note != null) ...[
          const SizedBox(height: 8),
          Text(result.note!, style: context.jichenCaption()),
        ],
        const SizedBox(height: 14),
        for (var i = 0; i < result.recommendations.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RecommendationCard(
              rec: result.recommendations[i],
              matterName: matterName ?? matter.name,
              decorIcon: _decorIcons[i % _decorIcons.length],
              onAddReminder: () => onAddReminder(result.recommendations[i]),
            ),
          ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.rec,
    required this.matterName,
    required this.decorIcon,
    required this.onAddReminder,
  });

  final ZejiRecommendation rec;
  final String matterName;
  final IconData decorIcon;
  final VoidCallback onAddReminder;

  @override
  Widget build(BuildContext context) {
    final info = DayInfoService.build(rec.date);
    final yiText =
        rec.matchedYi.isEmpty ? '暂无' : rec.matchedYi.take(2).join('、');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: JichenTokens.surface,
        borderRadius: BorderRadius.circular(JichenTokens.cardRadius),
        border: Border.all(color: JichenTokens.cardBorder),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Opacity(
              opacity: 0.12,
              child: Icon(decorIcon, size: 56, color: JichenTokens.accent),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${rec.date.day}',
                    style: context.jichenHeroDay(),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      info.weekdayLabel,
                      style: context.jichenCaption(
                        color: JichenTokens.labelPrimary,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    matterName,
                    style: context.jichenBody(weight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${rec.date.year}年${rec.date.month}月${rec.date.day}日 · ${info.lunarLabel}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.jichenCaption(),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: JichenTokens.yiBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '宜',
                      style: context.jichenFootnote(
                        color: JichenTokens.yiText,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      yiText,
                      style: context.jichenBody(
                        color: JichenTokens.yiText,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                rec.reason,
                style: context.jichenCaption(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: JichenOutlineButton(
                      label: '分享',
                      expanded: true,
                      onPressed: () => openSharePreview(
                        context,
                        ShareCardArgs.zeji(
                          date: rec.date,
                          matterName: matterName,
                          reason: rec.reason,
                          yiLabels: rec.matchedYi,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: JichenOutlineButton(
                      label: '加入提醒',
                      expanded: true,
                      onPressed: onAddReminder,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({
    required this.onExpandRange,
    required this.onSwitchGeneric,
    required this.onRetry,
    required this.onIgnoreWeather,
  });

  final VoidCallback onExpandRange;
  final VoidCallback onSwitchGeneric;
  final VoidCallback onRetry;
  final VoidCallback onIgnoreWeather;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const JichenSectionTitle(title: '推荐结果'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: JichenTokens.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: JichenTokens.separator.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '这个范围内没有合适日期',
                style: context.jichenBody(weight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                '可扩大范围、改用「通用」事项，或重试计算。筛选条件已保留。',
                style: context.jichenCaption(),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onExpandRange,
                style: FilledButton.styleFrom(
                  backgroundColor: JichenTokens.accent,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text('扩大范围 +30 天'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: onSwitchGeneric,
                child: const Text('换「通用」事项'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: onIgnoreWeather,
                child: const Text('忽略天气条件'),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: onRetry, child: const Text('重试')),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> showZejiAddReminderSheet(
  BuildContext context, {
  required ZejiRecommendation rec,
  required ZejiMatter matter,
}) {
  return showReminderEditorSheet(
    context,
    initial: PersonalReminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${matter.name}提醒',
      date: rec.date,
      note: rec.reason,
      source: 'zeji',
      matterId: matter.id,
    ),
  ).then((result) async {
    if (result == null || !context.mounted) return;
    Get.find<MainController>().switchTab(2);
    final msg = result.notifyPending
        ? '提醒已保存；通知未开启，可在「我的」打开通知总开关'
        : '提醒已保存，可在「提醒」查看';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  });
}
