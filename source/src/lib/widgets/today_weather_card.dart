import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/prefs/jichen_prefs.dart';
import '../core/weather/weather_day_info.dart';
import '../core/weather/weather_service.dart';
import '../shared/theme/jichen_tokens.dart';
import 'weather_city_picker.dart';

/// 今日页天气条（LOOP-005）。
class TodayWeatherCard extends StatefulWidget {
  const TodayWeatherCard({super.key, required this.date});

  final DateTime date;

  @override
  State<TodayWeatherCard> createState() => _TodayWeatherCardState();
}

class _TodayWeatherCardState extends State<TodayWeatherCard> {
  WeatherDayInfo? _weather;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant TodayWeatherCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final w = await WeatherService.fetchForDate(widget.date);
    if (mounted) {
      setState(() {
        _weather = w;
        _loading = false;
      });
    }
  }

  Future<void> _pickCity() async {
    final picked = await showWeatherCityPicker(context);
    if (picked != null && mounted) {
      JichenPrefs.prefsTick.value++;
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = JichenPrefs.prefsTick.value;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: JichenTokens.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickCity,
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 18),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            JichenPrefs.weatherCityName,
                            style: context.jichenBody(weight: FontWeight.w600),
                          ),
                        ),
                        Text('切换', style: context.jichenCaption()),
                      ],
                    ),
                  ),
                ),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (!_loading && _weather != null && !_weather!.unavailable) ...[
              if (_weather!.summaryLine != null)
                Text(_weather!.summaryLine!, style: context.jichenBody()),
              if (_weather!.riskLabels.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _weather!.riskLabels
                      .map(
                        (l) => Text(
                          l,
                          style: context.jichenCaption(
                            color: JichenTokens.workdayAdjust,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 4),
              Text(_weather!.sourceCaption, style: context.jichenCaption()),
            ] else if (!_loading) ...[
              Text(
                '天气暂不可用',
                style: context.jichenBody(color: JichenTokens.labelSecondary),
              ),
              TextButton(onPressed: _load, child: const Text('重试')),
            ],
          ],
        ),
      );
    });
  }
}
