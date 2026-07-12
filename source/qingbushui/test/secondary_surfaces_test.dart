import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_test_harness.dart';
import 'package:qingbushui/core/hydration/hydration_store.dart';
import 'package:qingbushui/modules/insights/insights_tab.dart';
import 'package:qingbushui/modules/me/me_tab.dart';
import 'package:qingbushui/modules/onboarding/onboarding_page.dart';
import 'package:qingbushui/modules/reminders/reminder_settings_page.dart';
import 'package:qingbushui/modules/stats/history_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await HydrationStore.init();
  });

  testWidgets('secondary surfaces render key functional sections', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(l10nTestApp(Scaffold(body: HistoryTab(onNavTap: (_) {})),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Day'), findsOneWidget);
    expect(find.text('Daily Average'), findsOneWidget);

    await tester.pumpWidget(l10nTestApp(Scaffold(body: InsightsTab(onNavTap: (_) {})),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('INSIGHTS'), findsOneWidget);
    expect(find.text('Water Drinking'), findsOneWidget);

    await tester.pumpWidget(l10nTestApp(Scaffold(body: MeTab(onNavTap: (_) {})),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Me'), findsWidgets);
    expect(find.text('Unit'), findsOneWidget);

    await tester.pumpWidget(l10nTestApp(ReminderSettingsPage()));
    await tester.pumpAndSettle();
    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('4 daily reminders ready'), findsOneWidget);
    expect(find.text('Enable notifications'), findsOneWidget);
    expect(find.text('Wake-up water'), findsOneWidget);

    await tester.pumpWidget(l10nTestApp(OnboardingPage()));
    await tester.pumpAndSettle();
    expect(find.text('Your daily goal is'), findsOneWidget);
    expect(find.text('Start hydrating'), findsOneWidget);
  });
}
