import 'package:flutter/material.dart';

class QwAssetIcon extends StatelessWidget {
  const QwAssetIcon({
    super.key,
    required this.asset,
    required this.label,
    this.size = 34,
    this.opacity = 1,
  });

  final String asset;
  final String label;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      image: true,
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
