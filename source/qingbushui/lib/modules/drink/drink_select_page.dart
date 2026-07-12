import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/qing_theme.dart';
import '../../core/hydration/drink_catalog.dart';
import '../../shared/assets/qw_assets.dart';
import '../../shared/widgets/qw_asset_icon.dart';
import '../../shared/widgets/qw_glass_chip.dart';
import '../../shared/widgets/qw_screen_shell.dart';

class DrinkSelectPage extends StatelessWidget {
  const DrinkSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final presets = DrinkCatalog.all();
    final water = presets.where((p) => p.section == 'WATER').toList();
    final other = presets.where((p) => p.section == 'OTHER').toList();

    return Scaffold(
      body: QwScreenShell(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: _Header(onBack: () => Modular.to.pop()),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                children: [
                  const _HeroCard(),
                  const SizedBox(height: 22),
                  _section('Water', water),
                  const SizedBox(height: 26),
                  _section('Other drinks', other),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<DrinkPreset> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: QwColors.ink,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),
            QwGlassChip(
              asset: title == 'Water'
                  ? QwAssets.drinkWaterGlass
                  : QwAssets.drinkCoffee,
              label: '${items.length} choices',
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.76,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) => _drinkItem(items[i]),
        ),
      ],
    );
  }

  Widget _drinkItem(DrinkPreset preset) {
    return Builder(
      builder: (context) {
        final color = Color(preset.fillColor);
        final asset = QwAssets.drinkIconFor(preset.type, label: preset.label);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Modular.to.pushNamed(
              '/drink/slide',
              arguments: {
                'type': preset.type.index,
                'oz': preset.defaultOz,
                'label': preset.label,
              },
            ),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: QwColors.primaryDeep.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 64,
                    width: 64,
                    child: asset == null
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  color.withValues(alpha: 0.16),
                                  color.withValues(alpha: 0.34),
                                ],
                              ),
                            ),
                            child: Icon(
                              IconData(
                                preset.icon,
                                fontFamily: 'MaterialIcons',
                              ),
                              color: color,
                              size: 29,
                            ),
                          )
                        : QwAssetIcon(
                            asset: asset,
                            label: '${preset.label} crystal drink icon',
                            size: 64,
                          ),
                  ),
                  const SizedBox(height: 9),
                  Expanded(
                    child: Center(
                      child: Text(
                        preset.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: QwColors.ink,
                          fontSize: 12,
                          height: 1.08,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${preset.defaultOz.toStringAsFixed(0)} oz',
                    style: const TextStyle(
                      color: QwColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.36),
          shape: const CircleBorder(),
          child: IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Choose your sip',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: QwGradients.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: QwColors.primaryDeep.withValues(alpha: 0.18),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Build your cup',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pick a drink, then slide to tune the exact amount.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 8 * (1 - value)),
                child: Opacity(opacity: value.clamp(0, 1), child: child),
              );
            },
            child: const QwAssetIcon(
              asset: QwAssets.drinkSelectHero,
              label: 'Build your cup crystal illustration',
              size: 132,
            ),
          ),
        ],
      ),
    );
  }
}
