import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../app/qing_theme.dart';
import '../../core/hydration/hydration_store.dart';
import '../../core/hydration/models.dart';
import '../../core/hydration/volume_format.dart';
import '../../shared/assets/qw_assets.dart';
import '../../shared/visuals/qw_water_bottle_hero.dart';
import '../../shared/widgets/qw_asset_icon.dart';
import '../../shared/widgets/qw_bottom_nav.dart';
import '../../shared/widgets/qw_glass_chip.dart';
import '../../shared/widgets/qw_screen_shell.dart';
import '../../shared/widgets/water_progress_ring.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.onNavTap});

  final ValueChanged<int> onNavTap;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final HydrationStore _store;

  @override
  void initState() {
    super.initState();
    _store = HydrationStore.of();
    _store.addListener(_onChange);
  }

  @override
  void dispose() {
    _store.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  Future<void> _quickAddOz(double oz) async {
    await _store.addIntake(
      drinkType: DrinkType.water,
      volumeMl: VolumeFormat.mlFromOz(oz),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已记录 ${oz.toStringAsFixed(1)} oz')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final goal = _store.profile?.dailyGoalMl ?? VolumeFormat.mlFromOz(60);
    final drank = _store.todayTotal();
    final progress = goal > 0 ? (drank / goal).clamp(0.0, 1.0) : 0.0;
    final pct = (progress * 100).round();
    final drankOz = VolumeFormat.displayOzCompact(drank);
    final goalOz = VolumeFormat.displayOzCompact(goal);

    return QwScreenShell(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
              children: [
                const _HomeHeader(),
                const SizedBox(height: 16),
                _GoalPill(goalOz: goalOz),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    QwGlassChip(icon: Icons.water_drop_rounded, label: 'Today'),
                    QwGlassChip(icon: Icons.flag_rounded, label: 'Goal'),
                    QwGlassChip(
                      icon: Icons.notifications_rounded,
                      label: 'Reminder',
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Center(child: QwWaterBottleHero(progress: progress, size: 224)),
                const SizedBox(height: 4),
                _TodayTitleRow(percent: pct),
                const SizedBox(height: 12),
                _HydrationCard(
                  progress: progress,
                  drankOz: drankOz,
                  goalOz: goalOz,
                  onDrink: () => Modular.to.pushNamed('/drink/select'),
                ),
                const SizedBox(height: 16),
                _QuickAddPanel(onTap: _quickAddOz),
                const SizedBox(height: 18),
                _RecentDrinks(records: _todayRecords(), unit: _store.unit),
              ],
            ),
          ),
          QwBottomNav(
            index: 0,
            onTap: widget.onNavTap,
            onAdd: () => Modular.to.pushNamed('/drink/select'),
          ),
        ],
      ),
    );
  }

  List<IntakeRecord> _todayRecords() {
    final now = DateTime.now();
    return _store.records
        .where((record) {
          return record.recordedAt.year == now.year &&
              record.recordedAt.month == now.month &&
              record.recordedAt.day == now.day;
        })
        .take(4)
        .toList();
  }
}

class _QuickAddPanel extends StatelessWidget {
  const _QuickAddPanel({required this.onTap});

  final Future<void> Function(double) onTap;

