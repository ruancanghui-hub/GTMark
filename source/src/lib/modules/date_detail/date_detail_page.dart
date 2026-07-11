import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/routes/app_routes.dart';
import '../../core/content/content_repository.dart';
import '../../core/content/poem_resolver.dart';
import '../../core/date/day_info.dart';
import '../../core/date/day_info_service.dart';
import '../../core/date/holiday_mark.dart';
import '../../core/date/huangli_plain.dart';
import '../../core/prefs/date_favorites.dart';
import '../../core/reminder/personal_reminder.dart';
import '../../core/reminder/reminder_kind.dart';
import '../../core/reminder/reminder_repeat.dart';
import '../../core/reminder/reminder_store.dart';
import '../../shared/theme/jichen_tokens.dart';
import '../../shared/ui/jichen_secondary_scaffold.dart';
import '../../widgets/date_detail_weather_section.dart';
import '../../widgets/feedback_sheet.dart';
import '../reminder/reminder_editor_sheet.dart';
import '../main/main_controller.dart';
import '../main/tabs/today/dated_plan_section.dart';
import '../share/share_card_args.dart';
import '../share/share_nav.dart';

typedef PlanEditorLauncher =
    Future<({bool saved, bool notifyPending})?> Function(
      BuildContext context, {
      PersonalReminder? existing,
      PersonalReminder? initial,
    });

typedef NotificationSettingsLauncher =
    Future<void> Function(BuildContext context);

/// 日期详情页（LOOP-001）。
class DateDetailPage extends StatefulWidget {
  const DateDetailPage({
    super.key,
    required this.date,
    this.openPlanEditor,
    this.openNotificationSettings,
  });

  final DateTime date;
  final PlanEditorLauncher? openPlanEditor;
  final NotificationSettingsLauncher? openNotificationSettings;

  @override
  State<DateDetailPage> createState() => _DateDetailPageState();
}

class _DateDetailPageState extends State<DateDetailPage> {
  late DateTime _date;
  int _revision = 0;
  bool _favorite = false;

  @override
  void initState() {
    super.initState();
    _date = DateTime(widget.date.year, widget.date.month, widget.date.day);
    _favorite = DateFavorites.isFavorite(_date);
  }

  DayInfo get _info => DayInfoService.build(_date);

