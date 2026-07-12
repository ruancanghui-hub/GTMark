import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_test_harness.dart';
import 'package:qingbushui/core/hydration/hydration_store.dart';
import 'package:qingbushui/core/hydration/models.dart';
import 'package:qingbushui/modules/stats/history_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('history records can be edited and deleted', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    await HydrationStore.init();
    await HydrationStore.of().addIntake(
      drinkType: DrinkType.water,
      volumeMl: 240,
      at: DateTime.now(),
    );

    await tester.pumpWidget(l10nTestApp(Scaffold(body: HistoryTab(onNavTap: (_) {})),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -260));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Water'));
    await tester.pumpAndSettle();

    expect(find.text('Edit drink'), findsOneWidget);
    await tester.tap(find.text('Tea'));
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Drink updated'), findsOneWidget);
    expect(HydrationStore.of().records.single.drinkType, DrinkType.tea);
    final originalMinute = HydrationStore.of().records.single.recordedAt.minute;

    await tester.tap(find.text('Tea').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('+15 min'));
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(
      HydrationStore.of().records.single.recordedAt.minute,
      (originalMinute + 15) % 60,
    );

    await tester.tap(find.text('Tea').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(HydrationStore.of().records, isEmpty);
  });
}
