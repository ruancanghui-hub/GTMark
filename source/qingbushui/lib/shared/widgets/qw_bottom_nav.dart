import 'package:flutter/material.dart';

import '../../app/qing_theme.dart';
import '../../l10n/app_localizations.dart';
import '../assets/qw_assets.dart';
import 'qw_asset_icon.dart';

class QwBottomNav extends StatelessWidget {
  const QwBottomNav({
    super.key,
    required this.index,
    required this.onTap,
    required this.onAdd,
  });

  final int index;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      (QwAssets.navToday, l10n.navToday),
      (QwAssets.navHistory, l10n.navHistory),
      (QwAssets.navAdd, l10n.navAdd),
      (QwAssets.navInsights, l10n.navInsights),
      (QwAssets.navMe, l10n.navMe),
    ];

    return SizedBox(
      height: 86,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: QwColors.primaryDeep.withValues(alpha: 0.12),
                    blurRadius: 28,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: Row(
                  children: [
                    _NavItem(
                      item: items[0],
                      selected: index == 0,
                      onTap: () => onTap(0),
                    ),
                    _NavItem(
                      item: items[1],
                      selected: index == 1,
                      onTap: () => onTap(1),
                    ),
                    const Expanded(child: SizedBox()),
                    _NavItem(
                      item: items[3],
                      selected: index == 2,
                      onTap: () => onTap(2),
                    ),
                    _NavItem(
                      item: items[4],
                      selected: index == 3,
                      onTap: () => onTap(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(top: 0, child: _AddButton(onPressed: onAdd, label: l10n.navAdd)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final (String, String) item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (asset, label) = item;
    final color = selected ? QwColors.primary : const Color(0xFFB7C0CD);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QwAssetIcon(
              asset: asset,
              label: '$label tab icon',
              size: selected ? 31 : 27,
              opacity: selected ? 1 : 0.46,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  const _AddButton({required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 130),
        scale: _pressed ? 0.92 : 1,
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: QwGradients.primary,
            boxShadow: [
              BoxShadow(
                color: QwColors.primary.withValues(alpha: 0.36),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: QwAssetIcon(
              asset: QwAssets.navAdd,
              label: widget.label,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}
