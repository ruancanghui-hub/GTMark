import 'package:lunar/lunar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/date/lunar_birthday.dart';
import '../../core/date/lunar_helper.dart';
import '../../widgets/lunar_birthday_picker_sheet.dart';
import '../../core/prefs/jichen_prefs.dart';
import '../../core/reminder/notification_service.dart';
import '../../core/reminder/personal_reminder.dart';
import '../../core/reminder/reminder_kind.dart';
import '../../core/reminder/reminder_personal_meta.dart';
import '../../core/reminder/reminder_advance.dart';
import '../../core/reminder/reminder_repeat.dart';
import '../../core/reminder/reminder_store.dart';
import '../../shared/theme/jichen_tokens.dart';
import '../backup/backup_prompt.dart';

typedef ReminderSaveCallback =
    Future<({bool saved, bool notifyPending})> Function(
      PersonalReminder reminder, {
      required bool isEditing,
    });

Future<({bool saved, bool notifyPending})> _saveReminder(
  PersonalReminder reminder, {
  required bool isEditing,
}) async {
  if (isEditing) {
    await ReminderStore.update(reminder);
    return (saved: true, notifyPending: reminder.notifyPending);
  }
  return ReminderStore.save(reminder);
}

/// 新建/编辑提醒（LOOP-003）。
Future<({bool saved, bool notifyPending})?> showReminderEditorSheet(
  BuildContext context, {
  PersonalReminder? existing,
  PersonalReminder? initial,
  ReminderSaveCallback? saveReminder,
}) async {
  final result = await showModalBottomSheet<({bool saved, bool notifyPending})>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: JichenTokens.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => FractionallySizedBox(
      heightFactor: 0.96,
      child: _ReminderEditorBody(
        existing: existing,
        initial: initial,
        saveReminder: saveReminder ?? _saveReminder,
      ),
    ),
  );
  if (result?.saved == true && context.mounted) {
    await BackupPrompt.maybeShow(context);
  }
  return result;
}

class _ReminderEditorBody extends StatefulWidget {
  const _ReminderEditorBody({
    this.existing,
    this.initial,
    required this.saveReminder,
  });

  final PersonalReminder? existing;
  final PersonalReminder? initial;
  final ReminderSaveCallback saveReminder;

  @override
  State<_ReminderEditorBody> createState() => _ReminderEditorBodyState();
}

