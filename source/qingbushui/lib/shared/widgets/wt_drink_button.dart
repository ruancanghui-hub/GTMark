import 'package:flutter/material.dart';

import '../../app/qing_theme.dart';

enum WtDrinkButtonStyle { white, gradient }

class WtDrinkButton extends StatelessWidget {
  const WtDrinkButton({
    super.key,
    required this.onPressed,
    this.style = WtDrinkButtonStyle.gradient,
  });

  final VoidCallback onPressed;
  final WtDrinkButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final isWhite = style == WtDrinkButtonStyle.white;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: isWhite ? Colors.white : null,
              gradient: isWhite ? null : WtColors.buttonGradient,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: isWhite ? Colors.black : Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 4),
                Text(
                  'DRINK',
                  style: TextStyle(
                    color: isWhite ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
