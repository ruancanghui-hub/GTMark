import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qingbushui/modules/splash/splash_page.dart';

void main() {
  testWidgets('Splash uses Qing Water Option 2 brand entry', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SplashPage(redirectOnReady: false)),
    );

    expect(find.text('Qing Water'), findsOneWidget);
    expect(find.text('Hydrate gently'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
