import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import '../../app/qing_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../core/hydration/hydration_store.dart';
import '../../core/hydration/models.dart';
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
            tabs: [
              Tab(text: AppLocalizations.of(context).tabDay),
              Tab(text: AppLocalizations.of(context).tabWeek),
              Tab(text: AppLocalizations.of(context).tabMonth),
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
    final l10n = AppLocalizations.of(context);
    final today = DateTime.now();
    final records = _store.records.where((r) {
      return r.recordedAt.year == today.year &&
          r.recordedAt.month == today.month &&
          r.recordedAt.day == today.day;
    }).toList();
    final dayTotal = records.fold<int>(0, (s, r) => s + r.volumeMl);
    final locale = l10n.isZh ? 'zh_CN' : 'en_US';
    final dateLabel = DateFormat.MMMd(locale).format(today);

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
            child: Row(
              children: [
                QwAssetIcon(
                  asset: QwAssets.historyRecord,
                  label: l10n.noRecords,
                  size: 54,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.noDrinksToday,
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
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _openRecordEditor(r),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        QwAssetIcon(
                          asset:
                              QwAssets.drinkIconFor(r.drinkType) ??
                              QwAssets.historyRecord,
                          label: '${_drinkLabel(context, r.drinkType)} icon',
                          size: 42,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _drinkLabel(context, r.drinkType),
                            style: const TextStyle(
                              color: QwColors.ink,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          VolumeFormat.display(r.volumeMl, _store.unit),
                          style: const TextStyle(
                            color: QwColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('HH:mm').format(r.recordedAt),
                          style: const TextStyle(
                            color: QwColors.muted,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: QwColors.muted,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openRecordEditor(IntakeRecord record) async {
    var selectedType = record.drinkType;
    var volume = record.volumeMl.toDouble().clamp(50, 1200).toDouble();
    var recordedAt = record.recordedAt;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final l10n = AppLocalizations.of(context);
            final locale = l10n.isZh ? 'zh_CN' : 'en_US';
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: QwColors.primaryDeep.withValues(alpha: 0.18),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        QwAssetIcon(
                          asset:
                              QwAssets.drinkIconFor(selectedType) ??
                              QwAssets.drinkWaterGlass,
                          label: l10n.editDrink,
                          size: 58,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.editDrink,
                                style: TextStyle(
                                  color: QwColors.ink,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat.yMMMd(locale).add_Hm().format(recordedAt),
                                style: const TextStyle(
                                  color: QwColors.muted,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: DrinkType.values.map((type) {
                        final selected = selectedType == type;
                        return ChoiceChip(
                          label: Text(_drinkLabel(context, type)),
                          selected: selected,
                          onSelected: (_) =>
                              setSheetState(() => selectedType = type),
                          selectedColor: QwColors.primary.withValues(
                            alpha: 0.16,
                          ),
                          labelStyle: TextStyle(
                            color: selected ? QwColors.primary : QwColors.ink,
                            fontWeight: FontWeight.w900,
                          ),
                          side: BorderSide(
                            color: selected ? QwColors.primary : QwColors.line,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text(
                          l10n.amount,
                          style: TextStyle(
                            color: QwColors.ink,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          VolumeFormat.display(volume.round(), _store.unit),
                          style: const TextStyle(
                            color: QwColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: volume,
                      min: 50,
                      max: 1200,
                      divisions: 46,
                      activeColor: QwColors.primary,
                      inactiveColor: QwColors.primary.withValues(alpha: 0.12),
                      onChanged: (value) => setSheetState(() => volume = value),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          l10n.time,
                          style: TextStyle(
                            color: QwColors.ink,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateFormat('HH:mm').format(recordedAt),
                          style: const TextStyle(
                            color: QwColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setSheetState(
                              () => recordedAt = recordedAt.subtract(
                                const Duration(minutes: 15),
                              ),
                            ),
                            child: Text(l10n.adjustTimeMinus),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setSheetState(
                              () => recordedAt = recordedAt.add(
                                const Duration(minutes: 15),
                              ),
                            ),
                            child: Text(l10n.adjustTimePlus),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await _deleteRecord(sheetContext, record);
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: Text(l10n.delete),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFE45B72),
                              side: BorderSide(
                                color: const Color(
                                  0xFFE45B72,
                                ).withValues(alpha: 0.4),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () async {
                              await _saveRecord(
                                sheetContext,
                                record.copyWith(
                                  drinkType: selectedType,
                                  volumeMl: volume.round(),
                                  recordedAt: recordedAt,
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_rounded),
                            label: Text(l10n.save),
                            style: FilledButton.styleFrom(
                              backgroundColor: QwColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveRecord(
    BuildContext sheetContext,
    IntakeRecord record,
  ) async {
    final saved = await _store.updateIntake(record);
    if (!mounted || !sheetContext.mounted) return;
    Navigator.of(sheetContext).pop();
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(saved ? l10n.drinkUpdated : l10n.recordNotFound)),
    );
  }

  Future<void> _deleteRecord(
    BuildContext sheetContext,
    IntakeRecord record,
  ) async {
    final deleted = await _store.deleteIntake(record.id);
    if (!mounted || !sheetContext.mounted) return;
    Navigator.of(sheetContext).pop();
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(deleted ? l10n.drinkDeleted : l10n.recordNotFound)),
    );
  }

  String _drinkLabel(BuildContext context, DrinkType type) {
    return AppLocalizations.of(context).drinkLabel(type);
  }
}

class _HistoryHero extends StatelessWidget {
  const _HistoryHero({required this.average, required this.total});

  final String average;
  final String total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  l10n.dailyAverage,
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
                  l10n.historyTotal(total),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          QwAssetIcon(
            asset: QwAssets.historyAnalytics,
            label: l10n.historyTitle,
            size: 112,
          ),
        ],
      ),
    );
  }
}
