import 'package:flutter/material.dart';

import '../../app/qing_theme.dart';
import '../assets/qw_assets.dart';
import 'qw_asset_icon.dart';

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
                QwAssetIcon(
                  asset: QwAssets.confirmWaterDrop,
                  label: 'Confirm drink',
                  size: 28,
                  opacity: isWhite ? 0.9 : 1,
                ),
                const SizedBox(width: 6),
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
