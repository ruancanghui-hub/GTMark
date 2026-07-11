import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/content/content_repository.dart';
import '../../../core/prefs/jichen_prefs.dart';
import '../../../core/reminder/reminder_store.dart';
import '../../../shared/theme/jichen_tokens.dart';
import '../../../shared/ui/jichen_grouped_card.dart';
import '../../../widgets/weather_city_picker.dart';
import '../../legal/legal_documents_pages.dart';
import '../../share/share_nav.dart';
import 'mine/mine_setting_tile.dart';
import 'reminder_tab.dart';

/// 我的 Tab — 1:1 对齐品牌 IP 目标图。
class MineTab extends StatefulWidget {
  const MineTab({super.key});

  @override
  State<MineTab> createState() => _MineTabState();
}

class _MineTabState extends State<MineTab> {
  static const _cultureDisclaimer = '''
吉辰万年历中的农历、节气、黄历宜忌、节日诗句等内容，整理自中国传统历法与公共文化典籍，仅供生活参考与民俗了解，不构成专业择日、风水或宗教建议。

具体事项请以个人实际情况与当地习俗为准；涉及祭扫、医疗、法律等重大决策，请咨询专业人士。
''';

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      JichenPrefs.prefsTick.value;
      return _buildBody(context);
    });
  }

  Widget _buildBody(BuildContext context) {
    final repo = ContentRepository.instance;
    final pendingReminderCount = ReminderStore.loadAll()
        .where((item) => !item.completed)
        .length;
    return ColoredBox(
      color: const Color(0xFFFAFAFA),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                Text(
                  '我的',
                  style: context.jichenTitle2().copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: '设置',
                  onPressed: () => _showSettingsSheet(context),
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedSettings02,
                    size: 24,
                    color: JichenTokens.labelPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const _MineProfileCard(),
            const SizedBox(height: 24),
            JichenGroupedCard(
              children: [
                MineSettingTile(
                  inGroup: true,
                  icon: HugeIcons.strokeRoundedNotification01,
                  title: '提醒与纪念日',
                  trailing: pendingReminderCount > 0
                      ? _Badge(count: pendingReminderCount)
                      : null,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ReminderTab(asSecondaryPage: true),
                    ),
                  ),
                ),
                MineSettingTile(
                  inGroup: true,
                  icon: HugeIcons.strokeRoundedCloud,
                  title: '数据备份',
                  onTap: () => Modular.to.pushNamed('${AppRoutes.main}backup'),
                ),
                MineSettingTile(
                  inGroup: true,
                  icon: HugeIcons.strokeRoundedGift,
                  title: '发祝福',
                  onTap: () =>
                      Modular.to.pushNamed('${AppRoutes.main}blessing'),
                ),
                MineSettingTile(
                  inGroup: true,
                  icon: HugeIcons.strokeRoundedSettings02,
                  title: '设置',
                  onTap: () => _showSettingsSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                '离线内容：${repo.poemCount} 条诗句 · ${repo.blessingCount} 条祝福',
                style: context.jichenCaption(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            SwitchListTile(
              value: JichenPrefs.notifyMasterEnabled,
              title: const Text('通知总开关'),
              onChanged: (v) async {
                await JichenPrefs.setNotifyMasterEnabled(v);
                if (mounted) setState(() {});
              },
            ),
            ListTile(
              title: const Text('天气城市'),
              subtitle: Text(JichenPrefs.weatherCityName),
              onTap: () async {
                Navigator.pop(ctx);
                final picked = await showWeatherCityPicker(context);
                if (picked != null && mounted) setState(() {});
              },
            ),
            ListTile(
              title: const Text('小年习俗'),
              subtitle: Text(JichenPrefs.xiaonianRegion.label),
              onTap: () {
                Navigator.pop(ctx);
                _pickXiaonianRegion(context);
              },
            ),
            ListTile(
              title: const Text('分享预览'),
              onTap: () {
                Navigator.pop(ctx);
                openSharePreview(context);
              },
            ),
            ListTile(
              title: const Text('发祝福'),
              onTap: () {
                Navigator.pop(ctx);
                Modular.to.pushNamed('${AppRoutes.main}blessing');
              },
            ),
            ListTile(
              title: const Text('隐私政策'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PrivacyPolicyPage(),
                ),
              ),
            ),
            ListTile(
              title: const Text('用户协议'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const TermsOfServicePage(),
                ),
              ),
            ),
            ListTile(
              title: const Text('关于 · 传统文化参考'),
              onTap: () => showDialog<void>(
                context: context,
                builder: (dialogCtx) => AlertDialog(
                  title: Text('传统文化参考说明', style: context.jichenTitle3()),
                  content: SingleChildScrollView(
                    child: Text(
                      _cultureDisclaimer,
                      style: context.jichenBody(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx),
                      child: const Text('知道了'),
                    ),
                  ],
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickXiaonianRegion(BuildContext context) async {
    final picked = await showModalBottomSheet<XiaonianRegion>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final r in XiaonianRegion.values)
              ListTile(
                title: Text(r.label),
                trailing: JichenPrefs.xiaonianRegion == r
                    ? Icon(Icons.check, color: JichenTokens.accent)
                    : null,
                onTap: () => Navigator.pop(ctx, r),
              ),
          ],
        ),
      ),
    );
    if (picked != null) {
      await JichenPrefs.setXiaonianRegion(picked);
      if (mounted) setState(() {});
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('已设为：${picked.label}')));
      }
    }
  }
}

class _MineProfileCard extends StatelessWidget {
  const _MineProfileCard();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 82,
          height: 82,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: JichenTokens.cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/brand/ip_deer.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '吉辰万年历',
                style: context.jichenTitle3().copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text('陪你规划每一天', style: context.jichenCaption()),
            ],
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 18),
          height: 18,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: JichenTokens.accent,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const HugeIcon(
          icon: HugeIcons.strokeRoundedArrowRight01,
          size: 18,
          color: JichenTokens.labelSecondary,
        ),
      ],
    );
  }
}
