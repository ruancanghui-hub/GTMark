import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_test_harness.dart';
import 'package:qingbushui/core/hydration/hydration_store.dart';
import 'package:qingbushui/modules/me/me_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('daily goal can be saved from the Me tab', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    await HydrationStore.init();

    await tester.pumpWidget(l10nTestApp(Scaffold(body: MeTab(onNavTap: (_) {})),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Daily Goal').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save goal'));
    await tester.pumpAndSettle();

    expect(find.text('Daily goal updated'), findsOneWidget);
    expect(HydrationStore.of().profile?.dailyGoalMl, 1774);
    expect(HydrationStore.of().profile?.onboardingDone, isTrue);
  });
}
