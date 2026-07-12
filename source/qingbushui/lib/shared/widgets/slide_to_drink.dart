import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/qing_theme.dart';
import '../../l10n/app_localizations.dart';

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
  static const _majorTicks = [32.0, 24.0, 16.0, 8.0, 1.0];

  double get _fill {
    return ((widget.oz - widget.minOz) / (widget.maxOz - widget.minOz)).clamp(
      0.0,
      1.0,
    );
  }

  double _dyToOz(double dy, double height) {
    final fill = (1 - dy / height).clamp(0.0, 1.0);
    return widget.minOz + fill * (widget.maxOz - widget.minOz);
  }

  void _updateFromLocalDy(double dy, double height) {
    widget.onChanged(_dyToOz(dy, height).roundToDouble());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final glassWidth = math.min(constraints.maxWidth * 0.58, 220.0);
        final rulerWidth = math.min(constraints.maxWidth * 0.34, 118.0);
        final handleY = height * (1 - _fill);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: glassWidth,
              height: height,
              child: CustomPaint(painter: _CrystalGlassPainter(fill: _fill)),
            ),
            const SizedBox(width: 18),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) =>
                  _updateFromLocalDy(details.localPosition.dy, height),
              onVerticalDragUpdate: (details) =>
                  _updateFromLocalDy(details.localPosition.dy, height),
              child: SizedBox(
                width: rulerWidth,
                height: height,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _AmountRulerPainter(
                          fill: _fill,
                          minOz: widget.minOz,
                          maxOz: widget.maxOz,
                        ),
                      ),
                    ),
                    for (final tick in _majorTicks)
                      _TickLabel(
                        value: tick,
                        minOz: widget.minOz,
                        maxOz: widget.maxOz,
                        height: height,
                      ),
                    Positioned(
                      left: 0,
                      right: 20,
                      top: (handleY - 22).clamp(0, height - 44),
                      child: Semantics(
                        label: l10n.tuneAmount,
                        container: true,
                        explicitChildNodes: false,
                        slider: true,
                        value: '${widget.oz.round()} oz',
                        child: Container(
                          key: const ValueKey('amount-ruler-handle'),
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: QwGradients.primary,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: QwColors.primaryDeep.withValues(
                                  alpha: 0.24,
                                ),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.unfold_more_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.oz.round()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TickLabel extends StatelessWidget {
  const _TickLabel({
    required this.value,
    required this.minOz,
    required this.maxOz,
    required this.height,
  });

  final double value;
  final double minOz;
  final double maxOz;
  final double height;

  @override
  Widget build(BuildContext context) {
    final fill = ((value - minOz) / (maxOz - minOz)).clamp(0.0, 1.0);
    final top = (height * (1 - fill) - 9).clamp(0.0, height - 18);
    final label = value == minOz ? '${value.round()} oz' : '${value.round()}';

    return Positioned(
      right: 0,
      top: top,
      child: Text(
        label,
        style: const TextStyle(
          color: QwColors.primaryDeep,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CrystalGlassPainter extends CustomPainter {
  const _CrystalGlassPainter({required this.fill});

  final double fill;

  @override
  void paint(Canvas canvas, Size size) {
    final glassRect = Rect.fromLTWH(
      size.width * 0.14,
      size.height * 0.1,
      size.width * 0.72,
      size.height * 0.78,
    );
    final glassPath = Path()
      ..moveTo(glassRect.left + glassRect.width * 0.08, glassRect.top)
      ..quadraticBezierTo(
        glassRect.center.dx,
        glassRect.top - 14,
        glassRect.right - glassRect.width * 0.08,
        glassRect.top,
      )
      ..lineTo(glassRect.right - glassRect.width * 0.2, glassRect.bottom)
      ..quadraticBezierTo(
        glassRect.center.dx,
        glassRect.bottom + 18,
        glassRect.left + glassRect.width * 0.2,
        glassRect.bottom,
      )
      ..close();

    final shadow = Paint()
      ..color = QwColors.primaryDeep.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.9),
        width: glassRect.width * 0.8,
        height: 26,
      ),
      shadow,
    );

    canvas.save();
    canvas.clipPath(glassPath);

    final waterTop = glassRect.bottom - glassRect.height * fill;
    final waterRect = Rect.fromLTRB(
      glassRect.left,
      waterTop,
      glassRect.right,
      glassRect.bottom + 20,
    );
    final waterPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF69DEFF), Color(0xFF2194FF), Color(0xFF126EEA)],
      ).createShader(waterRect);
    canvas.drawRect(waterRect, waterPaint);

    final surfacePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withValues(alpha: 0.72);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(glassRect.center.dx, waterTop),
        width: glassRect.width * 0.72,
        height: 18,
      ),
      surfacePaint,
    );

    final bubblePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.54)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final bubbles = [
      Offset(0.36, 0.76),
      Offset(0.58, 0.66),
      Offset(0.46, 0.52),
      Offset(0.64, 0.42),
      Offset(0.4, 0.34),
    ];
    for (final bubble in bubbles) {
      final y = glassRect.top + glassRect.height * bubble.dy;
      if (y > waterTop) {
        canvas.drawCircle(
          Offset(glassRect.left + glassRect.width * bubble.dx, y),
          3 + bubble.dx * 3,
          bubblePaint,
        );
      }
    }
    canvas.restore();

    final glassFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.72),
          QwColors.skyMid.withValues(alpha: 0.16),
          Colors.white.withValues(alpha: 0.34),
        ],
      ).createShader(glassRect);
    canvas.drawPath(glassPath, glassFill);

    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = const LinearGradient(
        colors: [Color(0xFFBEEBFF), Color(0xFF258DFF), Color(0xFFEAF8FF)],
      ).createShader(glassRect);
    canvas.drawPath(glassPath, rimPaint);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(glassRect.center.dx, glassRect.top),
        width: glassRect.width * 0.88,
        height: 30,
      ),
      rimPaint,
    );

    final highlight = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.38);
    canvas.drawLine(
      Offset(glassRect.left + glassRect.width * 0.18, glassRect.top + 36),
      Offset(glassRect.left + glassRect.width * 0.26, glassRect.bottom - 42),
      highlight,
    );
  }

  @override
  bool shouldRepaint(covariant _CrystalGlassPainter oldDelegate) {
    return oldDelegate.fill != fill;
  }
}

