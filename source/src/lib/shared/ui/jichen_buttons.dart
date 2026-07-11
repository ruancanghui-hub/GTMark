import 'package:flutter/material.dart';

import '../theme/jichen_tokens.dart';

/// 骨架稿主按钮（全宽胶囊红底）。
class JichenPrimaryButton extends StatelessWidget {
  const JichenPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.height = 52,
    this.leading,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: JichenTokens.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: JichenTokens.accent.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}

/// 骨架稿描边按钮（红边胶囊）。
class JichenOutlineButton extends StatelessWidget {
  const JichenOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 40,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: JichenTokens.accent,
        side: const BorderSide(color: JichenTokens.accent),
        minimumSize: Size(expanded ? double.infinity : 0, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height / 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
