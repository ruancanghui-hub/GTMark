import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import '../../app/qing_theme.dart';
import '../../core/hydration/hydration_store.dart';
import '../../core/hydration/volume_format.dart';
import '../../shared/assets/qw_assets.dart';
import '../../shared/widgets/qw_asset_icon.dart';
import '../../shared/widgets/qw_bottom_nav.dart';
import '../../shared/widgets/qw_screen_shell.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key, required this.onNavTap});

  final ValueChanged<int> onNavTap;

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab>
    with SingleTickerProviderStateMixin {
  late final HydrationStore _store;
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _store = HydrationStore.of();
    _store.addListener(_onChange);
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _store.removeListener(_onChange);
    _tab.dispose();
    super.dispose();
  }

  void _onChange() => setState(() {});

  List<DateTime> _days(int count) {
    final today = DateTime.now();
    return List.generate(count, (i) {
      final d = today.subtract(Duration(days: count - 1 - i));
      return DateTime(d.year, d.month, d.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final goal = _store.profile?.dailyGoalMl ?? VolumeFormat.mlFromOz(60);
    final goalOz = VolumeFormat.ozFromMl(goal);
    final dayCount = _tab.index == 0 ? 1 : (_tab.index == 1 ? 7 : 30);
    final days = _days(dayCount);
    final totals = days
        .map((d) => _store.stats.totalForDay(_store.records, d))
        .toList();
    final avgMl = totals.isEmpty
        ? 0
        : totals.reduce((a, b) => a + b) ~/ totals.length;
    final totalMl = totals.fold<int>(0, (s, v) => s + v);

    return QwScreenShell(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          TabBar(
            controller: _tab,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: const [
              Tab(text: 'Day'),
              Tab(text: 'Week'),
              Tab(text: 'Month'),
            ],
          ),
          _HistoryHero(
            average: VolumeFormat.display(avgMl, _store.unit),
            total: VolumeFormat.display(totalMl, _store.unit),
          ),
          SizedBox(
            height: 190,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 12, 20, 6),
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: QwColors.primaryDeep.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: _tab.index == 2
                  ? _lineChart(totals, goalOz)
                  : _barChart(totals, goal),
            ),
          ),
          Expanded(child: _historyList()),
          QwBottomNav(
            index: 1,
            onTap: widget.onNavTap,
            onAdd: () => Modular.to.pushNamed('/drink/select'),
          ),
        ],
      ),
    );
  }

  Widget _barChart(List<int> totals, int goal) {
    return BarChart(
      BarChartData(
        maxY: (goal * 1.2).toDouble(),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        barGroups: List.generate(totals.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: totals[i].toDouble(),
                gradient: QwGradients.primary,
                width: 16,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _lineChart(List<int> totals, double goalOz) {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: goalOz * 1.5,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 3,
              getTitlesWidget: (v, _) => Text(
                '${v.toInt() + 1}',
                style: const TextStyle(color: QwColors.muted, fontSize: 10),
              ),
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: goalOz * 0.87,
              color: QwColors.line,
              dashArray: [4, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.centerLeft,
                labelResolver: (_) => '${goalOz.toStringAsFixed(0)} oz',
                style: const TextStyle(color: QwColors.muted, fontSize: 10),
              ),
            ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              totals.length,
              (i) => FlSpot(i.toDouble(), VolumeFormat.ozFromMl(totals[i])),
            ),
            isCurved: true,
            color: QwColors.primary,
            barWidth: 2,
            dotData: FlDotData(
              getDotPainter: (s, p, bar, i) => FlDotCirclePainter(
                radius: i == totals.length - 1 ? 4 : 0,
                color: QwColors.primary,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  QwColors.primary.withValues(alpha: 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyList() {
    final today = DateTime.now();
    final records = _store.records.where((r) {
      return r.recordedAt.year == today.year &&
          r.recordedAt.month == today.month &&
          r.recordedAt.day == today.day;
    }).toList();
    final dayTotal = records.fold<int>(0, (s, r) => s + r.volumeMl);
    final dateLabel = DateFormat('MMM d').format(today);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      children: [
        Row(
          children: [
            Text(
              dateLabel,
              style: const TextStyle(
                color: QwColors.ink,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Text(
              VolumeFormat.display(dayTotal, _store.unit),
              style: const TextStyle(
                color: QwColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (records.isEmpty)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              children: [
                QwAssetIcon(
                  asset: QwAssets.historyRecord,
                  label: 'No records icon',
                  size: 54,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No drinks logged yet today.',
                    style: TextStyle(
                      color: QwColors.muted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ...records.map(
            (r) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const QwAssetIcon(
                    asset: QwAssets.historyRecord,
                    label: 'Drink record icon',
                    size: 42,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    VolumeFormat.display(r.volumeMl, _store.unit),
                    style: const TextStyle(
                      color: QwColors.ink,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('HH:mm').format(r.recordedAt),
                    style: const TextStyle(
                      color: QwColors.muted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _HistoryHero extends StatelessWidget {
  const _HistoryHero({required this.average, required this.total});

  final String average;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
      decoration: BoxDecoration(
        gradient: QwGradients.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: QwColors.primaryDeep.withValues(alpha: 0.18),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Average',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  average,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total $total',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const QwAssetIcon(
            asset: QwAssets.historyAnalytics,
            label: 'Hydration analytics illustration',
            size: 112,
          ),
        ],
      ),
    );
  }
}
