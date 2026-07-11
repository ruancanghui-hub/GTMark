import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunar/lunar.dart';

import '../core/date/day_info_service.dart';
import '../core/date/lunar_birthday.dart';
import '../core/date/lunar_helper.dart';
import '../core/date/week_helper.dart';
import '../shared/theme/jichen_tokens.dart';

/// 公历 / 农历双模式滚轮日期选择（首页顶栏等）。
Future<DateTime?> showJichenDatePickerSheet(
  BuildContext context, {
  required DateTime initial,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: JichenTokens.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => _JichenDatePickerBody(
      initial: DateTime(initial.year, initial.month, initial.day),
    ),
  );
}

enum _PickerMode { solar, lunar }

class _JichenDatePickerBody extends StatefulWidget {
  const _JichenDatePickerBody({required this.initial});

  final DateTime initial;

  @override
  State<_JichenDatePickerBody> createState() => _JichenDatePickerBodyState();
}

class _JichenDatePickerBodyState extends State<_JichenDatePickerBody> {
  static const _minYear = 1901;
  static const _maxYear = 2049;

  late _PickerMode _mode;
  late int _solarYear;
  late int _solarMonth;
  late int _solarDay;
  late int _lunarYear;
  late int _signedMonth;
  late int _lunarDay;

  late FixedExtentScrollController _yearCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _dayCtrl;
  bool _ignorePickerChanges = false;

  @override
  void initState() {
    super.initState();
    _mode = _PickerMode.solar;
    _applySolar(widget.initial);
    final lunar = Solar.fromDate(widget.initial).getLunar();
    _lunarYear = lunar.getYear();
    _signedMonth = lunar.getMonth();
    _lunarDay = lunar.getDay();
    _yearCtrl = FixedExtentScrollController(initialItem: _yearIndex);
    _monthCtrl = FixedExtentScrollController(initialItem: _monthIndex);
    _dayCtrl = FixedExtentScrollController(initialItem: _dayIndex);
  }

  @override
  void dispose() {
    _yearCtrl.dispose();
    _monthCtrl.dispose();
    _dayCtrl.dispose();
    super.dispose();
  }

  void _applySolar(DateTime date) {
    _solarYear = date.year.clamp(_minYear, _maxYear);
    _solarMonth = date.month;
    _solarDay = date.day.clamp(1, _solarDaysInMonth(_solarYear, _solarMonth));
  }

  int _solarDaysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  List<int> get _solarYears =>
      List.generate(_maxYear - _minYear + 1, (i) => _minYear + i);

  List<({int signedMonth, String label, int dayCount})> get _lunarMonths =>
      LunarBirthdayCalendar.monthOptions(_lunarYear);

  int get _dayCount => _mode == _PickerMode.solar
      ? _solarDaysInMonth(_solarYear, _solarMonth)
      : _currentLunarMonth.dayCount;

  ({int signedMonth, String label, int dayCount}) get _currentLunarMonth {
    final months = _lunarMonths;
    for (final m in months) {
      if (m.signedMonth == _signedMonth) return m;
    }
    return months.first;
  }

  int get _yearIndex => _mode == _PickerMode.solar
      ? _solarYears.indexOf(_solarYear).clamp(0, _solarYears.length - 1)
      : _solarYears.indexOf(_lunarYear).clamp(0, _solarYears.length - 1);

  int get _monthIndex {
    if (_mode == _PickerMode.solar) return _solarMonth - 1;
    final months = _lunarMonths;
    final idx = months.indexWhere((m) => m.signedMonth == _signedMonth);
    return idx < 0 ? 0 : idx;
  }

  int get _dayIndex => (_mode == _PickerMode.solar ? _solarDay : _lunarDay) - 1;

  DateTime get _resolvedSolar {
    if (_mode == _PickerMode.solar) {
      return DateTime(_solarYear, _solarMonth, _solarDay);
    }
    return LunarBirthdayCalendar.solarOnLunarDate(
          _lunarYear,
          _signedMonth,
          _lunarDay,
        ) ??
        DateTime(_solarYear, _solarMonth, _solarDay);
  }

