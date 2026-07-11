import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/date/calendar_month_service.dart';
import '../../../core/date/day_info_service.dart';
import '../../../core/date/day_info.dart';
import '../../../core/prefs/jichen_prefs.dart';
import '../../../core/reminder/personal_reminder.dart';
import '../../../core/reminder/reminder_store.dart';
import '../../../shared/theme/jichen_tokens.dart';
import '../../../widgets/jichen_date_picker_sheet.dart';
import '../../../widgets/month_calendar.dart';
import '../../reminder/reminder_editor_sheet.dart';
import '../../date_detail/date_search_sheet.dart';
import '../main_controller.dart';
import '../today_controller.dart';
import 'reminder_tab.dart';
import 'today/calendar_home_header.dart';
import 'today/dated_plan_section.dart';

typedef PlanEditorLauncher =
    Future<({bool saved, bool notifyPending})?> Function(
      BuildContext context, {
      PersonalReminder? existing,
      PersonalReminder? initial,
    });

typedef NotificationSettingsLauncher =
    Future<void> Function(BuildContext context);

/// 日历首页（LOOP-001 / LOOP-003）。
class TodayTab extends GetView<TodayController> {
  const TodayTab({
    super.key,
    this.openPlanEditor,
    this.openNotificationSettings,
  });

  final PlanEditorLauncher? openPlanEditor;
  final NotificationSettingsLauncher? openNotificationSettings;

