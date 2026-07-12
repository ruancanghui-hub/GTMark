import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_test_harness.dart';
import 'package:qingbushui/core/hydration/goal_calculator.dart';
import 'package:qingbushui/core/hydration/hydration_store.dart';
import 'package:qingbushui/core/hydration/models.dart';
import 'package:qingbushui/modules/me/me_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('profile details can be saved and recalculate the goal', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    await HydrationStore.init();
    await HydrationStore.of().saveProfile(
      const UserProfile(
        weightKg: 65,
        activityLevel: ActivityLevel.low,
        dailyGoalMl: 1500,
        onboardingDone: true,
        gender: Gender.female,
        climate: Climate.cold,
      ),
    );

    await tester.pumpWidget(l10nTestApp(Scaffold(body: MeTab(onNavTap: (_) {})),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Personal Details'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male'));
    await tester.tap(find.text('Athlete'));
    await tester.tap(find.text('Hot'));
    await tester.tap(find.widgetWithText(FilledButton, 'Save profile'));
    await tester.pumpAndSettle();

    final expectedGoal = GoalCalculator.calculateDailyGoalMl(
      weightKg: 65,
      activityLevel: ActivityLevel.high,
      gender: Gender.male,
      climate: Climate.hot,
    );
    final profile = HydrationStore.of().profile;
    expect(profile?.gender, Gender.male);
    expect(profile?.activityLevel, ActivityLevel.high);
    expect(profile?.climate, Climate.hot);
    expect(profile?.dailyGoalMl, expectedGoal);
  });
}
