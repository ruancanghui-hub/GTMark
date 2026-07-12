import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_test_harness.dart';
import 'package:qingbushui/modules/insights/insights_tab.dart';

void main() {
  testWidgets('insight cards open readable details', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(l10nTestApp(Scaffold(body: InsightsTab(onNavTap: (_) {})),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Best Times to Drink Water'));
    await tester.pumpAndSettle();

    expect(find.text('Best Times to Drink Water'), findsWidgets);
    expect(find.textContaining('Start with water after waking'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Got it'), findsOneWidget);
  });
}
