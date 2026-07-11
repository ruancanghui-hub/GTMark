import 'package:flutter/material.dart';

import '../../app/qing_theme.dart';

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
          child: CustomPaint(
            size: Size(constraints.maxWidth, h),
            painter: _GlassPainter(fill: _fill),
            child: Stack(
              children: [
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
                    child: const Icon(
                      Icons.swap_vert_rounded,
                      color: Colors.white,
                      size: 30,
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

class _GlassPainter extends CustomPainter {
  _GlassPainter({required this.fill});

  final double fill;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width * 0.55;
    final left = (size.width - w) / 2;
    final top = size.height * 0.05;
    final bottom = size.height * 0.95;
    final glassH = bottom - top;
    final path = Path()
      ..moveTo(left + w * 0.15, top)
      ..lineTo(left + w * 0.85, top)
      ..lineTo(left + w * 0.7, bottom)
      ..lineTo(left + w * 0.3, bottom)
      ..close();

    final glassPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF4FDFF), Color(0xFFD8F4FF), Color(0xFFB3E5FF)],
      ).createShader(Rect.fromLTWH(left, top, w, glassH));
    canvas.drawPath(path, glassPaint);

    final waterTop = bottom - glassH * fill;
    final waterPath = Path()
      ..moveTo(left + w * 0.3, bottom)
      ..lineTo(left + w * 0.7, bottom)
      ..lineTo(left + w * 0.68, waterTop + 8)
      ..quadraticBezierTo(
        left + w * 0.5,
        waterTop - 6,
        left + w * 0.32,
        waterTop + 8,
      )
      ..close();
    final waterPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [WtColors.blueDeep, WtColors.blueMid, WtColors.blueLight],
      ).createShader(Rect.fromLTWH(left, waterTop, w, bottom - waterTop));
    canvas.drawPath(waterPath, waterPaint);

    final shine = Paint()..color = Colors.white.withValues(alpha: 0.38);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          left + w * 0.24,
          top + glassH * 0.12,
          w * 0.12,
          glassH * 0.36,
        ),
        const Radius.circular(14),
      ),
      shine,
    );

    final tickPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 1.5;
    for (var i = 1; i <= 8; i++) {
      final y = bottom - glassH * (i / 8);
      canvas.drawLine(
        Offset(left + w * 0.38, y),
        Offset(left + w * 0.62, y),
        tickPaint,
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.72)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4,
    );
  }

  @override
  bool shouldRepaint(covariant _GlassPainter old) => old.fill != fill;
}
