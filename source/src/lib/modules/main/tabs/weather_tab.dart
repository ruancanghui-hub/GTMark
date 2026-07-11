import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/prefs/jichen_prefs.dart';
import '../../../core/weather/weather_day_info.dart';
import '../../../core/weather/weather_service.dart';
import '../../../shared/theme/jichen_tokens.dart';
import '../../../widgets/weather_city_picker.dart';
import 'reminder_tab.dart';

/// 天气 Tab（LOOP-005）。
///
/// 品牌 IP 版：天气作为一级入口，提供当前城市、今日天气、小时趋势视觉和未来 5 天列表。
class WeatherTab extends StatefulWidget {
  const WeatherTab({super.key});

  @override
  State<WeatherTab> createState() => _WeatherTabState();
}

class _WeatherTabState extends State<WeatherTab> {
  Map<String, WeatherDayInfo> _weatherByDate = const {};
  bool _loading = true;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String _iso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final start = _today;
    final end = start.add(const Duration(days: 4));
    final map = await WeatherService.fetchForRange(start, end);
    if (!mounted) return;
    setState(() {
      _weatherByDate = map;
      _loading = false;
    });
  }

  Future<void> _pickCity() async {
    final picked = await showWeatherCityPicker(context);
    if (picked == null) return;
    JichenPrefs.prefsTick.value++;
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      JichenPrefs.prefsTick.value;
      final today =
          _weatherByDate[_iso(_today)] ??
          WeatherDayInfo(date: _today, unavailable: true);
      return ColoredBox(
        color: const Color(0xFFEAF6FF),
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _WeatherHero(
                cityName: JichenPrefs.weatherCityName,
                weather: today,
                loading: _loading,
                onPickCity: _pickCity,
                onOpenReminders: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ReminderTab(asSecondaryPage: true),
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _HourlyTrendCard(weather: today),
                      const SizedBox(height: 12),
                      _ForecastCard(
                        start: _today,
                        weatherByDate: _weatherByDate,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }
}

class _WeatherHero extends StatelessWidget {
  const _WeatherHero({
    required this.cityName,
    required this.weather,
    required this.loading,
    required this.onPickCity,
    required this.onOpenReminders,
  });

  final String cityName;
  final WeatherDayInfo weather;
  final bool loading;
  final VoidCallback onPickCity;
  final VoidCallback onOpenReminders;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final temp = weather.tempMaxC?.round();
    final subtitle = weather.unavailable
        ? '天气暂不可用'
        : weather.riskLabels.isEmpty
        ? '多云'
        : weather.riskLabels.join(' · ');

    return Container(
      height: 430,
      padding: EdgeInsets.fromLTRB(20, top + 12, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2699F2), Color(0xFF9DDCFF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 18,
            bottom: 18,
            child: Image.asset(
              'assets/images/brand/ip_deer.png',
              width: 132,
              fit: BoxFit.contain,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: '添加提醒',
                    color: Colors.white,
                    onPressed: onOpenReminders,
                    icon: const Icon(Icons.add_rounded),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onPickCity,
                      borderRadius: BorderRadius.circular(18),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              cityName,
                              overflow: TextOverflow.ellipsis,
                              style: context.jichenBody(
                                color: Colors.white,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.location_on_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (loading)
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 40, height: 40),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                temp == null ? '--°' : '$temp°',
                style: const TextStyle(
                  fontSize: 88,
                  height: 0.95,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -4,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: context
                    .jichenTitle2(color: Colors.white)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                weather.summaryLine ?? weather.sourceCaption,
                style: context.jichenCaption(
                  color: Colors.white.withValues(alpha: 0.86),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HourlyTrendCard extends StatelessWidget {
  const _HourlyTrendCard({required this.weather});

  final WeatherDayInfo weather;

  @override
  Widget build(BuildContext context) {
    final min = weather.tempMinC?.round() ?? 18;
    final max = weather.tempMaxC?.round() ?? 31;
    final points = <int>[
      min,
      (min + 5),
      (min + max) ~/ 2,
      max,
      max - 2,
      max - 5,
    ];
    const hours = ['06:00', '09:00', '12:00', '15:00', '18:00', '21:00'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('今天', style: context.jichenBody(weight: FontWeight.w700)),
              const Spacer(),
              Text(
                weather.homeSummaryLine ?? '$min° / $max°',
                style: context.jichenCaption(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 92,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < points.length; i++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${points[i]}°', style: context.jichenCaption()),
                        const SizedBox(height: 6),
                        Icon(
                          i == 3 ? Icons.wb_sunny_rounded : Icons.cloud_rounded,
                          size: 20,
                          color: i == 3
                              ? const Color(0xFFFFB020)
                              : const Color(0xFF91C9F7),
                        ),
                        const SizedBox(height: 8),
                        Text(hours[i], style: context.jichenFootnote()),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastCard extends StatelessWidget {
  const _ForecastCard({required this.start, required this.weatherByDate});

  final DateTime start;
  final Map<String, WeatherDayInfo> weatherByDate;

  String _iso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedCloud,
                size: 18,
                color: JichenTokens.accent,
              ),
              const SizedBox(width: 6),
              Text('未来5天', style: context.jichenBody(weight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < 5; i++)
            _ForecastRow(
              date: start.add(Duration(days: i)),
              weather:
                  weatherByDate[_iso(start.add(Duration(days: i)))] ??
                  WeatherDayInfo(
                    date: start.add(Duration(days: i)),
                    unavailable: true,
                  ),
            ),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  const _ForecastRow({required this.date, required this.weather});

  final DateTime date;
  final WeatherDayInfo weather;

  static const _weekday = ['一', '二', '三', '四', '五', '六', '日'];

  @override
  Widget build(BuildContext context) {
    final temp = weather.unavailable
        ? '-- / --°'
        : '${weather.tempMinC?.round() ?? '--'}° / ${weather.tempMaxC?.round() ?? '--'}°';
    final risk = weather.riskLabels.isEmpty ? '多云' : weather.riskLabels.first;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 86,
            child: Text(
              '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}  周${_weekday[date.weekday - 1]}',
              style: context.jichenCaption(color: JichenTokens.labelPrimary),
            ),
          ),
          Expanded(child: Text(temp, style: context.jichenCaption())),
          Text(
            weather.unavailable ? '暂无' : risk,
            style: context.jichenCaption(),
          ),
          const SizedBox(width: 8),
          Icon(
            weather.hasRisk ? Icons.water_drop_rounded : Icons.wb_sunny_rounded,
            size: 18,
            color: weather.hasRisk
                ? const Color(0xFF4AA3F0)
                : const Color(0xFFFFB020),
          ),
        ],
      ),
    );
  }
}
