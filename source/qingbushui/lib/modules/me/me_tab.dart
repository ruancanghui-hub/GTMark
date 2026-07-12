import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/qing_theme.dart';
import '../../core/hydration/hydration_store.dart';
import '../../core/hydration/models.dart';
import '../../core/hydration/volume_format.dart';
import '../../shared/assets/qw_assets.dart';
import '../../shared/widgets/qw_asset_icon.dart';
import '../../shared/widgets/qw_bottom_nav.dart';
import '../../shared/widgets/qw_screen_shell.dart';

class MeTab extends StatefulWidget {
  const MeTab({super.key, required this.onNavTap});

  final ValueChanged<int> onNavTap;

  @override
  State<MeTab> createState() => _MeTabState();
}

class _MeTabState extends State<MeTab> {
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

  @override
  Widget build(BuildContext context) {
    final goal = _store.profile?.dailyGoalMl ?? VolumeFormat.mlFromOz(60);
    return Scaffold(
      body: QwScreenShell(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Me',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _tile(QwAssets.settingFeedback, 'Feedback', () {}),
                  _tile(
                    QwAssets.settingUnit,
                    'Unit',
                    _toggleUnit,
                    subtitle: Text(_store.unit == VolumeUnit.oz ? 'oz' : 'ml'),
                  ),
                  _tile(
                    QwAssets.settingDailyGoal,
                    'Daily Goal',
                    () {},
                    subtitle: Text(VolumeFormat.display(goal, _store.unit)),
                  ),
                  _tile(
                    QwAssets.settingReminder,
                    'Reminders',
                    () => Modular.to.pushNamed('/reminders/'),
                  ),
                  _tile(
                    QwAssets.settingMuteNight,
                    'Mute at night',
                    () => Modular.to.pushNamed('/reminders/mute'),
                  ),
                  _tile(
                    QwAssets.settingRecalculate,
                    'Recalculate Goal',
                    () => Modular.to.pushNamed('/onboarding/'),
                  ),
                  _materialTile(
                    QwAssets.removeAds,
                    'Remove Ads',
                    _showPlaceholder,
                    subtitle: const Text(
                      '竞品有，本版跳过',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            QwBottomNav(
              index: 3,
              onTap: widget.onNavTap,
              onAdd: () => Modular.to.pushNamed('/drink/select'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _materialTile(
    String iconAsset,
    String title,
    VoidCallback onTap, {
    Widget? subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
      ),
      child: ListTile(
        leading: QwAssetIcon(asset: iconAsset, label: '$title icon', size: 42),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: QwColors.ink,
          ),
        ),
        subtitle: subtitle,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _tile(
    String iconAsset,
    String title,
    VoidCallback onTap, {
    Widget? subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
      ),
      child: ListTile(
        leading: QwAssetIcon(asset: iconAsset, label: '$title icon', size: 42),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: QwColors.ink,
          ),
        ),
        subtitle: subtitle,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Future<void> _toggleUnit() async {
    final next = _store.unit == VolumeUnit.oz ? VolumeUnit.ml : VolumeUnit.oz;
    await _store.setUnit(next);
  }

  void _showPlaceholder() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Ads'),
        content: const Text('视觉还原占位：竞品含广告与内购，轻补水 V1 不接入。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
