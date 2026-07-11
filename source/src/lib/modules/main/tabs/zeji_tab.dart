import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/prefs/jichen_prefs.dart';
import '../../../shared/theme/jichen_tokens.dart';
import '../../zeji/zeji_result_panel.dart';
import '../zeji_controller.dart';
import 'zeji/zeji_form_card.dart';
import 'zeji/zeji_header.dart';

/// 择吉 Tab（LOOP-002）— 品牌 IP 白底择日页。
class ZejiTab extends GetView<ZejiController> {
  const ZejiTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = JichenPrefs.prefsTick.value;
      final loading = controller.loading.value;
      final result = controller.lastResult.value;
      final searched = controller.hasSearched.value;
      final err = controller.errorMessage.value;
      final showResults = searched && result != null && !loading;

      return ColoredBox(
        color: const Color(0xFFFAFAFA),
        child: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  const ZejiHeader(),
                  ZejiFormCard(
                    matterIds: controller.matterIds.toList(),
                    isMatterSelected: controller.isMatterSelected,
                    matterDescription: controller.matterDescription,
                    rangePreset: controller.rangePreset.value,
                    customStart: controller.customStart.value,
                    customEnd: controller.customEnd.value,
                    weekendOnly: controller.weekendOnly.value,
                    loading: loading,
                    onSelectMatter: controller.toggleMatter,
                    onSelectRange: controller.selectRange,
                    onToggleWeekendOnly: controller.setWeekendOnly,
                    onPickStart: (d) {
                      controller.customStart.value = d;
                      if (controller.customEnd.value.isBefore(d)) {
                        controller.customEnd.value = d;
                      }
                    },
                    onPickEnd: (d) {
                      controller.customEnd.value =
                          d.isBefore(controller.customStart.value)
                          ? controller.customStart.value
                          : d;
                    },
                    onSearch: () => controller.search(),
                  ),
                  if (err != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      err,
                      style: context.jichenCaption(color: JichenTokens.jiText),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => controller.search(),
                        child: const Text('重试'),
                      ),
                    ),
                  ],
                  if (showResults) ...[
                    const SizedBox(height: 8),
                    const Divider(height: 24, color: JichenTokens.cardBorder),
                    ZejiResultPanel(
                      result: result,
                      matterName: controller.matterResultLabel,
                      matter: controller.matter,
                      onExpandRange: () => controller.expandRange(),
                      onSwitchGeneric: () => controller.switchToGeneric(),
                      onRetry: () => controller.search(),
                      onIgnoreWeather: () => controller.retryIgnoreWeather(),
                      onAddReminder: (rec) => showZejiAddReminderSheet(
                        context,
                        rec: rec,
                        matter: controller.matter,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (loading) const _ZejiLoadingOverlay(),
          ],
        ),
      );
    });
  }
}

class _ZejiLoadingOverlay extends StatelessWidget {
  const _ZejiLoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.18),
        child: Center(
          child: Semantics(
            label: '正在择吉',
            liveRegion: true,
            child: Container(
              width: 168,
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: JichenTokens.accent,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '正在择吉',
                    style: context.jichenBody(weight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '吉辰正在筛选好日子',
                    textAlign: TextAlign.center,
                    style: context.jichenCaption(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