class _ReminderEditorBodyState extends State<_ReminderEditorBody> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _noteCtrl;
  late DateTime _date;
  late TimeOfDay _time;
  late bool _notify;
  late Set<int> _advanceSelected;
  late ReminderRepeatRule _repeat;
  late ReminderKind _kind;
  late bool _allDay;
  late String _category;
  late bool _lunarLeapPreferred;
  LunarBirthdayAnchor? _lunarAnchor;
  String? _titleError;
  String? _lunarError;
  String? _metaError;
  String? _saveError;
  bool _isSaving = false;
  bool _lunarPickerScheduled = false;
  String? _birthdayRelation;
  String? _anniversarySubtype;
  String _countdownTheme = 'time';

  bool get _shouldAutoShowLunarPicker =>
      widget.existing == null &&
      _kind == ReminderKind.birthday &&
      widget.initial?.lunarBirthdayAnchor == null;

  @override
  void initState() {
    super.initState();
    final base = widget.existing ?? widget.initial;
    _titleCtrl = TextEditingController(text: base?.title ?? '');
    _noteCtrl = TextEditingController(text: base?.note ?? '');
    _date = base?.date ?? DateTime.now();
    _time = TimeOfDay(hour: base?.hour ?? 9, minute: base?.minute ?? 0);
    _notify = base?.notifyEnabled ?? true;
    _advanceSelected = Set<int>.from(
      base?.advanceMinutesList ?? kDefaultAdvanceMinutes,
    );
    _repeat = base?.repeatRule ?? ReminderRepeatRule.none;
    _kind = base?.kind ?? ReminderKind.event;
    _allDay = base?.allDay ?? false;
    _category = base?.category ?? 'general';
    _lunarLeapPreferred = base?.lunarLeapPreferred ?? false;
    _lunarAnchor =
        base?.lunarBirthdayAnchor ??
        (base?.kind == ReminderKind.birthday
            ? LunarBirthdayAnchor.fromSolar(_date)
            : null);
    _birthdayRelation = base?.birthdayRelation;
    _anniversarySubtype = base?.anniversarySubtype;
    _countdownTheme = base?.countdownTheme ?? 'time';
    if (_kind == ReminderKind.birthday && widget.existing == null) {
      _repeat = ReminderRepeatRule.yearlyLunar;
    }
    _scheduleLunarBirthdayPickerIfNeeded();
  }

  void _scheduleLunarBirthdayPickerIfNeeded() {
    if (!_shouldAutoShowLunarPicker || _lunarPickerScheduled) return;
    _lunarPickerScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _kind != ReminderKind.birthday) return;
      _pickLunarBirthday(isAuto: true);
    });
  }

  Future<void> _pickLunarBirthday({bool isAuto = false}) async {
    final picked = await showLunarBirthdayPickerSheet(
      context,
      initial: _lunarAnchor ?? LunarBirthdayAnchor.fromSolar(_date),
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        _lunarAnchor = picked;
        _lunarError = null;
        _date = LunarBirthdayCalendar.nextSolarOccurrence(
          picked,
          DateTime.now(),
        );
        _repeat = ReminderRepeatRule.yearlyLunar;
      });
    } else if (isAuto) {
      setState(() {
        _lunarAnchor ??= LunarBirthdayAnchor.fromSolar(_date);
      });
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = '请填写提醒标题');
      return;
    }
    setState(() => _titleError = null);

    var lunarLeapPreferred = _lunarLeapPreferred;
    var saveDate = DateTime(_date.year, _date.month, _date.day);
    LunarBirthdayAnchor? lunarAnchor = _lunarAnchor;

    if (_kind == ReminderKind.birthday) {
      if (lunarAnchor == null) {
        setState(() => _lunarError = '请选择农历生日');
        return;
      }
      setState(() => _lunarError = null);
      saveDate = LunarBirthdayCalendar.nextSolarOccurrence(
        lunarAnchor,
        DateTime.now(),
      );
      lunarLeapPreferred = lunarAnchor.isLeapMonth;
    } else if (_repeat == ReminderRepeatRule.yearlyLunar) {
      final lunar = Solar.fromDate(
        DateTime(_date.year, _date.month, _date.day),
      ).getLunar();
      final isLeapMonth = lunar.getMonth() < 0;
      final monthAbs = lunar.getMonth().abs();
      if (isLeapMonth || _hasLeapMonthDuplicate(lunar.getYear(), monthAbs)) {
        final choice = await _askLunarLeapPolicy(context, isLeapMonth);
        if (choice == null) return;
        lunarLeapPreferred = choice;
      }
    }

    if (_kind == ReminderKind.birthday && _birthdayRelation == null) {
      setState(() => _metaError = '请选择生日关系（用于诗句与分享卡）');
      return;
    }
    if (_kind == ReminderKind.anniversary && _anniversarySubtype == null) {
      setState(() => _metaError = '请选择纪念日类型');
      return;
    }
    setState(() => _metaError = null);

    final reminder = PersonalReminder(
      id:
          widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: saveDate,
      hour: _time.hour,
      minute: _time.minute,
      notifyEnabled: _notify,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      source: widget.existing?.source ?? widget.initial?.source ?? 'manual',
      matterId: widget.existing?.matterId ?? widget.initial?.matterId,
      advanceMinutesList: (_advanceSelected.toList()..sort()),
      repeatRule: _repeat,
      lunarLeapPreferred: lunarLeapPreferred,
      kind: _kind,
      lunarBirthdayAnchor: _kind == ReminderKind.birthday ? lunarAnchor : null,
      birthdayRelation: _kind == ReminderKind.birthday
          ? _birthdayRelation
          : null,
      anniversarySubtype: _kind == ReminderKind.anniversary
          ? _anniversarySubtype
          : null,
      countdownTheme: _kind == ReminderKind.countdown ? _countdownTheme : null,
      allDay: _allDay,
      category: _category,
    );

    setState(() {
      _isSaving = true;
      _saveError = null;
    });
    try {
      final result = await widget.saveReminder(
        reminder,
        isEditing: widget.existing != null,
      );
      if (mounted) Navigator.pop(context, result);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _saveError = '保存失败，请稍后重试';
      });
    }
  }

  Future<bool?> _askLunarLeapPolicy(
    BuildContext context,
    bool dateIsLeapMonth,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('农历闰月规则'),
        content: Text(
          dateIsLeapMonth
              ? '所选日期在闰月。每年重复时按哪个月计算？'
              : '该农历月在部分年份有闰月。遇闰月同名月时按哪边计算？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('闰月'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('常月'),
          ),
        ],
      ),
    );
  }

  bool _hasLeapMonthDuplicate(int lunarYear, int monthAbs) {
    try {
      Lunar.fromYmd(lunarYear, -monthAbs, 1);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除提醒'),
        content: const Text('删除后无法恢复，确定删除吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('删除', style: TextStyle(color: JichenTokens.jiText)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ReminderStore.delete(widget.existing!.id);
    if (mounted) {
      Navigator.pop(context, (saved: false, notifyPending: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _kind == ReminderKind.event
        ? (widget.existing == null ? '新建计划' : '编辑计划')
        : (widget.existing == null ? '新建提醒' : '编辑提醒');
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          MediaQuery.paddingOf(context).bottom + 16,
        ),
        child: Column(
          children: [
            Container(
              width: 38,
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: JichenTokens.separator,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Row(
              children: [
                IconButton(
                  tooltip: '关闭',
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: JichenTokens.surface,
                    side: const BorderSide(color: JichenTokens.cardBorder),
                    fixedSize: const Size(40, 40),
                    minimumSize: const Size(40, 40),
                    padding: EdgeInsets.zero,
                  ),
                  icon: const Icon(Icons.close_rounded, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: context.jichenTitle2().copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    _buildFormFields(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<ReminderKind>(
          initialValue: _kind,
          decoration: InputDecoration(
            labelText: '类型',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: ReminderKind.values
              .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
              .toList(),
          onChanged: (v) {
            if (v == null) return;
            setState(() {
              _kind = v;
              if (widget.existing == null) {
                _repeat = v.defaultRepeat;
              }
              if (v == ReminderKind.birthday) {
                _lunarAnchor ??= LunarBirthdayAnchor.fromSolar(_date);
              } else {
                _lunarAnchor = null;
                _lunarPickerScheduled = false;
              }
              if (v != ReminderKind.birthday) _birthdayRelation = null;
              if (v != ReminderKind.anniversary) _anniversarySubtype = null;
              if (v != ReminderKind.countdown) _countdownTheme = 'time';
              _metaError = null;
            });
            if (v == ReminderKind.birthday) {
              _lunarPickerScheduled = false;
              _scheduleLunarBirthdayPickerIfNeeded();
            }
          },
        ),
        if (_metaError != null) ...[
          const SizedBox(height: 8),
          Text(
            _metaError!,
            style: context.jichenCaption(color: JichenTokens.jiText),
          ),
        ],
        if (_kind == ReminderKind.birthday) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _birthdayRelation,
            decoration: InputDecoration(
              labelText: '生日关系（必选）',
              errorText: _metaError != null && _birthdayRelation == null
                  ? '请选择'
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: ReminderPersonalMeta.birthdayRelations.entries
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (v) => setState(() {
              _birthdayRelation = v;
              _metaError = null;
            }),
          ),
        ],
        if (_kind == ReminderKind.anniversary) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _anniversarySubtype,
            decoration: InputDecoration(
              labelText: '纪念日类型（必选）',
              errorText: _metaError != null && _anniversarySubtype == null
                  ? '请选择'
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: ReminderPersonalMeta.anniversarySubtypes.entries
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (v) => setState(() {
              _anniversarySubtype = v;
              _metaError = null;
            }),
          ),
        ],
        if (_kind == ReminderKind.countdown) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _countdownTheme,
            decoration: InputDecoration(
              labelText: '倒数主题',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: ReminderPersonalMeta.countdownThemes.entries
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _countdownTheme = v);
            },
          ),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _titleCtrl,
          decoration: InputDecoration(
            labelText: '标题',
            errorText: _titleError,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) {
            if (_titleError != null) setState(() => _titleError = null);
          },
        ),
        const SizedBox(height: 12),
        if (_kind == ReminderKind.birthday) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('农历生日', style: context.jichenBody()),
            subtitle: Text(
              _lunarAnchor != null
                  ? '${_lunarAnchor!.label} · ${LunarBirthdayCalendar.solarCaption(_lunarAnchor!, DateTime.now())}'
                  : (_lunarError ?? '请选择农历月日'),
              style: context.jichenCaption(
                color: _lunarError != null ? JichenTokens.jiText : null,
              ),
            ),
            trailing: const Icon(Icons.calendar_month_outlined),
            onTap: () => _pickLunarBirthday(),
          ),
        ] else ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('日期（公历）', style: context.jichenBody()),
            subtitle: Text(
              '${_date.year}年${_date.month}月${_date.day}日 · ${lunarDisplayLabel(_date)}',
              style: context.jichenCaption(),
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
        ],
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('全天', style: context.jichenBody()),
          value: _allDay,
          activeThumbColor: JichenTokens.accent,
          onChanged: (value) => setState(() => _allDay = value),
        ),
        if (!_allDay)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('时间', style: context.jichenBody()),
            subtitle: Text(
              '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
              style: context.jichenCaption(),
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _time,
              );
              if (picked != null) setState(() => _time = picked);
            },
          ),
        Text('分类', style: context.jichenBody()),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children:
              const {
                'general': '通用',
                'work': '工作',
                'family': '家庭',
                'travel': '旅行',
                'custom': '自定义',
              }.entries.map((entry) {
                return ChoiceChip(
                  label: Text(entry.value),
                  selected: _category == entry.key,
                  onSelected: (_) => setState(() => _category = entry.key),
                );
              }).toList(),
        ),
        const SizedBox(height: 12),
        Text('提前提醒（可多选）', style: context.jichenBody()),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: kAdvanceMinuteOptions.entries.map((e) {
            final selected = _advanceSelected.contains(e.key);
            return FilterChip(
              label: Text(e.value, style: context.jichenCaption()),
              selected: selected,
              onSelected: (on) {
                setState(() {
                  if (on) {
                    _advanceSelected.add(e.key);
                  } else {
                    _advanceSelected.remove(e.key);
                  }
                  if (_advanceSelected.isEmpty) _advanceSelected.add(0);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<ReminderRepeatRule>(
          initialValue: _repeat,
          decoration: InputDecoration(
            labelText: '重复',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: ReminderRepeatRule.values
              .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _repeat = v);
          },
        ),
        if (_repeat == ReminderRepeatRule.yearlyLunar) ...[
          const SizedBox(height: 8),
          Text(
            '将按所选日期对应的农历月日每年重复；闰月规则遇当年无对应闰月时按常月计算。',
            style: context.jichenCaption(),
          ),
        ],
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('到时提醒', style: context.jichenBody()),
          subtitle: Text(
            '保存时将请求系统通知权限；拒绝仍可保存站内提醒',
            style: context.jichenCaption(),
          ),
          value: _notify,
          activeThumbColor: JichenTokens.accent,
          onChanged: (v) => setState(() => _notify = v),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteCtrl,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: '备注（可选）',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        if (_saveError != null) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  _saveError!,
                  style: context.jichenCaption(color: JichenTokens.jiText),
                ),
              ),
              TextButton(onPressed: _save, child: const Text('重试')),
            ],
          ),
          const SizedBox(height: 8),
        ],
        FilledButton(
          onPressed: _isSaving ? null : _save,
          style: FilledButton.styleFrom(
            backgroundColor: JichenTokens.accent,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: _isSaving
              ? const SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('保存'),
        ),
        if (widget.existing != null) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: _confirmDelete,
            child: Text('删除', style: TextStyle(color: JichenTokens.jiText)),
          ),
        ],
      ],
    );
  }
}

/// 通知权限引导：先请求，未授权则跳转系统设置。
Future<void> openNotificationSettingsHint(BuildContext context) async {
  var granted = await NotificationService.hasPermission();
  if (!granted && JichenPrefs.notifyMasterEnabled) {
    granted = await NotificationService.requestPermission();
  }
  if (!granted) {
    await openAppSettings();
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(granted ? '通知权限已开启' : '请在系统设置中开启通知；提醒已保存为站内可见')),
  );
}
