import 'package:flutter/material.dart';

import '../../app/qing_theme.dart';
import '../assets/qw_assets.dart';

class QwWaterBottleHero extends StatelessWidget {
  const QwWaterBottleHero({
    super.key,
    required this.progress,
    this.size = 220,
    this.showFace = true,
  });

  final double progress;
  final double size;
  final bool showFace;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        final imageWidth = size * (showFace ? 0.72 : 0.68);
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: size * 0.02,
                child: Container(
                  width: size * 0.58,
                  height: size * 0.12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: QwColors.primaryDeep.withValues(alpha: 0.18),
                        blurRadius: 26,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 850),
                curve: Curves.easeOutCubic,
                offset: Offset(0, -0.02 * value),
                child: Image.asset(
                  QwAssets.homeHeroBottle,
                  width: imageWidth,
                  height: size * 1.02,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Positioned(
                left: size * 0.12,
                top: size * (0.2 + 0.08 * (1 - value)),
                child: _Bubble(size: size * 0.055, opacity: 0.42),
              ),
              Positioned(
                right: size * 0.1,
                top: size * (0.36 - 0.06 * value),
                child: _Bubble(size: size * 0.042, opacity: 0.36),
              ),
              Positioned(
                right: size * 0.18,
                bottom: size * (0.2 + 0.08 * value),
                child: _Bubble(size: size * 0.03, opacity: 0.3),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withValues(alpha: opacity + 0.22),
            QwColors.aqua.withValues(alpha: opacity),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.62)),
      ),
    );
  }
}
