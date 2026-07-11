import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/qing_theme.dart';

class WaterProgressRing extends StatelessWidget {
  const WaterProgressRing({
    super.key,
    required this.progress,
    required this.centerLabel,
    required this.subtitle,
    this.compact = false,
  });

  final double progress;
  final String centerLabel;
  final String subtitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: compact ? 104 : 200,
          height: compact ? 104 : 200,
          child: CustomPaint(
            painter: _RingPainter(
              progress: progress.clamp(0.0, 1.0),
              compact: compact,
            ),
            child: Center(
              child: Text(
                centerLabel,
                style: TextStyle(
                  color: compact ? Colors.white : Colors.black87,
                  fontSize: compact ? 22 : 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.compact});

  final double progress;
  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - (compact ? 6 : 8);
    final bg = Paint()
      ..color = (compact ? Colors.white : WtColors.blueLight).withValues(
        alpha: 0.4,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 8 : 14
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 8 : 14
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = Colors.white.withValues(alpha: compact ? 0.16 : 1);

    canvas.drawCircle(center, radius - (compact ? 12 : 20), fill);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi,
      false,
      bg,
    );
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        fg,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.compact != compact;
}
