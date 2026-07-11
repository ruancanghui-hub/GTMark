import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/qing_theme.dart';
import '../../shared/assets/qw_assets.dart';
import '../../shared/widgets/qw_asset_icon.dart';
import '../../shared/widgets/qw_bottom_nav.dart';
import '../../shared/widgets/qw_screen_shell.dart';

class InsightsTab extends StatelessWidget {
  const InsightsTab({super.key, required this.onNavTap});

  final ValueChanged<int> onNavTap;

  static const _sections = [
    (
      'Water Drinking',
      QwAssets.insightWaterBalance,
      [
        'Avoid These Water Drinking Mistakes',
        'Best Times to Drink Water',
        'Replace Beverages with Water',
      ],
    ),
    (
      'Beauty & Skincare',
      QwAssets.insightSkinHydration,
      [
        'Benefits of Drinking Water for Skin',
        'Drinking Schedule for Wrinkle-Free Skin',
        'Miracle Glowing Skin',
      ],
    ),
    (
      'Self-care',
      QwAssets.insightSelfCare,
      [
        'Sleep and Hydration',
        'Alcohol vs Water Balance',
        'Daily Hydration Ritual',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QwScreenShell(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'INSIGHTS',
                style: TextStyle(
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
                  final (title, asset, cards) = _sections[i];
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
                            itemBuilder: (_, j) =>
                                _insightCard(cards[j], asset, j),
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

  Widget _insightCard(String title, String asset, int index) {
    return Container(
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
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