  void _jumpControllers() {
    _ignorePickerChanges = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      void jump(FixedExtentScrollController c, int index, int maxIndex) {
        if (!c.hasClients) return;
        c.jumpToItem(index.clamp(0, maxIndex));
      }

      final yearMax = _solarYears.length - 1;
      final monthMax =
          (_mode == _PickerMode.solar ? 12 : _lunarMonths.length) - 1;
      final dayMax = _dayCount - 1;
      jump(_yearCtrl, _yearIndex, yearMax);
      jump(_monthCtrl, _monthIndex, monthMax);
      jump(_dayCtrl, _dayIndex, dayMax);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _ignorePickerChanges = false;
      });
    });
  }

  void _syncLunarFromSolar(DateTime solar) {
    final lunar = Solar.fromDate(solar).getLunar();
    _lunarYear = lunar.getYear();
    _signedMonth = lunar.getMonth();
    _lunarDay = lunar.getDay();
  }

  void _switchMode(_PickerMode mode) {
    if (_mode == mode) return;
    if (mode == _PickerMode.lunar) {
      _syncLunarFromSolar(DateTime(_solarYear, _solarMonth, _solarDay));
    } else {
      final solar = LunarBirthdayCalendar.solarOnLunarDate(
        _lunarYear,
        _signedMonth,
        _lunarDay,
      );
      if (solar != null) _applySolar(solar);
    }
    setState(() => _mode = mode);
    _jumpControllers();
  }

  void _goToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    Navigator.pop(context, today);
  }

  String _summaryLine(DateTime solar) {
    final info = DayInfoService.build(solar);
    final week = isoWeekNumber(solar);
    return '${solar.year}年${solar.month}月${solar.day}日 · '
        '${lunarDisplayLabel(solar)} · 第$week周 ${info.weekdayLabel}';
  }

  TextStyle _pickerStyle(BuildContext context) =>
      context.jichenBody(
        color: JichenTokens.accent,
        weight: FontWeight.w600,
      ).copyWith(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final solar = _resolvedSolar;
    final summary = _summaryLine(solar);
    final bottom = MediaQuery.paddingOf(context).bottom;
    final pickerStyle = _pickerStyle(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: JichenTokens.separator,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text('选择日期', style: context.jichenTitle3()),
                const Spacer(),
                _ModeToggle(
                  mode: _mode,
                  onChanged: _switchMode,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              summary,
              textAlign: TextAlign.center,
              style: context.jichenCaption(
                color: JichenTokens.labelSecondary,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(child: _buildYearPicker(pickerStyle)),
                  Expanded(child: _buildMonthPicker(pickerStyle)),
                  Expanded(child: _buildDayPicker(pickerStyle)),
                ],
              ),
            ),
            const Divider(height: 1),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _goToday,
                      style: TextButton.styleFrom(
                        foregroundColor: JichenTokens.accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        '回到今天',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, _resolvedSolar),
                      style: TextButton.styleFrom(
                        foregroundColor: JichenTokens.accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        '确定',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearPicker(TextStyle style) {
    if (_mode == _PickerMode.solar) {
      return CupertinoPicker(
        scrollController: _yearCtrl,
        itemExtent: 36,
        onSelectedItemChanged: (i) {
          if (_ignorePickerChanges) return;
          setState(() {
            _solarYear = _solarYears[i];
            if (_solarDay > _dayCount) _solarDay = _dayCount;
          });
        },
        children: [
          for (final y in _solarYears)
            Center(child: Text('$y年', style: style)),
        ],
      );
    }
    return CupertinoPicker(
      scrollController: _yearCtrl,
      itemExtent: 36,
      onSelectedItemChanged: (i) {
        if (_ignorePickerChanges) return;
        setState(() {
          _lunarYear = _solarYears[i];
          final months = _lunarMonths;
          if (!months.any((m) => m.signedMonth == _signedMonth)) {
            _signedMonth = months.first.signedMonth;
          }
          if (_lunarDay > _dayCount) _lunarDay = _dayCount;
        });
      },
      children: [
        for (final y in _solarYears)
          Center(child: Text('$y年', style: style)),
      ],
    );
  }

  Widget _buildMonthPicker(TextStyle style) {
    if (_mode == _PickerMode.solar) {
      return CupertinoPicker(
        scrollController: _monthCtrl,
        itemExtent: 36,
        onSelectedItemChanged: (i) {
          if (_ignorePickerChanges) return;
          setState(() {
            _solarMonth = i + 1;
            if (_solarDay > _dayCount) _solarDay = _dayCount;
          });
        },
        children: [
          for (var m = 1; m <= 12; m++)
            Center(child: Text('${m.toString().padLeft(2, '0')}月', style: style)),
        ],
      );
    }
    final months = _lunarMonths;
    return CupertinoPicker(
      scrollController: _monthCtrl,
      itemExtent: 36,
      onSelectedItemChanged: (i) {
        if (_ignorePickerChanges) return;
        setState(() {
          _signedMonth = months[i].signedMonth;
          if (_lunarDay > _dayCount) _lunarDay = _dayCount;
        });
      },
      children: [
        for (final m in months)
          Center(child: Text(m.label, style: style)),
      ],
    );
  }

  Widget _buildDayPicker(TextStyle style) {
    final count = _dayCount;
    return CupertinoPicker(
      key: ValueKey('${_mode.name}-$count'),
      scrollController: _dayCtrl,
      itemExtent: 36,
      onSelectedItemChanged: (i) {
        if (_ignorePickerChanges) return;
        setState(() {
          if (_mode == _PickerMode.solar) {
            _solarDay = i + 1;
          } else {
            _lunarDay = i + 1;
          }
        });
      },
      children: [
        if (_mode == _PickerMode.solar)
          for (var d = 1; d <= count; d++)
            Center(
              child: Text('${d.toString().padLeft(2, '0')}日', style: style),
            )
        else
          for (var d = 1; d <= count; d++)
            Center(
              child: Text(
                Lunar.fromYmd(_lunarYear, _signedMonth, d).getDayInChinese(),
                style: style,
              ),
            ),
      ],
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.mode,
    required this.onChanged,
  });

  final _PickerMode mode;
  final ValueChanged<_PickerMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: JichenTokens.accent),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Segment(
            label: '公历',
            selected: mode == _PickerMode.solar,
            onTap: () => onChanged(_PickerMode.solar),
          ),
          _Segment(
            label: '农历',
            selected: mode == _PickerMode.lunar,
            onTap: () => onChanged(_PickerMode.lunar),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? JichenTokens.accent : Colors.transparent,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Text(
            label,
            style: context.jichenCaption(
              color: selected ? Colors.white : JichenTokens.accent,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
