import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/qing_theme.dart';
import '../../l10n/app_locale.dart';
import '../../l10n/app_localizations.dart';
import '../../core/hydration/goal_calculator.dart';
import '../../core/hydration/hydration_store.dart';
import '../../core/hydration/models.dart';
import '../../core/hydration/volume_format.dart';
import '../../core/reminders/reminder_notifications.dart';
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
    final l10n = AppLocalizations.of(context);
    final goal = _store.profile?.dailyGoalMl ?? VolumeFormat.mlFromOz(60);
    return Scaffold(
      body: QwScreenShell(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.me,
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
                  _tile(QwAssets.settingFeedback, l10n.feedback, _openFeedback),
                  _tile(
                    QwAssets.settingUnit,
                    l10n.unit,
                    _toggleUnit,
                    subtitle: Text(_store.unit == VolumeUnit.oz ? 'oz' : 'ml'),
                  ),
                  _tile(
                    QwAssets.settingRecalculate,
                    l10n.language,
                    _toggleLanguage,
                    subtitle: Text(l10n.localeDisplayName),
                  ),
                  _tile(
                    QwAssets.settingRecalculate,
                    l10n.personalDetails,
                    _editProfile,
                    subtitle: Text(_profileSubtitle(context)),
                  ),
                  _tile(
                    QwAssets.settingDailyGoal,
                    l10n.dailyGoal,
                    _editDailyGoal,
                    subtitle: Text(VolumeFormat.display(goal, _store.unit)),
                  ),
                  _tile(
                    QwAssets.settingReminder,
                    l10n.reminders,
                    () => Modular.to.pushNamed('/reminders/'),
                  ),
                  _tile(
                    QwAssets.settingMuteNight,
                    l10n.muteAtNight,
                    () => Modular.to.pushNamed('/reminders/mute'),
                  ),
                  _tile(
                    QwAssets.settingRecalculate,
                    l10n.recalculateGoal,
                    _recalculateGoal,
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

  Future<void> _toggleLanguage() async {
    final next = _store.locale == AppLocale.zh ? AppLocale.en : AppLocale.zh;
    await _store.setLocale(next);
    if (!mounted) return;
    await ReminderNotifications.sync(_store.reminders, requestPermissions: false);
  }

  Future<void> _openFeedback() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _FeedbackSheet(
          onSubmit: (message) => _submitFeedback(sheetContext, message),
        );
      },
    );
  }

  Future<void> _submitFeedback(
    BuildContext sheetContext,
    String message,
  ) async {
    if (message.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).feedbackEmpty)),
      );
      return;
    }

    await _store.addFeedback(message);
    if (!mounted || !sheetContext.mounted) return;
    Navigator.of(sheetContext).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).feedbackSaved)),
    );
  }

  Future<void> _editDailyGoal() async {
    final currentGoal = (_store.profile?.dailyGoalMl ?? VolumeFormat.mlFromOz(60))
        .clamp(1000, 5000)
        .toDouble();
    var goalMl = currentGoal;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final l10n = AppLocalizations.of(context);
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                          asset: QwAssets.settingDailyGoal,
                          label: l10n.dailyGoal,
                          size: 58,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.dailyGoal,
                                style: TextStyle(
                                  color: QwColors.ink,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                VolumeFormat.display(
                                  goalMl.round(),
                                  _store.unit,
                                ),
                                style: const TextStyle(
                                  color: QwColors.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Slider(
                      value: goalMl,
                      min: 1000,
                      max: 5000,
                      divisions: 80,
                      activeColor: QwColors.primary,
                      inactiveColor: QwColors.primary.withValues(alpha: 0.12),
                      onChanged: (value) =>
                          setSheetState(() => goalMl = value),
                    ),
                    Row(
                      children: [
                        Text(
                          VolumeFormat.display(1000, _store.unit),
                          style: const TextStyle(
                            color: QwColors.muted,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          VolumeFormat.display(5000, _store.unit),
                          style: const TextStyle(
                            color: QwColors.muted,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {
                          await _saveDailyGoal(sheetContext, goalMl.round());
                        },
                        icon: const Icon(Icons.check_rounded),
                        label: Text(l10n.saveGoal),
                        style: FilledButton.styleFrom(
                          backgroundColor: QwColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
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

  Future<void> _editProfile() async {
    final profile = _profileOrDefault();
    var gender = profile.gender;
    var weightLbs = profile.weightKg / 0.453592;
    var activity = profile.activityLevel;
    var climate = profile.climate;

    int previewGoal() => GoalCalculator.calculateDailyGoalMl(
      weightKg: weightLbs * 0.453592,
      activityLevel: activity,
      gender: gender,
      climate: climate,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final l10n = AppLocalizations.of(context);
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
                          asset: QwAssets.settingRecalculate,
                          label: l10n.personalDetails,
                          size: 58,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.personalDetails,
                                style: TextStyle(
                                  color: QwColors.ink,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.goalPreview(
                                  VolumeFormat.display(previewGoal(), _store.unit),
                                ),
                                style: const TextStyle(
                                  color: QwColors.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.gender,
                      style: TextStyle(
                        color: QwColors.ink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: Gender.values.map((value) {
                        return _profileChip(
                          label: _genderLabel(context, value),
                          selected: gender == value,
                          onSelected: () =>
                              setSheetState(() => gender = value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          l10n.weight,
                          style: TextStyle(
                            color: QwColors.ink,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          l10n.weightLbs(weightLbs.round()),
                          style: const TextStyle(
                            color: QwColors.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: weightLbs.clamp(80, 250).toDouble(),
                      min: 80,
                      max: 250,
                      divisions: 170,
                      activeColor: QwColors.primary,
                      inactiveColor: QwColors.primary.withValues(alpha: 0.12),
                      onChanged: (value) =>
                          setSheetState(() => weightLbs = value),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.activity,
                      style: TextStyle(
                        color: QwColors.ink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ActivityLevel.values.map((value) {
                        return _profileChip(
                          label: _activityLabel(context, value),
                          selected: activity == value,
                          onSelected: () =>
                              setSheetState(() => activity = value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.climate,
                      style: TextStyle(
                        color: QwColors.ink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: Climate.values.map((value) {
                        return _profileChip(
                          label: _climateLabel(context, value),
                          selected: climate == value,
                          onSelected: () =>
                              setSheetState(() => climate = value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {
                          await _saveProfile(
                            sheetContext,
                            UserProfile(
                              weightKg: weightLbs * 0.453592,
                              activityLevel: activity,
                              dailyGoalMl: previewGoal(),
                              onboardingDone: true,
                              gender: gender,
                              climate: climate,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_rounded),
                        label: Text(l10n.saveProfile),
                        style: FilledButton.styleFrom(
                          backgroundColor: QwColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
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

  Future<void> _saveDailyGoal(BuildContext sheetContext, int goalMl) async {
    final existing = _store.profile;
    final next = existing?.copyWith(dailyGoalMl: goalMl) ??
        UserProfile(
          weightKg: 65,
          activityLevel: ActivityLevel.medium,
          dailyGoalMl: goalMl,
          onboardingDone: true,
        );

    await _store.saveProfile(next);
    if (!mounted || !sheetContext.mounted) return;
    Navigator.of(sheetContext).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).dailyGoalUpdated)),
    );
  }

  Future<void> _saveProfile(
    BuildContext sheetContext,
    UserProfile profile,
  ) async {
    await _store.saveProfile(profile);
    if (!mounted || !sheetContext.mounted) return;
    Navigator.of(sheetContext).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).profileUpdated)),
    );
  }

  Future<void> _recalculateGoal() async {
    final current = _profileOrDefault();
    final nextGoal = GoalCalculator.calculateDailyGoalMl(
      weightKg: current.weightKg,
      activityLevel: current.activityLevel,
      gender: current.gender,
      climate: current.climate,
    );
    await _store.saveProfile(current.copyWith(dailyGoalMl: nextGoal));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).goalRecalculated)),
    );
  }

  Widget _profileChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: QwColors.primary.withValues(alpha: 0.16),
      labelStyle: TextStyle(
        color: selected ? QwColors.primary : QwColors.ink,
        fontWeight: FontWeight.w900,
      ),
      side: BorderSide(color: selected ? QwColors.primary : QwColors.line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  UserProfile _profileOrDefault() {
    return _store.profile ??
        UserProfile(
          weightKg: 65,
          activityLevel: ActivityLevel.medium,
          dailyGoalMl: GoalCalculator.calculateDailyGoalMl(
            weightKg: 65,
            activityLevel: ActivityLevel.medium,
          ),
          onboardingDone: true,
        );
  }

  String _profileSubtitle(BuildContext context) {
    final profile = _profileOrDefault();
    final l10n = AppLocalizations.of(context);
    final weight = l10n.isZh
        ? '${profile.weightKg.round()} kg'
        : '${(profile.weightKg / 0.453592).round()} lbs';
    return '$weight · ${l10n.activityLabel(profile.activityLevel)} · ${l10n.climateLabel(profile.climate)}';
  }

  String _genderLabel(BuildContext context, Gender gender) => AppLocalizations.of(context).genderLabel(gender);

  String _activityLabel(BuildContext context, ActivityLevel activity) => AppLocalizations.of(context).activityLabel(activity);

  String _climateLabel(BuildContext context, Climate climate) => AppLocalizations.of(context).climateLabel(climate);

}

class _FeedbackSheet extends StatefulWidget {
  const _FeedbackSheet({required this.onSubmit});

  final Future<void> Function(String message) onSubmit;

  @override
  State<_FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<_FeedbackSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  asset: QwAssets.settingFeedback,
                  label: l10n.feedback,
                  size: 58,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.feedback,
                    style: TextStyle(
                      color: QwColors.ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: l10n.feedbackHint,
                filled: true,
                fillColor: QwColors.surfaceBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => widget.onSubmit(_controller.text),
                icon: const Icon(Icons.send_rounded),
                label: Text(l10n.sendFeedback),
                style: FilledButton.styleFrom(
                  backgroundColor: QwColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