  Future<void> _refresh() async {
    setState(() => _revision++);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已刷新黄历数据')));
    }
  }

  Future<void> _toggleFavorite() async {
    final nowFav = await DateFavorites.toggle(_date);
    setState(() => _favorite = nowFav);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(nowFav ? '已收藏该日期' : '已取消收藏')));
    }
  }

  void _goZeji() {
    Modular.to.pop();
    Get.find<MainController>().switchTab(1);
  }

  Future<void> _openPlanEditor({PersonalReminder? existing}) async {
    final result = await (widget.openPlanEditor ?? showReminderEditorSheet)(
      context,
      existing: existing,
      initial: existing == null
          ? PersonalReminder(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              title: '',
              date: _date,
              notifyEnabled: true,
              source: 'date_detail',
            )
          : null,
    );
    if (!mounted || result == null) return;
    setState(() => _revision++);
    final notifyPending = result.notifyPending;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          !result.saved
              ? '计划已删除'
              : notifyPending
              ? '计划已保存；通知未开启时仅站内可见'
              : '计划已保存',
        ),
        action: notifyPending
            ? SnackBarAction(
                label: '去设置',
                onPressed: () =>
                    (widget.openNotificationSettings ??
                    openNotificationSettingsHint)(context),
              )
            : null,
      ),
    );
  }

  Future<void> _completePlan(PersonalReminder plan) async {
    await ReminderStore.complete(plan);
    if (!mounted) return;
    setState(() => _revision++);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(plan.completed ? '计划已恢复' : '计划已完成')));
  }

  Future<void> _goSetAnniversary() async {
    final result = await showReminderEditorSheet(
      context,
      initial: PersonalReminder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '纪念日',
        date: _date,
        source: 'date_detail',
        kind: ReminderKind.anniversary,
        repeatRule: ReminderRepeatRule.yearlySolar,
      ),
    );
    if (!mounted) return;
    if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('纪念日已保存')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable — 触发 _revision 重建
    final _ = _revision;
    final info = _info;
    final poem = info.festivalId != null
        ? ContentRepository.instance.poemBundle(info.festivalId!)
        : PoemResolver.resolveForDate(_date);
    final defaultPoem = poem?.defaultPoem;
    final plans = ReminderStore.plansOn(_date);

    return JichenSecondaryScaffold(
      title: DateFormat('yyyy年M月d日').format(info.date),
      actions: [
        IconButton(
          tooltip: _favorite ? '取消收藏' : '收藏日期',
          onPressed: _toggleFavorite,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: JichenTokens.labelPrimary,
            side: const BorderSide(color: JichenTokens.cardBorder),
            fixedSize: const Size(38, 38),
            minimumSize: const Size(38, 38),
            padding: EdgeInsets.zero,
          ),
          icon: Icon(
            _favorite ? Icons.star : Icons.star_border,
            color: _favorite ? JichenTokens.accent : null,
          ),
        ),
      ],
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeaderCard(info: info),
          const SizedBox(height: 12),
          _HolidaySection(info: info),
          const SizedBox(height: 12),
          DateDetailWeatherSection(date: _date),
          const SizedBox(height: 12),
          DatedPlanSection(
            date: _date,
            plans: plans,
            onAdd: _openPlanEditor,
            onEdit: (plan) => _openPlanEditor(existing: plan),
            onComplete: _completePlan,
          ),
          const SizedBox(height: 12),
          _HuangliSection(
            info: info,
            onRefresh: _refresh,
            onFeedback: () => showFeedbackSheet(
              context,
              preset: '黄历数据异常：${DateFormat('yyyy-MM-dd').format(_date)}',
            ),
          ),
          if (defaultPoem != null) ...[
            const SizedBox(height: 12),
            _PoemSection(
              text: defaultPoem.text,
              author: defaultPoem.author,
              source: defaultPoem.source,
            ),
          ],
          const SizedBox(height: 20),
          _NextStepRow(onZeji: _goZeji, onAnniversary: _goSetAnniversary),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => openSharePreview(
                    context,
                    ShareCardArgs.dateDetail(_date),
                  ),
                  child: const Text('分享'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      Modular.to.pushNamed('${AppRoutes.main}blessing'),
                  style: FilledButton.styleFrom(
                    backgroundColor: JichenTokens.accent,
                  ),
                  child: const Text('发祝福'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.info});

  final DayInfo info;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '日期',
      source: DayInfoService.huangliSourceCaption(info.date),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${info.date.day}', style: context.jichenDisplay()),
          Text(
            '${info.lunarLabel} · ${info.weekdayLabel}',
            style: context.jichenBody(color: JichenTokens.labelSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            '生肖 ${info.shengXiao} · 干支 ${info.ganZhiDay}',
            style: context.jichenCaption(),
          ),
          if (info.jieQi != null) ...[
            const SizedBox(height: 8),
            Text('节气 ${info.jieQi}', style: context.jichenBody()),
          ],
          if (info.festivalName != null) ...[
            const SizedBox(height: 4),
            Text(
              info.festivalName!,
              style: context.jichenBody(weight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}

class _HolidaySection extends StatelessWidget {
  const _HolidaySection({required this.info});

  final DayInfo info;

  @override
  Widget build(BuildContext context) {
    final mark = info.holidayMark;
    return _SectionCard(
      title: '节假日',
      source: DayInfoService.holidaySourceCaption(),
      child: mark.hasMark
          ? Row(
              children: [
                _HolidayBadge(kind: mark.kind, label: mark.shortLabel ?? ''),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    mark.kind == HolidayMarkKind.workAdjust
                        ? '调休上班日，安排行程请注意'
                        : '法定休息日',
                    style: context.jichenBody(),
                  ),
                ),
              ],
            )
          : Text(
              info.festivalName != null
                  ? '今日有传统节日：${info.festivalName}'
                  : '非法定节假日调休日',
              style: context.jichenBody(color: JichenTokens.labelSecondary),
            ),
    );
  }
}

class _HolidayBadge extends StatelessWidget {
  const _HolidayBadge({required this.kind, required this.label});

  final HolidayMarkKind kind;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = kind == HolidayMarkKind.workAdjust
        ? JichenTokens.workdayAdjust
        : JichenTokens.restMark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: context.jichenCaption(color: color)),
    );
  }
}

