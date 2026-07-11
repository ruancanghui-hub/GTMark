import 'package:flutter/material.dart';

import '../../core/date/calendar_month_service.dart';
import '../../core/date/holiday_mark.dart';
import '../../core/reminder/personal_reminder.dart';
import '../../shared/theme/jichen_tokens.dart';

/// 月历网格布局常量（与 [MonthCalendar] 共用）。
abstract final class MonthCalendarLayout {
  static const crossAxisCount = 7;
  static const mainAxisSpacing = 2.0;
  static const crossAxisSpacing = 2.0;
  static const childAspectRatio = 0.74;
  static const dayCellTopPadding = 5.0;
  static const dayCellBottomPadding = 1.0;

  /// 星期行与日期网格叠层收紧（负值上移网格，抵消格内顶边距）。
  static const weekToGridOffset = -2.0;
  static const weekHeaderHeight = 18.0;

  static SliverGridDelegateWithFixedCrossAxisCount get gridDelegate =>
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      );

  static int rowCountFor(CalendarMonthGrid grid) =>
      grid.cells.length ~/ crossAxisCount;
}

/// 月历网格（LOOP-001）：大字公历 + 农历 + 节日/调休标记（适老阅读）。
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.grid,
    required this.selected,
    required this.onSelect,
    this.planDateKeys = const {},
  });

  final CalendarMonthGrid grid;
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;
  final Set<String> planDateKeys;

  static const _weekLabels = ['日', '一', '二', '三', '四', '五', '六'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: MonthCalendarLayout.weekHeaderHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < _weekLabels.length; i++)
                Expanded(
                  child: Text(
                    _weekLabels[i],
                    textAlign: TextAlign.center,
                    style: context
                        .jichenCalendarWeek(
                          color: i == 0 || i == 6
                              ? JichenTokens.accent
                              : JichenTokens.labelPrimary,
                        )
                        .copyWith(height: 1.0),
                  ),
                ),
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(0, MonthCalendarLayout.weekToGridOffset),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: MonthCalendarLayout.gridDelegate,
            itemCount: grid.cells.length,
            itemBuilder: (context, index) {
              final cell = grid.cells[index];
              return _DayCell(
                cell: cell,
                isSelected: _sameDay(cell.date, selected),
                onSelect: onSelect,
                hasPlan: planDateKeys.contains(
                  PersonalReminder.isoDate(cell.date),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.cell,
    required this.isSelected,
    required this.onSelect,
    required this.hasPlan,
  });

  final CalendarCellInfo cell;
  final bool isSelected;
  final ValueChanged<DateTime> onSelect;
  final bool hasPlan;

  TextStyle _festivalStyle(BuildContext context, bool onAccent) {
    Color color;
    if (onAccent) {
      color = Colors.white;
    } else if (cell.jieQi != null &&
        cell.holidayMark.kind == HolidayMarkKind.none &&
        !cell.isFestival) {
      color = JichenTokens.yiText;
    } else {
      color = JichenTokens.accent;
    }
    return context.jichenCalendarMark(color: color, weight: FontWeight.w800);
  }

  @override
  Widget build(BuildContext context) {
    final inMonth = cell.inMonth;
    Color solarColor;
    if (isSelected) {
      solarColor = Colors.white;
    } else if (!inMonth) {
      solarColor = JichenTokens.labelSecondary.withValues(alpha: 0.45);
    } else if (cell.isWeekend) {
      solarColor = JichenTokens.accent;
    } else {
      solarColor = JichenTokens.labelPrimary;
    }

    final semanticParts = <String>[
      '${cell.date.year}年${cell.date.month}月${cell.date.day}日',
      '农历${cell.lunarDayName}',
      if (cell.festivalName?.isNotEmpty == true) '节日${cell.festivalName}',
      if (cell.jieQi?.isNotEmpty == true) '节气${cell.jieQi}',
      if (cell.isRestDay) '休',
      if (cell.isWorkAdjust) '调休上班',
      if (cell.holidayMark.name?.isNotEmpty == true) cell.holidayMark.name!,
      if (hasPlan) '有计划',
    ];

    return Semantics(
      label: semanticParts.join('，'),
      button: inMonth,
      enabled: inMonth,
      selected: isSelected,
      excludeSemantics: true,
      onTap: inMonth ? () => onSelect(cell.date) : null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: inMonth ? () => onSelect(cell.date) : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isSelected
                  ? JichenTokens.accent
                  : cell.isToday && inMonth
                  ? JichenTokens.yiBg
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: cell.isToday && !isSelected && inMonth
                  ? Border.all(
                      color: JichenTokens.accent.withValues(alpha: 0.35),
                    )
                  : null,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      1,
                      MonthCalendarLayout.dayCellTopPadding,
                      1,
                      MonthCalendarLayout.dayCellBottomPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${cell.date.day}',
                          textAlign: TextAlign.center,
                          style: context
                              .jichenCalendarSolar(
                                color: solarColor,
                                weight: isSelected || cell.isToday
                                    ? FontWeight.w800
                                    : FontWeight.w700,
                              )
                              .copyWith(height: 1.1),
                        ),
                        Text(
                          cell.lunarDayName,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: context
                              .jichenCalendarLunar(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : !inMonth
                                    ? JichenTokens.labelSecondary.withValues(
                                        alpha: 0.4,
                                      )
                                    : JichenTokens.labelSecondary,
                              )
                              .copyWith(height: 1.05),
                        ),
                        if (inMonth && cell.markText != null)
                          Text(
                            cell.markText!,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: _festivalStyle(
                              context,
                              isSelected,
                            ).copyWith(height: 1.0),
                          ),
                      ],
                    ),
                  ),
                ),
                if (inMonth && cell.isRestDay)
                  Positioned(
                    top: 1,
                    right: 1,
                    child: _CornerBadge(
                      label: '休',
                      color: JichenTokens.yiText,
                      onAccent: isSelected,
                    ),
                  ),
                if (inMonth && cell.isWorkAdjust)
                  Positioned(
                    top: 1,
                    right: 1,
                    child: _CornerBadge(
                      label: '班',
                      color: JichenTokens.workdayAdjust,
                      onAccent: isSelected,
                    ),
                  ),
                if (inMonth && hasPlan)
                  Positioned(
                    key: ValueKey(
                      'plan-marker-${PersonalReminder.isoDate(cell.date)}',
                    ),
                    left: 0,
                    right: 0,
                    bottom: 1,
                    child: Center(
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : JichenTokens.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerBadge extends StatelessWidget {
  const _CornerBadge({
    required this.label,
    required this.color,
    required this.onAccent,
  });

  final String label;
  final Color color;
  final bool onAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      decoration: BoxDecoration(
        color: onAccent
            ? Colors.white.withValues(alpha: 0.22)
            : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: context
            .jichenCalendarMark(
              color: onAccent ? Colors.white : color,
              weight: FontWeight.w800,
            )
            .copyWith(fontSize: 10),
      ),
    );
  }
}

String monthTitle(DateTime month) {
  return '${month.year}年${month.month}月';
}