  Future<void> _openEditor(
    BuildContext context,
    DateTime date, {
    PersonalReminder? existing,
  }) async {
    final result = await (openPlanEditor ?? showReminderEditorSheet)(
      context,
      existing: existing,
      initial: existing == null
          ? PersonalReminder(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              title: '',
              date: date,
              notifyEnabled: true,
            )
          : null,
    );
    if (result?.saved != true || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result!.notifyPending ? '计划已保存；通知未开启时仅站内可见' : '计划已保存'),
        action: result.notifyPending
            ? SnackBarAction(
                label: '去设置',
                onPressed: () =>
                    (openNotificationSettings ?? openNotificationSettingsHint)(
                      context,
                    ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: JichenTokens.background,
      child: Obx(() {
        JichenPrefs.prefsTick.value;
        ReminderStore.revision.value;
        final selected = controller.selectedDate.value;
        final month = controller.displayMonth.value;
        final monthGrid = controller.monthGrid.value;
        final monthGridError = controller.monthGridError.value;
        final info = DayInfoService.build(selected);
        final plans = ReminderStore.plansOn(selected);
        final pendingReminderCount = ReminderStore.loadAll()
            .where((item) => !item.completed)
            .length;
        final planKeys = ReminderStore.loadAll()
            .where((item) => !item.isAnniversaryKind)
            .map((item) => PersonalReminder.isoDate(item.date))
            .toSet();
        return Column(
          children: [
            CalendarHomeHeader(
              month: month,
              onMonthTap: () async {
                final picked = await showJichenDatePickerSheet(
                  context,
                  initial: selected,
                );
                if (picked != null) controller.selectDate(picked);
              },
              onSearchDate: () async {
                final picked = await showDateSearchSheet(context);
                if (picked != null) controller.selectDate(picked);
              },
              onAddPlan: () => _openEditor(context, selected),
              onOpenReminders: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ReminderTab(asSecondaryPage: true),
                ),
              ),
              reminderCount: pendingReminderCount,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
                children: [
                  _TodayHeroCard(info: info),
                  const SizedBox(height: 10),
                  _CompactCalendarPanel(
                    month: month,
                    monthGrid: monthGrid,
                    monthGridError: monthGridError,
                    selected: selected,
                    planKeys: planKeys,
                    onSelect: controller.selectDate,
                    onPrevMonth: controller.prevMonth,
                    onNextMonth: controller.nextMonth,
                    onRetry: controller.retryMonthGrid,
                  ),
                  const SizedBox(height: 10),
                  _TodayAdviceCard(
                    info: info,
                    onOpenDetail: () => Modular.to.pushNamed(
                      '${AppRoutes.main}date-detail',
                      arguments: selected,
                    ),
                    onOpenZeji: () => Get.find<MainController>().switchTab(1),
                  ),
                  const SizedBox(height: 12),
                  DatedPlanSection(
                    date: selected,
                    plans: plans,
                    onAdd: () => _openEditor(context, selected),
                    onEdit: (plan) =>
                        _openEditor(context, selected, existing: plan),
                    onComplete: ReminderStore.complete,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _TodayHeroCard extends StatelessWidget {
  const _TodayHeroCard({required this.info});

  final DayInfo info;

  @override
  Widget build(BuildContext context) {
    final date = info.date;
    final mark = info.yi.take(6).toList();
    final ji = info.ji.take(6).toList();
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: JichenTokens.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: JichenTokens.accent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              '今天',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${date.day}',
            style: const TextStyle(
              fontSize: 78,
              height: 0.98,
              fontWeight: FontWeight.w300,
              letterSpacing: -2,
              color: JichenTokens.accent,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}   ${info.weekdayLabel}',
            style: context.jichenBody(weight: FontWeight.w500),
          ),
          const SizedBox(height: 3),
          Text(info.lunarLabel, style: context.jichenCaption()),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _HuangliPill(
                  label: '宜',
                  items: mark.isEmpty ? const ['祭祀', '祈福', '出行'] : mark,
                  positive: true,
                ),
                const SizedBox(width: 8),
                _HuangliPill(
                  label: '忌',
                  items: ji.isEmpty ? const ['嫁娶', '安葬', '动土'] : ji,
                  positive: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HuangliPill extends StatelessWidget {
  const _HuangliPill({
    required this.label,
    required this.items,
    required this.positive,
  });

  final String label;
  final List<String> items;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? JichenTokens.yiText : JichenTokens.jiText;
    final bg = positive ? JichenTokens.yiBg : JichenTokens.jiBg;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            items.take(6).join('  '),
            style: context.jichenFootnote(color: JichenTokens.labelPrimary),
          ),
        ],
      ),
    );
  }
}

class _CompactCalendarPanel extends StatefulWidget {
  const _CompactCalendarPanel({
    required this.month,
    required this.monthGrid,
    required this.monthGridError,
    required this.selected,
    required this.planKeys,
    required this.onSelect,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onRetry,
  });

  final DateTime month;
  final CalendarMonthGrid? monthGrid;
  final Object? monthGridError;
  final DateTime selected;
  final Set<String> planKeys;
  final ValueChanged<DateTime> onSelect;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onRetry;

  @override
  State<_CompactCalendarPanel> createState() => _CompactCalendarPanelState();
}

class _CompactCalendarPanelState extends State<_CompactCalendarPanel> {
  double _horizontalDragDistance = 0;

  static const _weekLabels = ['日', '一', '二', '三', '四', '五', '六'];

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final grid = widget.monthGrid;
    return GestureDetector(
      key: const Key('month-grid-slot'),
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (_) => _horizontalDragDistance = 0,
      onHorizontalDragUpdate: (details) {
        _horizontalDragDistance += details.delta.dx;
      },
      onHorizontalDragEnd: (_) {
        if (_horizontalDragDistance <= -48) {
          widget.onNextMonth();
        } else if (_horizontalDragDistance >= 48) {
          widget.onPrevMonth();
        }
        _horizontalDragDistance = 0;
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: JichenTokens.cardBorder),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: '上个月',
                  onPressed: widget.onPrevMonth,
                  icon: const Icon(Icons.chevron_left_rounded, size: 22),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 36,
                    height: 36,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${widget.month.year}年 ${widget.month.month}月',
                    textAlign: TextAlign.center,
                    style: context.jichenBody(weight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  tooltip: '下个月',
                  onPressed: widget.onNextMonth,
                  icon: const Icon(Icons.chevron_right_rounded, size: 22),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 36,
                    height: 36,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (var i = 0; i < _weekLabels.length; i++)
                  Expanded(
                    child: Text(
                      _weekLabels[i],
                      textAlign: TextAlign.center,
                      style: context.jichenFootnote(
                        color: i == 0 || i == 6
                            ? JichenTokens.accent
                            : JichenTokens.labelPrimary,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            if (grid != null)
              GridView.builder(
                key: const Key('month-grid'),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisExtent: 44,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 2,
                ),
                itemCount: grid.cells.length,
                itemBuilder: (context, index) {
                  final cell = grid.cells[index];
                  final isSelected = _sameDay(cell.date, widget.selected);
                  final inMonth = cell.inMonth;
                  final color = isSelected
                      ? Colors.white
                      : !inMonth
                      ? JichenTokens.labelSecondary.withValues(alpha: 0.42)
                      : cell.isWeekend
                      ? JichenTokens.accent
                      : JichenTokens.labelPrimary;
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: inMonth ? () => widget.onSelect(cell.date) : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? JichenTokens.accent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${cell.date.day}',
                            style: TextStyle(
                              color: color,
                              fontSize: 16,
                              height: 1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            cell.markText ?? cell.lunarDayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : cell.markText != null
                                  ? JichenTokens.accent
                                  : JichenTokens.labelSecondary,
                              fontSize: 10,
                              height: 1,
                              fontWeight: cell.markText != null
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                          if (widget.planKeys.contains(
                            PersonalReminder.isoDate(cell.date),
                          ))
                            Container(
                              key: ValueKey(
                                'plan-marker-${PersonalReminder.isoDate(cell.date)}',
                              ),
                              margin: const EdgeInsets.only(top: 2),
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : JichenTokens.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              )
            else if (widget.monthGridError != null)
              _MonthGridError(onRetry: widget.onRetry)
            else
              const SizedBox(height: 260, child: _MonthGridLoading()),
          ],
        ),
      ),
    );
  }
}

class _TodayAdviceCard extends StatelessWidget {
  const _TodayAdviceCard({
    required this.info,
    required this.onOpenDetail,
    required this.onOpenZeji,
  });

  final DayInfo info;
  final VoidCallback onOpenDetail;
  final VoidCallback onOpenZeji;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: JichenTokens.cardBorder),
      ),
      child: InkWell(
        onTap: onOpenDetail,
        borderRadius: BorderRadius.circular(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '今日建议',
                      style: context.jichenBody(weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '保持专注，稳步推进计划，\n会有不错的收获。',
                      style: context.jichenFootnote(
                        color: JichenTokens.labelPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: onOpenZeji,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: JichenTokens.accent,
                      ),
                      child: const Text('查吉日'),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
              'assets/images/brand/ip_deer.png',
              width: 112,
              height: 112,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class _MonthGridLoading extends StatelessWidget {
  const _MonthGridLoading();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: const Key('month-grid-loading'),
      label: '月历加载中',
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: MonthCalendarLayout.gridDelegate,
          itemCount: 35,
          itemBuilder: (_, index) => Padding(
            padding: const EdgeInsets.all(6),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: JichenTokens.background,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthGridError extends StatelessWidget {
  const _MonthGridError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('month-grid-error'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('月历加载失败', style: context.jichenBody()),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
    );
  }
}
