import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/qing_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/insight_articles.dart';
import '../../shared/assets/qw_assets.dart';
import '../../shared/widgets/qw_asset_icon.dart';
import '../../shared/widgets/qw_bottom_nav.dart';
import '../../shared/widgets/qw_screen_shell.dart';

class InsightsTab extends StatelessWidget {
  const InsightsTab({super.key, required this.onNavTap});

  final ValueChanged<int> onNavTap;

  static const _sections = [
    (
      InsightSection.waterDrinking,
      QwAssets.insightWaterBalance,
      [
        InsightArticle.avoidMistakes,
        InsightArticle.bestTimes,
        InsightArticle.replaceBeverages,
      ],
    ),
    (
      InsightSection.beautySkincare,
      QwAssets.insightSkinHydration,
      [
        InsightArticle.skinBenefits,
        InsightArticle.wrinkleSchedule,
        InsightArticle.glowingSkin,
      ],
    ),
    (
      InsightSection.selfCare,
      QwAssets.insightSelfCare,
      [
        InsightArticle.sleepHydration,
        InsightArticle.alcoholBalance,
        InsightArticle.dailyRitual,
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: QwScreenShell(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                l10n.insights,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: _sections.length,
                itemBuilder: (context, i) {
                  final (section, asset, cards) = _sections[i];
                  final title = l10n.insightSectionTitle(section);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 172,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: cards.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, j) => _insightCard(
                              context,
                              cards[j],
                              asset,
                              j,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            QwBottomNav(
              index: 2,
              onTap: onNavTap,
              onAdd: () => Modular.to.pushNamed('/drink/select'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _insightCard(
    BuildContext context,
    InsightArticle article,
    String asset,
    int index,
  ) {
    final l10n = AppLocalizations.of(context);
    final title = l10n.insightArticleTitle(article);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _openInsight(context, article, asset),
        child: Ink(
          width: 176,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
            boxShadow: [
              BoxShadow(
                color: QwColors.primaryDeep.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        QwColors.skyMid.withValues(alpha: 0.28),
                        Colors.white.withValues(alpha: 0.82),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment(0, index == 1 ? -0.08 : 0.04),
                    child: QwAssetIcon(
                      asset: asset,
                      label: '$title illustration',
                      size: index == 1 ? 118 : 126,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openInsight(
    BuildContext context,
    InsightArticle article,
    String asset,
  ) {
    final l10n = AppLocalizations.of(context);
    final title = l10n.insightArticleTitle(article);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
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
                Center(
                  child: QwAssetIcon(asset: asset, label: title, size: 118),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: QwColors.ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.insightArticleBody(article),
                  style: const TextStyle(
                    color: QwColors.muted,
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: QwColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(l10n.gotIt),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
