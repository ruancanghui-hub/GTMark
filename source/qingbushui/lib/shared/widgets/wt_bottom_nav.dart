import 'package:flutter/material.dart';

class WtBottomNav extends StatelessWidget {
  const WtBottomNav({super.key, required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.water_drop, 'Today'),
    (Icons.history, 'History'),
    (Icons.article_outlined, 'Insights'),
    (Icons.person_outline, 'Me'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 64,
        child: Row(
          children: List.generate(_items.length, (i) {
            final selected = i == index;
            final (icon, label) = _items[i];
            return Expanded(
              child: InkWell(
                onTap: () => onTap(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white.withValues(alpha: selected ? 1 : 0.6),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: selected ? 1 : 0.6,
                        ),
                        fontSize: 11,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
