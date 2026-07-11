import 'package:flutter/material.dart';

import '../../core/weather/weather_day_info.dart';
import '../../core/weather/weather_service.dart';
import '../../shared/theme/jichen_tokens.dart';

/// 日期详情天气摘要块（LOOP-005 / SPEC-016）。
class DateDetailWeatherSection extends StatefulWidget {
  const DateDetailWeatherSection({super.key, required this.date});

  final DateTime date;

  @override
  State<DateDetailWeatherSection> createState() =>
      _DateDetailWeatherSectionState();
}

class _DateDetailWeatherSectionState extends State<DateDetailWeatherSection> {
  WeatherDayInfo? _weather;
  bool _loading = true;

  bool get _fetchable {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(widget.date.year, widget.date.month, widget.date.day);
    final diff = d.difference(today).inDays;
    return diff >= 0 && diff <= 15;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant DateDetailWeatherSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date) _load();
  }

  Future<void> _load() async {
    if (!_fetchable) {
      setState(() {
        _loading = false;
        _weather = null;
      });
      return;
    }
    setState(() => _loading = true);
    final w = await WeatherService.fetchForDate(widget.date);
    if (mounted) {
      setState(() {
        _weather = w;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: JichenTokens.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('天气', style: context.jichenTitle3()),
          const SizedBox(height: 8),
          if (!_fetchable)
            Text(
              '历史日期或超出预报范围，暂无天气摘要',
              style: context.jichenBody(color: JichenTokens.labelSecondary),
            )
          else if (_loading)
            Text('天气加载中…', style: context.jichenCaption())
          else if (_weather == null || _weather!.unavailable)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '天气暂不可用，不影响日期与提醒',
                  style: context.jichenBody(color: JichenTokens.labelSecondary),
                ),
                TextButton(onPressed: _load, child: const Text('重试')),
              ],
            )
          else ...[
            if (_weather!.summaryLine != null)
              Text(_weather!.summaryLine!, style: context.jichenBody()),
            if (_weather!.riskLabels.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _weather!.riskLabels
                    .map(
                      (label) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: JichenTokens.workdayAdjust
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          label,
                          style: context.jichenCaption(
                            color: JichenTokens.workdayAdjust,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (_weather!.riskLabels.isEmpty)
              Text('暂无天气风险', style: context.jichenCaption()),
          ],
          const SizedBox(height: 8),
          Text(
            _weather?.sourceCaption ?? 'Open-Meteo · 仅供参考',
            style: context.jichenCaption(),
          ),
        ],
      ),
    );
  }
}
