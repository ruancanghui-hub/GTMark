import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/hydration/hydration_store.dart';

class StatsTab extends StatefulWidget {
  const StatsTab({super.key});

  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab>
    with SingleTickerProviderStateMixin {
  late final HydrationStore _store;
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _store = HydrationStore.of();
    _store.addListener(_onChange);
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _store.removeListener(_onChange);
    _tab.dispose();
    super.dispose();
  }

  void _onChange() => setState(() {});

  List<int> _lastDays(int count) {
    final today = DateTime.now();
    return List.generate(count, (i) {
      final d = today.subtract(Duration(days: count - 1 - i));
      return _store.stats.totalForDay(_store.records, d);
    });
  }

  @override
  Widget build(BuildContext context) {
    final goal = _store.profile?.dailyGoalMl ?? 2000;
    final streak = _store.stats.streakDays(
      _store.records,
      goal,
      DateTime.now(),
    );
    final data = _lastDays(_tab.index == 0 ? 1 : (_tab.index == 1 ? 7 : 30));
    final labels = _tab.index == 0
        ? ['今日']
        : List.generate(data.length, (i) => '${i + 1}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('数据统计'),
        bottom: TabBar(
          controller: _tab,
          onTap: (_) => setState(() {}),
          tabs: const [
            Tab(text: '日'),
            Tab(text: '周'),
            Tab(text: '月'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('连续打卡 $streak 天', style: const TextStyle(fontSize: 18)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  maxY: (goal * 1.2).toDouble(),
                  barGroups: List.generate(data.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: data[i].toDouble(),
                          color: const Color(0xFF2B9FD9),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          v.toInt() < labels.length ? labels[v.toInt()] : '',
                        ),
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
