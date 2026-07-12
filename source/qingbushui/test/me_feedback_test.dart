import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_test_harness.dart';
import 'package:qingbushui/core/hydration/hydration_store.dart';
import 'package:qingbushui/modules/me/me_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('feedback can be submitted and stored locally', (tester) async {
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

    await tester.tap(find.text('Feedback'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Please add Apple Health');
    await tester.tap(find.widgetWithText(FilledButton, 'Send feedback'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('feedback')?.single, contains('Apple Health'));
  });
}
