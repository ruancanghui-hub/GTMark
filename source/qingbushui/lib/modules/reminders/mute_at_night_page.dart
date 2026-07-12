import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/qing_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../core/hydration/hydration_store.dart';
import '../../core/reminders/reminder_notifications.dart';
import '../../shared/assets/qw_assets.dart';
import '../../shared/widgets/qw_asset_icon.dart';
import '../../shared/widgets/qw_screen_shell.dart';

class MuteAtNightPage extends StatefulWidget {
  const MuteAtNightPage({super.key});

  @override
  State<MuteAtNightPage> createState() => _MuteAtNightPageState();
}

class _MuteAtNightPageState extends State<MuteAtNightPage> {
  late final HydrationStore _store;
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _store = HydrationStore.of();
    _hour = _store.reminders.muteEndHour;
    _minute = _store.reminders.muteEndMinute;
  }

  Future<void> _save() async {
    final next = _store.reminders.copyWith(
      muteAtNight: true,
      muteEndHour: _hour,
      muteEndMinute: _minute,
    );
    await _store.saveReminders(next);
    await ReminderNotifications.sync(next, requestPermissions: true);
    if (mounted) Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QwScreenShell(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  Material(
                    color: Colors.white.withValues(alpha: 0.36),
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Modular.to.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context).muteAtNight,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            QwAssetIcon(
              asset: QwAssets.muteNightHero,
              label: AppLocalizations.of(context).muteAtNight,
              size: 172,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                AppLocalizations.of(context).whenEndDay,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _wheel(
                      value: _hour,
                      max: 23,
                      onChanged: (v) => setState(() => _hour = v),
                    ),
                    const Text(
                      ' : ',
                      style: TextStyle(
                        color: QwColors.primary,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    _wheel(
                      value: _minute,
                      max: 59,
                      step: 15,
                      onChanged: (v) => setState(() => _minute = v),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: QwColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  onPressed: _save,
                  child: Text(
                    AppLocalizations.of(context).save,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wheel({
    required int value,
    required int max,
    int step = 1,
    required ValueChanged<int> onChanged,
  }) {
    return SizedBox(
      width: 80,
      height: 160,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 48,
        perspective: 0.003,
        diameterRatio: 1.4,
        onSelectedItemChanged: (i) => onChanged(i * step),
        controller: FixedExtentScrollController(initialItem: value ~/ step),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: (max ~/ step) + 1,
          builder: (_, i) {
            final v = i * step;
            final selected = v == value;
            return Center(
              child: Text(
                v.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: selected
                      ? QwColors.primaryDeep
                      : QwColors.muted.withValues(alpha: 0.5),
                  fontSize: selected ? 32 : 24,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
