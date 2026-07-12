import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_test_harness.dart';
import 'package:qingbushui/modules/splash/splash_page.dart';

void main() {
  testWidgets('Splash uses Qing Water Option 2 brand entry', (tester) async {
    await pumpL10nApp(tester, const SplashPage(redirectOnReady: false));
    await tester.pump();

    expect(find.text('Qing Water'), findsOneWidget);
    expect(find.text('Hydrate gently'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
