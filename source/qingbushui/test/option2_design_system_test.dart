import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qingbushui/shared/visuals/qw_water_bottle_hero.dart';
import 'package:qingbushui/shared/widgets/qw_bottom_nav.dart';
import 'package:qingbushui/shared/widgets/qw_glass_chip.dart';
import 'package:qingbushui/shared/widgets/qw_screen_shell.dart';

void main() {
  testWidgets('Option 2 design system widgets render together', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: QwScreenShell(
          child: Column(
            children: [
              const QwGlassChip(icon: Icons.water_drop, label: 'Daily goal'),
              const Expanded(child: QwWaterBottleHero(progress: 0.6)),
              QwBottomNav(index: 0, onTap: (_) {}, onAdd: () {}),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Daily goal'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
