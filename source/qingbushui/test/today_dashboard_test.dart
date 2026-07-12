import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_test_harness.dart';
import 'package:qingbushui/core/hydration/hydration_store.dart';
import 'package:qingbushui/core/hydration/models.dart';
import 'package:qingbushui/core/hydration/volume_format.dart';
import 'package:qingbushui/modules/home/home_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Today dashboard uses Option 2 home language', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    await HydrationStore.init();

    await pumpL10nApp(tester, Scaffold(body: HomeTab(onNavTap: (_) {})));
    await tester.pumpAndSettle();

    expect(find.text('Qing Water'), findsOneWidget);
    expect(find.text('Daily Goal'), findsOneWidget);
    expect(find.text('Today'), findsWidgets);
    expect(find.text('Quick add'), findsOneWidget);
    expect(find.text('8 oz'), findsOneWidget);
    expect(find.text('20 oz'), findsOneWidget);
    expect(find.text('+ Drink'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
  });

  testWidgets('Today dashboard shows recent intake records', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    await HydrationStore.init();
    await HydrationStore.of().addIntake(
      drinkType: DrinkType.water,
      volumeMl: VolumeFormat.mlFromOz(8),
      at: DateTime.now(),
    );

    await pumpL10nApp(tester, Scaffold(body: HomeTab(onNavTap: (_) {})));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -360));
    await tester.pumpAndSettle();

    expect(find.text("Today's drinks"), findsOneWidget);
    expect(find.text('Water'), findsOneWidget);
    expect(find.textContaining('8'), findsWidgets);
  });
}
