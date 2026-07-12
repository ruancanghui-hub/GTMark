import 'package:flutter/material.dart';

import '../../app/qing_theme.dart';
import '../assets/qw_assets.dart';
import 'qw_asset_icon.dart';

class SlideToDrink extends StatefulWidget {
  const SlideToDrink({
    super.key,
    required this.oz,
    required this.minOz,
    required this.maxOz,
    required this.onChanged,
  });

  final double oz;
  final double minOz;
  final double maxOz;
  final ValueChanged<double> onChanged;

  @override
  State<SlideToDrink> createState() => _SlideToDrinkState();
}

class _SlideToDrinkState extends State<SlideToDrink> {
  late double _fill;

  @override
  void initState() {
    super.initState();
    _fill = _ozToFill(widget.oz);
  }

  @override
  void didUpdateWidget(covariant SlideToDrink oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.oz != widget.oz) _fill = _ozToFill(widget.oz);
  }

  double _ozToFill(double oz) =>
      ((oz - widget.minOz) / (widget.maxOz - widget.minOz)).clamp(0.0, 1.0);

  double _fillToOz(double fill) =>
      widget.minOz + fill * (widget.maxOz - widget.minOz);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final handleY = h * (1 - _fill);
        return GestureDetector(
          onVerticalDragUpdate: (d) {
            setState(() {
              _fill = (_fill - d.delta.dy / h).clamp(0.0, 1.0);
              widget.onChanged(_fillToOz(_fill));
            });
          },
          child: SizedBox(
            width: constraints.maxWidth,
            height: h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 220),
                    opacity: 0.82 + _fill * 0.18,
                    child: const FittedBox(
                      fit: BoxFit.contain,
                      child: QwAssetIcon(
                        asset: QwAssets.slideTallGlass,
                        label: 'Amount measuring glass',
                        size: 310,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(painter: _FillGlowPainter(fill: _fill)),
                ),
                Positioned(
                  left: constraints.maxWidth / 2 - 28,
                  top: handleY - 28,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: QwGradients.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: QwColors.primaryDeep.withValues(alpha: 0.28),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(7),
                      child: QwAssetIcon(
                        asset: QwAssets.sliderHandle,
                        label: 'Adjust amount',
                        size: 42,
                      ),
                    ),
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

class _FillGlowPainter extends CustomPainter {
  _FillGlowPainter({required this.fill});

  final double fill;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * (1 - fill));
    final radius = size.width * (0.16 + fill * 0.08);
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          QwColors.aqua.withValues(alpha: 0.3),
          QwColors.primary.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 2.2))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawCircle(center, radius, glow);
  }

  @override
  bool shouldRepaint(covariant _FillGlowPainter old) => old.fill != fill;
}
