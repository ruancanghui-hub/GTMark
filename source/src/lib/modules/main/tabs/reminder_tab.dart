import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/content/poem_resolver.dart';
import '../../../core/date/day_info_service.dart';
import '../../../core/prefs/festival_reminder_prefs.dart';
import '../../../core/prefs/jichen_prefs.dart';
import '../../../core/reminder/personal_reminder.dart';
import '../../../core/reminder/reminder_advance.dart';
import '../../../core/reminder/reminder_kind.dart';
import '../../../core/reminder/reminder_repeat.dart';
import '../../../core/reminder/reminder_store.dart';
import '../../../shared/theme/jichen_tokens.dart';
import '../../../shared/ui/jichen_buttons.dart';
import '../../../shared/ui/jichen_header_stack_sheet.dart';
import '../../../shared/ui/jichen_section_title.dart';
import '../../../shared/ui/jichen_secondary_scaffold.dart';
import '../../reminder/reminder_editor_sheet.dart';
import '../../share/share_card_args.dart';
import '../../share/share_nav.dart';
import '../main_controller.dart';
import 'reminder/reminder_festival_row.dart';
import 'reminder/reminder_header.dart';

/// 提醒 Tab（LOOP-003）— 骨架稿排版。
class ReminderTab extends StatefulWidget {
  const ReminderTab({super.key, this.asSecondaryPage = false});

  final bool asSecondaryPage;

  @override
  State<ReminderTab> createState() => _ReminderTabState();
}