class _HuangliSection extends StatelessWidget {
  const _HuangliSection({
    required this.info,
    required this.onRefresh,
    required this.onFeedback,
  });

  final DayInfo info;
  final VoidCallback onRefresh;
  final VoidCallback onFeedback;

  @override
  Widget build(BuildContext context) {
    if (!info.hasHuangli) {
      return _SectionCard(
        title: '黄历',
        source: DayInfoService.huangliSourceCaption(info.date),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '基础日历可用，黄历数据待更新',
              style: context.jichenBody(color: JichenTokens.labelSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton(onPressed: onRefresh, child: const Text('刷新')),
                const SizedBox(width: 12),
                TextButton(onPressed: onFeedback, child: const Text('反馈问题')),
              ],
            ),
          ],
        ),
      );
    }

    return _SectionCard(
      title: '黄历',
      source: DayInfoService.huangliSourceCaption(info.date),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('宜', style: context.jichenCaption(color: JichenTokens.yiText)),
          const SizedBox(height: 4),
          Text(info.yiSummary, style: context.jichenBody()),
          const SizedBox(height: 4),
          Text(info.plainYi, style: context.jichenCaption()),
          const SizedBox(height: 12),
          Text('忌', style: context.jichenCaption(color: JichenTokens.jiText)),
          const SizedBox(height: 4),
          Text(info.jiSummary, style: context.jichenBody()),
          const SizedBox(height: 4),
          Text(info.plainJi, style: context.jichenCaption()),
          const SizedBox(height: 12),
          Text(
            HuangliPlain.chongExplanation(info.chongDesc),
            style: context.jichenBody(),
          ),
          const SizedBox(height: 8),
          Text(
            HuangliPlain.positionExplanation(
              xi: info.positionXi,
              cai: info.positionCai,
            ),
            style: context.jichenBody(),
          ),
          const SizedBox(height: 8),
          Text('传统文化参考，不构成专业择日、风水或宗教建议。', style: context.jichenCaption()),
        ],
      ),
    );
  }
}

class _PoemSection extends StatelessWidget {
  const _PoemSection({required this.text, required this.author, this.source});

  final String text;
  final String author;
  final String? source;

  @override
  Widget build(BuildContext context) {
    final src = source != null ? '《$source》' : '';
    return _SectionCard(
      title: '诗句',
      source: '离线诗句库 · 本地',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: context.jichenBody()),
          const SizedBox(height: 8),
          Text('—— $author$src', style: context.jichenCaption()),
        ],
      ),
    );
  }
}

class _NextStepRow extends StatelessWidget {
  const _NextStepRow({required this.onZeji, required this.onAnniversary});

  final VoidCallback onZeji;
  final VoidCallback onAnniversary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: onZeji,
            style: FilledButton.styleFrom(backgroundColor: JichenTokens.accent),
            child: const Text('查吉日'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: onAnniversary,
            child: const Text('设为纪念日'),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.source,
    required this.child,
  });

  final String title;
  final String source;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: JichenTokens.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.jichenTitle3()),
          const SizedBox(height: 8),
          child,
          const SizedBox(height: 8),
          Text(source, style: context.jichenCaption()),
        ],
      ),
    );
  }
}
