import 'package:flutter/material.dart';

class WaterBottle extends StatelessWidget {
  const WaterBottle({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 120,
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          FractionallySizedBox(
            heightFactor: progress.clamp(0.05, 1.0),
            widthFactor: 0.35,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
