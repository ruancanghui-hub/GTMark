import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_test_harness.dart';
import 'package:qingbushui/shared/visuals/qw_water_bottle_hero.dart';
import 'package:qingbushui/shared/widgets/qw_bottom_nav.dart';
import 'package:qingbushui/shared/widgets/qw_glass_chip.dart';
import 'package:qingbushui/shared/widgets/qw_screen_shell.dart';

void main() {
  testWidgets('Option 2 design system widgets render together', (tester) async {
    await pumpL10nApp(
      tester,
      QwScreenShell(
        child: Column(
          children: [
            const QwGlassChip(icon: Icons.water_drop, label: 'Daily Goal'),
            const Expanded(child: QwWaterBottleHero(progress: 0.6)),
            QwBottomNav(index: 0, onTap: (_) {}, onAdd: () {}),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Daily Goal'), findsWidgets);
    expect(find.text('Today'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
