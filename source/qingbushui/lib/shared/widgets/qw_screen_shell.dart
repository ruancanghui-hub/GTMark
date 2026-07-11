import 'package:flutter/material.dart';

import '../../app/qing_theme.dart';

class QwScreenShell extends StatelessWidget {
  const QwScreenShell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(22, 12, 22, 0),
    this.gradient = QwGradients.sky,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
