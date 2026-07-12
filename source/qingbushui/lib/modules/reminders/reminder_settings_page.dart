import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/qing_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../core/hydration/hydration_store.dart';
import '../../core/hydration/models.dart';
import '../../core/reminders/reminder_notifications.dart';
import '../../core/reminders/reminder_schedule_planner.dart';
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
  bool _permissionGranted = true;

  @override
  void initState() {
    super.initState();
    _store = HydrationStore.of();
    _prefs = _store.reminders;
  }

  Future<void> _save(ReminderPrefs next) async {
    setState(() => _prefs = next);
    await _store.saveReminders(next);
    final permitted = await ReminderNotifications.sync(
      next,
      requestPermissions: true,
    );
    if (mounted) setState(() => _permissionGranted = permitted);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_statusText(context, next, permitted))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  Text(
                    l10n.reminders,
                    style: const TextStyle(
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
                  _statusCard(context),
                  _permissionCard(context),
                  _switchTile(
                    context,
                    l10n.enableReminders,
                    null,
                    _prefs.enabled,
                    (v) => _save(_prefs.copyWith(enabled: v)),
                  ),
                  _switchTile(
                    context,
                    l10n.wakeUpWater,
                    _formatTime(_prefs.wakeUpHour, _prefs.wakeUpMinute),
                    _prefs.wakeUp,
                    (v) => _save(_prefs.copyWith(wakeUp: v)),
                    onEditTime: () => _editTime(
                      hour: _prefs.wakeUpHour,
                      minute: _prefs.wakeUpMinute,
                      apply: (h, m) =>
                          _prefs.copyWith(wakeUpHour: h, wakeUpMinute: m),
                    ),
                  ),
                  _switchTile(
                    context,
                    l10n.beforeMeals,
                    _formatTime(_prefs.beforeMealHour, _prefs.beforeMealMinute),
                    _prefs.beforeMeal,
                    (v) => _save(_prefs.copyWith(beforeMeal: v)),
                    onEditTime: () => _editTime(
                      hour: _prefs.beforeMealHour,
                      minute: _prefs.beforeMealMinute,
                      apply: (h, m) => _prefs.copyWith(
                        beforeMealHour: h,
                        beforeMealMinute: m,
                      ),
                    ),
                  ),
                  _switchTile(
                    context,
                    l10n.afterMeals,
                    _formatTime(_prefs.afterMealHour, _prefs.afterMealMinute),
                    _prefs.afterMeal,
                    (v) => _save(_prefs.copyWith(afterMeal: v)),
                    onEditTime: () => _editTime(
                      hour: _prefs.afterMealHour,
                      minute: _prefs.afterMealMinute,
                      apply: (h, m) =>
                          _prefs.copyWith(afterMealHour: h, afterMealMinute: m),
                    ),
                  ),
                  _switchTile(
                    context,
                    l10n.bedtime,
                    _formatTime(_prefs.bedtimeHour, _prefs.bedtimeMinute),
                    _prefs.bedtime,
                    (v) => _save(_prefs.copyWith(bedtime: v)),
                    onEditTime: () => _editTime(
                      hour: _prefs.bedtimeHour,
                      minute: _prefs.bedtimeMinute,
                      apply: (h, m) =>
                          _prefs.copyWith(bedtimeHour: h, bedtimeMinute: m),
                    ),
                  ),
                  _card(
                    child: ListTile(
                      leading: QwAssetIcon(
                        asset: QwAssets.settingMuteNight,
                        label: l10n.muteAtNight,
                        size: 44,
                      ),
                      title: Text(
                        l10n.muteAtNight,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        _prefs.muteAtNight
                            ? l10n.muteUntil(
                                '${_prefs.muteEndHour}:${_prefs.muteEndMinute.toString().padLeft(2, '0')}',
                              )
                            : l10n.muteOff,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Modular.to.pushNamed('/reminders/mute'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.reminderNote,
                      style: const TextStyle(
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

  Widget _statusCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _card(
      child: ListTile(
        leading: QwAssetIcon(
          asset: QwAssets.settingReminder,
          label: l10n.reminders,
          size: 46,
        ),
        title: Text(
          _statusText(context, _prefs, _permissionGranted),
          style: const TextStyle(
            color: QwColors.ink,
            fontWeight: FontWeight.w900,
          ),
        ),
        subtitle: Text(
          l10n.remindersRebuildNote,
          style: const TextStyle(
            color: QwColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _permissionCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                QwAssetIcon(
                  asset: QwAssets.settingReminder,
                  label: l10n.systemNotificationPermission,
                  size: 44,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.systemNotificationPermission,
                    style: const TextStyle(
                      color: QwColors.ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.enableSystemNotificationsOnce,
              style: const TextStyle(
                color: QwColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _save(_prefs.copyWith(enabled: true)),
                icon: const Icon(Icons.notifications_active_rounded),
                label: Text(l10n.enableNotifications),
                style: FilledButton.styleFrom(
                  backgroundColor: QwColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusText(
    BuildContext context,
    ReminderPrefs prefs, [
    bool permitted = true,
  ]) {
    final l10n = AppLocalizations.of(context);
    final count = ReminderSchedulePlanner.dailySlots(prefs).length;
    return l10n.dailyRemindersStatus(count, permitted, prefs.enabled);
  }

  Widget _switchTile(
    BuildContext context,
    String title,
    String? subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    VoidCallback? onEditTime,
  }) {
    final l10n = AppLocalizations.of(context);
    return _card(
      child: ListTile(
        leading: QwAssetIcon(
          asset: QwAssets.settingReminder,
          label: l10n.reminders,
          size: 42,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: const TextStyle(
                  color: QwColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEditTime != null)
              IconButton(
                tooltip: l10n.editTime,
                onPressed: onEditTime,
                icon: const Icon(Icons.schedule_rounded),
                color: QwColors.primary,
              ),
            Switch(
              activeThumbColor: QwColors.primary,
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editTime({
    required int hour,
    required int minute,
    required ReminderPrefs Function(int hour, int minute) apply,
  }) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );
    if (selected == null) return;
    await _save(apply(selected.hour, selected.minute));
  }

  String _formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
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
