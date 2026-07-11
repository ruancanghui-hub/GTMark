import 'package:flutter/material.dart';
import 'package:lunar/lunar.dart';

import '../core/date/lunar_birthday.dart';
import '../shared/theme/jichen_tokens.dart';

/// 农历生日选择器（LOOP-004 场景 D）。
Future<LunarBirthdayAnchor?> showLunarBirthdayPickerSheet(
  BuildContext context, {
  LunarBirthdayAnchor? initial,
}) {
  return showModalBottomSheet<LunarBirthdayAnchor>(
    context: context,
    isScrollControlled: true,
    backgroundColor: JichenTokens.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => _LunarBirthdayPickerBody(initial: initial),
  );
}

class _LunarBirthdayPickerBody extends StatefulWidget {
  const _LunarBirthdayPickerBody({this.initial});

  final LunarBirthdayAnchor? initial;

  @override
  State<_LunarBirthdayPickerBody> createState() =>
      _LunarBirthdayPickerBodyState();
}

class _LunarBirthdayPickerBodyState extends State<_LunarBirthdayPickerBody> {
  late int _lunarYear;
  late int _signedMonth;
  late int _day;

  @override
  void initState() {
    super.initState();
    _lunarYear = LunarBirthdayCalendar.referenceLunarYear();
    final init = widget.initial ??
        LunarBirthdayAnchor.fromSolar(DateTime.now()) ??
        const LunarBirthdayAnchor(month: 1, day: 1);
    _signedMonth = init.signedMonth;
    _day = init.day;
  }

  List<({int signedMonth, String label, int dayCount})> get _months =>
      LunarBirthdayCalendar.monthOptions(_lunarYear);

  int get _dayCount {
    for (final m in _months) {
      if (m.signedMonth == _signedMonth) return m.dayCount;
    }
    return 30;
  }

  LunarBirthdayAnchor get _anchor {
    final abs = _signedMonth.abs();
    return LunarBirthdayAnchor(
      month: abs,
      day: _day.clamp(1, _dayCount),
      isLeapMonth: _signedMonth < 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final preview = LunarBirthdayCalendar.solarCaption(
      _anchor,
      DateTime.now(),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('选择农历生日', style: context.jichenTitle3()),
          const SizedBox(height: 8),
          Text(
            '按农历月日保存；每年自动换算公历日期',
            style: context.jichenCaption(),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _signedMonth,
            decoration: InputDecoration(
              labelText: '农历月',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _months
                .map(
                  (m) => DropdownMenuItem(
                    value: m.signedMonth,
                    child: Text(m.label),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() {
                _signedMonth = v;
                if (_day > _dayCount) _day = _dayCount;
              });
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _day.clamp(1, _dayCount),
            decoration: InputDecoration(
              labelText: '农历日',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: List.generate(
              _dayCount,
              (i) => DropdownMenuItem(
                value: i + 1,
                child: Text(
                  Lunar.fromYmd(_lunarYear, _signedMonth, i + 1)
                      .getDayInChinese(),
                ),
              ),
            ),
            onChanged: (v) {
              if (v != null) setState(() => _day = v);
            },
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: JichenTokens.yiBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '农历 ${_anchor.label}',
                  style: context.jichenBody(weight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(preview, style: context.jichenCaption()),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pop(context, _anchor),
            style: FilledButton.styleFrom(
              backgroundColor: JichenTokens.accent,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
