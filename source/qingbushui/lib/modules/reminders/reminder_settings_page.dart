import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/qing_theme.dart';
import '../../core/hydration/hydration_store.dart';
import '../../core/hydration/models.dart';
import '../../shared/assets/qw_assets.dart';
import '../../shared/widgets/qw_asset_icon.dart';
import '../../shared/widgets/qw_screen_shell.dart';

class ReminderSettingsPage extends StatefulWidget {
  const ReminderSettingsPage({super.key});

  @override
  State<ReminderSettingsPage> createState() => _ReminderSettingsPageState();
}

class _ReminderSettingsPageState extends State<ReminderSettingsPage> {
  late final HydrationStore _store;
  late ReminderPrefs _prefs;

  @override
  void initState() {
    super.initState();
    _store = HydrationStore.of();
    _prefs = _store.reminders;
  }

  Future<void> _save(ReminderPrefs next) async {
    setState(() => _prefs = next);
    await _store.saveReminders(next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QwScreenShell(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
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
                  const Text(
                    'Reminders',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                children: [
                  _switchTile(
                    'Enable reminders',
                    null,
                    _prefs.enabled,
                    (v) => _save(_prefs.copyWith(enabled: v)),
                  ),
                  _switchTile(
                    'Wake-up water',
                    '08:00',
                    _prefs.wakeUp,
                    (v) => _save(_prefs.copyWith(wakeUp: v)),
                  ),
                  _switchTile(
                    'Before meals',
                    null,
                    _prefs.beforeMeal,
                    (v) => _save(_prefs.copyWith(beforeMeal: v)),
                  ),
                  _switchTile(
                    'After meals',
                    null,
                    _prefs.afterMeal,
                    (v) => _save(_prefs.copyWith(afterMeal: v)),
                  ),
                  _switchTile(
                    'Bedtime',
                    null,
                    _prefs.bedtime,
                    (v) => _save(_prefs.copyWith(bedtime: v)),
                  ),
                  _card(
                    child: ListTile(
                      leading: const QwAssetIcon(
                        asset: QwAssets.settingMuteNight,
                        label: 'Mute at night icon',
                        size: 44,
                      ),
                      title: const Text(
                        'Mute at night',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        _prefs.muteAtNight
                            ? 'Until ${_prefs.muteEndHour}:${_prefs.muteEndMinute.toString().padLeft(2, '0')}'
                            : 'Off',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Modular.to.pushNamed('/reminders/mute'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Standard local notifications only. Full-screen always-on reminders stay disabled.',
                      style: TextStyle(
                        color: QwColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
    String title,
    String? subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return _card(
      child: SwitchListTile(
        secondary: const QwAssetIcon(
          asset: QwAssets.settingReminder,
          label: 'Reminder icon',
          size: 42,
        ),
        activeThumbColor: QwColors.primary,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: subtitle == null ? null : Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: QwColors.primaryDeep.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
