import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/date/day_info.dart';
import '../../../../core/prefs/jichen_prefs.dart';
import '../../../../core/weather/weather_day_info.dart';
import '../../../../core/weather/weather_service.dart';
import '../../../../shared/theme/jichen_tokens.dart';
import '../../../../widgets/month_calendar.dart';
import '../../../../widgets/weather_city_picker.dart';

/// 今日 Hero 卡：左侧大字日期 + 右侧天气（骨架稿排版）。
class TodayHeroCard extends StatefulWidget {
  const TodayHeroCard({
    super.key,
    required this.info,
    required this.onTapDetail,
  });

  final DayInfo info;
  final VoidCallback onTapDetail;

  @override
  State<TodayHeroCard> createState() => _TodayHeroCardState();
}

class _TodayHeroCardState extends State<TodayHeroCard> {
  WeatherDayInfo? _weather;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant TodayHeroCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info.date != widget.info.date) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final w = await WeatherService.fetchForDate(widget.info.date);
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
    final info = widget.info;
    final d = info.date;
    final jieQi = info.jieQi;
    final festival = info.festivalName;

    return Obx(() {
      final _ = JichenPrefs.prefsTick.value;
      return Material(
        color: JichenTokens.surface,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: widget.onTapDetail,
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -10,
                  child: Opacity(
                    opacity: 0.12,
                    child: Icon(
                      Icons.filter_vintage_outlined,
                      size: 140,
                      color: JichenTokens.accent,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${d.day}号',
                                      style: context.jichenHeroDay(),
                                    ),
                                    if (info.isToday)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                          top: 6,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: JichenTokens.accent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '今天',
                                            style: context.jichenCaption(
                                              color: JichenTokens.accent,
                                            ).copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${d.year}年${d.month}月${d.day}日 ${info.weekdayLabel}',
                                  style: context.jichenBody(
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  info.lunarLabel,
                                  style: context.jichenBody(
                                    color: JichenTokens.labelSecondary,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                                if (jieQi != null) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    jieQi,
                                    style: context.jichenBody(
                                      weight: FontWeight.w800,
                                      color: JichenTokens.accent,
                                    ),
                                  ),
                                ] else if (festival != null) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    festival,
                                    style: context.jichenBody(
                                      weight: FontWeight.w800,
                                      color: JichenTokens.accent,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: _pickCity,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const HugeIcon(
                                        icon: HugeIcons.strokeRoundedLocation01,
                                        size: 16,
                                        color: JichenTokens.labelSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          JichenPrefs.weatherCityName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.jichenBody(
                                            weight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '切换',
                                        style: context.jichenCaption(
                                          color: JichenTokens.accent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (_loading)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                else if (_weather != null &&
                                    !_weather!.unavailable) ...[
                                  if (_weather!.homeSummaryLine != null)
                                    Text(
                                      _weather!.homeSummaryLine!,
                                      textAlign: TextAlign.right,
                                      style: context.jichenBody(
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                  if (_weather!.riskLabels.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      _weather!.riskLabels.join(' · '),
                                      textAlign: TextAlign.right,
                                      style: context.jichenBody(
                                        color: JichenTokens.workdayAdjust,
                                        weight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ] else ...[
                                  Text(
                                    '天气暂不可用',
                                    textAlign: TextAlign.right,
                                    style: context.jichenBody(
                                      color: JichenTokens.labelSecondary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _load,
                                    child: const Text('重试'),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      TodayYiJiStrip(info: info),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    });
  }
}

/// 顶部宜忌摘要条（与日期同卡展示）。
class TodayYiJiStrip extends StatelessWidget {
  const TodayYiJiStrip({super.key, required this.info});

  final DayInfo info;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '宜忌摘要',
          style: context.jichenBody(
            color: JichenTokens.workdayAdjust,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        if (!info.hasHuangli)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              '基础日历可用，黄历数据待更新',
              style: context.jichenCaption(
                color: JichenTokens.labelSecondary,
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                color: JichenTokens.yiText,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                info.yiSummary,
                style: context.jichenBody(
                  color: JichenTokens.yiText,
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                color: JichenTokens.jiText,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                info.jiSummary,
                style: context.jichenBody(
                  color: JichenTokens.jiText,
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 红色顶栏（骨架稿）：仅年月，点击弹出日期选择。
class TodayTopBar extends StatelessWidget {
  const TodayTopBar({
    super.key,
    required this.month,
    required this.onMonthTap,
  });

  final DateTime month;
  final VoidCallback onMonthTap;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return ColoredBox(
      color: JichenTokens.accent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, top + 6, 16, 10),
        child: InkWell(
          onTap: onMonthTap,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                monthTitle(month),
                style: context.jichenBody(
                  color: Colors.white,
                  weight: FontWeight.w700,
                ),
              ),
              const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowDown01,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}