  static const _amounts = [8.0, 12.0, 16.0, 20.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: QwColors.primaryDeep.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              'Quick add',
              style: TextStyle(
                color: QwColors.ink,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final oz in _amounts)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: oz == _amounts.first ? 0 : 4,
                      right: oz == _amounts.last ? 0 : 4,
                    ),
                    child: _QuickCupButton(oz: oz, onTap: onTap),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickCupButton extends StatelessWidget {
  const _QuickCupButton({required this.oz, required this.onTap});

  final double oz;
  final Future<void> Function(double) onTap;

  @override
  Widget build(BuildContext context) {
    final amount = oz.toStringAsFixed(0);
    return _PressableScale(
      onTap: () => onTap(oz),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: QwColors.surfaceBlue.withValues(alpha: 0.64),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QwAssetIcon(
              asset: QwAssets.quickCupForOz(oz),
              label: '$amount oz quick add cup',
              size: 42,
            ),
            const SizedBox(height: 4),
            Text(
              '$amount oz',
              style: const TextStyle(
                color: QwColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'Q',
              style: TextStyle(
                color: QwColors.primary,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Qing Water',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.28),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _GoalPill extends StatelessWidget {
  const _GoalPill({required this.goalOz});

  final String goalOz;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: QwColors.primaryDeep.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Color(0xFFB9C6D5), size: 24),
          const SizedBox(width: 10),
          const Text(
            'Daily goal',
            style: TextStyle(
              color: Color(0xFFB2BECC),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            '$goalOz oz',
            style: const TextStyle(
              color: QwColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayTitleRow extends StatelessWidget {
  const _TodayTitleRow({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'Today',
          style: TextStyle(
            color: QwColors.ink,
            fontSize: 23,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Text(
              'Hydration dashboard',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: QwColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Text(
          '$percent%',
          style: const TextStyle(
            color: QwColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _HydrationCard extends StatelessWidget {
  const _HydrationCard({
    required this.progress,
    required this.drankOz,
    required this.goalOz,
    required this.onDrink,
  });

  final double progress;
  final String drankOz;
  final String goalOz;
  final VoidCallback onDrink;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: QwGradients.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: QwColors.primaryDeep.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hydrate gently',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$drankOz / $goalOz oz',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 116,
                  height: 36,
                  child: FilledButton(
                    onPressed: onDrink,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD66B),
                      foregroundColor: QwColors.ink,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: const Text(
                      '+ Drink',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 104,
            height: 104,
            child: WaterProgressRing(
              progress: progress,
              centerLabel: '${(progress * 100).round()}%',
              subtitle: '',
              compact: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _PressableScale extends StatefulWidget {
  const _PressableScale({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.97 : 1,
        child: widget.child,
      ),
    );
  }
}

class _RecentDrinks extends StatelessWidget {
  const _RecentDrinks({required this.records, required this.unit});

  final List<IntakeRecord> records;
  final VolumeUnit unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: QwColors.primaryDeep.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Today's drinks",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: QwColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                records.isEmpty ? 'No records' : '${records.length} recent',
                style: const TextStyle(
                  color: QwColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (records.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Tap + to add your first cup today.',
                style: TextStyle(
                  color: QwColors.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            ...records.map(
              (record) => _DrinkRecordRow(record: record, unit: unit),
            ),
        ],
      ),
    );
  }
}

class _DrinkRecordRow extends StatelessWidget {
  const _DrinkRecordRow({required this.record, required this.unit});

  final IntakeRecord record;
  final VolumeUnit unit;

  @override
  Widget build(BuildContext context) {
    final recordAsset = QwAssets.drinkIconFor(record.drinkType);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: QwColors.surfaceBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            height: 38,
            child: QwAssetIcon(
              asset: recordAsset ?? QwAssets.drinkWaterGlass,
              label: '${_drinkLabel(record.drinkType)} record icon',
              size: 38,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _drinkLabel(record.drinkType),
                  style: const TextStyle(
                    color: QwColors.ink,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('HH:mm').format(record.recordedAt),
                  style: const TextStyle(
                    color: QwColors.muted,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            VolumeFormat.display(record.volumeMl, unit),
            style: const TextStyle(
              color: QwColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  static String _drinkLabel(DrinkType type) {
    switch (type) {
      case DrinkType.water:
        return 'Water';
      case DrinkType.tea:
        return 'Tea';
      case DrinkType.coffee:
        return 'Coffee';
      case DrinkType.juice:
        return 'Juice';
      case DrinkType.custom:
        return 'Custom drink';
      case DrinkType.milk:
        return 'Milk';
      case DrinkType.beer:
        return 'Beer';
      case DrinkType.coldDrink:
        return 'Cold drink';
      case DrinkType.orangeJuice:
        return 'Orange juice';
    }
  }
}