class _AmountRulerPainter extends CustomPainter {
  const _AmountRulerPainter({
    required this.fill,
    required this.minOz,
    required this.maxOz,
  });

  final double fill;
  final double minOz;
  final double maxOz;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width * 0.42;
    final trackTop = 0.0;
    final trackBottom = size.height;
    final handleY = trackBottom - (trackBottom - trackTop) * fill;

    final trackPaint = Paint()
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.72);
    canvas.drawLine(Offset(x, trackTop), Offset(x, trackBottom), trackPaint);

    final activePaint = Paint()
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..shader = QwGradients.primary.createShader(
        Rect.fromLTWH(x - 3, handleY, 6, trackBottom - handleY),
      );
    canvas.drawLine(Offset(x, handleY), Offset(x, trackBottom), activePaint);

    final tickPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = QwColors.primaryDeep.withValues(alpha: 0.38);
    for (var i = 0; i <= 31; i++) {
      final value = minOz + i;
      final tickFill = ((value - minOz) / (maxOz - minOz)).clamp(0.0, 1.0);
      final y = size.height * (1 - tickFill);
      final major = value == minOz || value % 8 == 0 || value == maxOz;
      tickPaint.strokeWidth = major ? 3 : 1.4;
      final length = major ? 24.0 : 12.0;
      canvas.drawLine(Offset(x - length, y), Offset(x, y), tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AmountRulerPainter oldDelegate) {
    return oldDelegate.fill != fill ||
        oldDelegate.minOz != minOz ||
        oldDelegate.maxOz != maxOz;
  }
}
