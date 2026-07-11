import 'package:flutter/material.dart';

import '../../app/qing_theme.dart';

class WtGradientBackground extends StatelessWidget {
  const WtGradientBackground({super.key, required this.child, this.gradient});

  final Widget child;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? WtColors.backgroundGradient,
      ),
      child: child,
    );
  }
}
