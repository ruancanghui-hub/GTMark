import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_test_harness.dart';
import 'package:qingbushui/modules/drink/drink_select_page.dart';
import 'package:qingbushui/shared/widgets/slide_to_drink.dart';

void main() {
  testWidgets('drink selection uses Option 2 card language', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpL10nApp(tester, const DrinkSelectPage());
    await tester.pumpAndSettle();

    expect(find.text('Choose your sip'), findsOneWidget);
    expect(find.text('WATER'), findsOneWidget);
    expect(find.text('OTHER'), findsOneWidget);
    expect(find.text('Small Glass'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
  });

  testWidgets('slide amount control uses Option 2 handle and reports changes', (
    tester,
  ) async {
    double changed = 8;

    await pumpL10nApp(
      tester,
      Scaffold(
        body: SizedBox(
          width: 260,
          height: 420,
          child: SlideToDrink(
            oz: 8,
            minOz: 1,
            maxOz: 32,
            onChanged: (value) => changed = value,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final handle = find.byKey(const ValueKey('amount-ruler-handle'));
    expect(handle, findsOneWidget);
    expect(find.text('32'), findsOneWidget);
    expect(find.text('24'), findsOneWidget);
    expect(find.text('16'), findsOneWidget);
    expect(find.text('8'), findsWidgets);
    expect(find.text('1 oz'), findsOneWidget);

    await tester.drag(handle, const Offset(0, -80));
    await tester.pump();

    expect(changed, greaterThan(8));
  });
}