class _ReminderTabState extends State<ReminderTab> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ReminderStore.revision.value;
      JichenPrefs.prefsTick.value;
      return _buildBody(context);
    });
  }

  Widget _buildBody(BuildContext context) {
    final todayFestival = PoemResolver.resolveIdForDate(DateTime.now());
    final all = ReminderStore.loadAll().where((e) => !e.completed).toList();
    final today = all
        .where((e) => groupOfReminder(e) == ReminderGroup.today)
        .toList();
    final future = all
        .where((e) => groupOfReminder(e) == ReminderGroup.future)
        .toList();
    final past = all
        .where((e) => groupOfReminder(e) == ReminderGroup.past)
        .toList();
    final notifyPending = all.any((e) => e.notifyPending);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (notifyPending || !JichenPrefs.notifyMasterEnabled)
          _NotifyHint(onSettings: () => openNotificationSettingsHint(context)),
        _NewReminderButton(onPressed: () => showReminderEditorSheet(context)),
        const SizedBox(height: 16),
        if (all.isEmpty)
          _PersonalEmptyCard(
            onZeji: () => Get.find<MainController>().switchTab(1),
          )
        else ...[
          if (today.isNotEmpty) ...[
            Text('今天', style: context.jichenCaption()),
            const SizedBox(height: 8),
            ...today.map((r) => _ReminderTile(reminder: r)),
            const SizedBox(height: 12),
          ],
          if (future.isNotEmpty) ...[
            Text('未来', style: context.jichenCaption()),
            const SizedBox(height: 8),
            ...future.map((r) => _ReminderTile(reminder: r)),
            const SizedBox(height: 12),
          ],
          if (past.isNotEmpty) ...[
            Text('已过期', style: context.jichenCaption()),
            const SizedBox(height: 8),
            ...past.map((r) => _ReminderTile(reminder: r)),
          ],
        ],
        if (todayFestival != null) ...[
          const SizedBox(height: 16),
          _FestivalBanner(
            onTap: () => openSharePreview(context, ShareCardArgs.today()),
          ),
        ],
        const SizedBox(height: 20),
        const JichenSectionTitle(title: '节日提醒', subtitle: '（默认开启）'),
        const SizedBox(height: 12),
        ...FestivalReminderPrefs.entries.entries.map(
          (e) => ReminderFestivalRow(
            id: e.key,
            name: e.value,
            onChanged: (v) async {
              await FestivalReminderPrefs.setEnabled(e.key, v);
              if (mounted) setState(() {});
            },
          ),
        ),
        const SizedBox(height: 12),
        JichenOutlineButton(
          label: '去发祝福',
          expanded: true,
          height: 48,
          onPressed: () => Modular.to.pushNamed('${AppRoutes.main}blessing'),
        ),
      ],
    );

    if (widget.asSecondaryPage) {
      return JichenSecondaryScaffold(title: '提醒与纪念日', body: content);
    }

    return ColoredBox(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: JichenHeaderStackSheet(
              header: Stack(
                children: [
                  const ReminderHeader(),
                  if (widget.asSecondaryPage)
                    Positioned(
                      left: 12,
                      top: MediaQuery.paddingOf(context).top + 8,
                      child: IconButton.filledTonal(
                        tooltip: '返回',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                ],
              ),
              child: content,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _NewReminderButton extends StatelessWidget {
  const _NewReminderButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return JichenPrimaryButton(
      label: '新建提醒',
      height: 48,
      onPressed: onPressed,
      leading: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const HugeIcon(
          icon: HugeIcons.strokeRoundedAdd01,
          size: 14,
          color: JichenTokens.accent,
        ),
      ),
    );
  }
}

class _PersonalEmptyCard extends StatelessWidget {
  const _PersonalEmptyCard({required this.onZeji});

  final VoidCallback onZeji;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F5),
        borderRadius: BorderRadius.circular(JichenTokens.chipRadius),
        border: Border.all(color: JichenTokens.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: JichenTokens.iconCircleBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedNotification01,
                  size: 22,
                  color: JichenTokens.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('还没有个人提醒', style: context.jichenBody()),
                    const SizedBox(height: 4),
                    Text('从「择吉」推荐结果或上方按钮添加', style: context.jichenCaption()),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onZeji,
              style: TextButton.styleFrom(
                foregroundColor: JichenTokens.accent,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('去查吉日 >'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FestivalBanner extends StatelessWidget {
  const _FestivalBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JichenTokens.yiBg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedGift,
                size: 18,
                color: JichenTokens.yiText,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '今日有相关节日，可在「分享预览」生成祝福卡 >',
                  style: context.jichenBody(
                    color: JichenTokens.yiText,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotifyHint extends StatelessWidget {
  const _NotifyHint({required this.onSettings});

  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: JichenTokens.jiBg,
        borderRadius: BorderRadius.circular(JichenTokens.chipRadius),
        child: ListTile(
          dense: true,
          title: Text(
            '通知未完全开启',
            style: context.jichenBody(color: JichenTokens.jiText),
          ),
          subtitle: Text(
            '提醒已保存，可在「我的」打开通知总开关或授权系统通知',
            style: context.jichenCaption(),
          ),
          trailing: TextButton(onPressed: onSettings, child: const Text('去设置')),
        ),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder});

  final PersonalReminder reminder;

  Future<void> _postpone(BuildContext context, int days) async {
    final next = reminder.date.add(Duration(days: days));
    await ReminderStore.postpone(reminder, next);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已延期至 ${next.year}/${next.month}/${next.day}')),
      );
    }
  }

  Future<void> _pickPostponeDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: reminder.date.add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );
    if (picked == null) return;
    await ReminderStore.postpone(reminder, picked);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已延期')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = DayInfoService.build(reminder.date);
    final advance = advanceMinutesLabel(reminder.advanceMinutesList);
    final days = reminder.daysUntilNext(DateTime.now());
    final countdown = reminder.kind == ReminderKind.countdown
        ? ' · 还有 $days 天'
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(JichenTokens.chipRadius),
        border: Border.all(color: JichenTokens.cardBorder),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Text(
          '${reminder.kind.label} · ${reminder.title}',
          style: context.jichenBody(weight: FontWeight.w600),
        ),
        subtitle: Text(
          '${reminder.date.year}/${reminder.date.month}/${reminder.date.day} '
          '${reminder.hour.toString().padLeft(2, '0')}:${reminder.minute.toString().padLeft(2, '0')} · '
          '${info.lunarLabel}$countdown'
          '${reminder.repeatRule != ReminderRepeatRule.none ? ' · ${reminder.repeatRule.label}' : ''}'
          '${advance != '准时' ? ' · $advance' : ''}'
          '${reminder.notifyPending ? ' · 通知待开启' : ''}',
          style: context.jichenCaption(),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (v) async {
            switch (v) {
              case 'edit':
                await showReminderEditorSheet(context, existing: reminder);
              case 'complete':
                final snapshot = reminder;
                await ReminderStore.complete(reminder);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        reminder.repeatRule != ReminderRepeatRule.none
                            ? '已完成，已安排下次提醒'
                            : '已标记完成',
                      ),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                        label: '撤销',
                        onPressed: () async {
                          await ReminderStore.update(
                            snapshot.copyWith(completed: false),
                          );
                        },
                      ),
                    ),
                  );
                }
              case 'postpone1':
                await _postpone(context, 1);
              case 'postpone3':
                await _postpone(context, 3);
              case 'postpone7':
                await _postpone(context, 7);
              case 'postponePick':
                await _pickPostponeDate(context);
              case 'share':
                if (reminder.isAnniversaryKind) {
                  openSharePreview(
                    context,
                    ShareCardArgs.fromReminder(reminder),
                  );
                }
            }
          },
          itemBuilder: (ctx) => [
            const PopupMenuItem(value: 'edit', child: Text('编辑')),
            if (reminder.isAnniversaryKind)
              const PopupMenuItem(value: 'share', child: Text('分享卡片')),
            const PopupMenuItem(value: 'complete', child: Text('标记完成')),
            const PopupMenuItem(value: 'postpone1', child: Text('延期 1 天')),
            const PopupMenuItem(value: 'postpone3', child: Text('延期 3 天')),
            const PopupMenuItem(value: 'postpone7', child: Text('延期 1 周')),
            const PopupMenuItem(value: 'postponePick', child: Text('选择延期日期…')),
          ],
        ),
        onTap: () => showReminderEditorSheet(context, existing: reminder),
      ),
    );
  }
}
