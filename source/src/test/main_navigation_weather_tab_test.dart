import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lianji/core/weather/weather_day_info.dart';
import 'package:lianji/core/weather/weather_service.dart';
import 'package:lianji/modules/main/main_page.dart';
import 'package:lianji/shared/ui/jichen_bottom_nav.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    WeatherService.debugOverride = {
      '2026-07-10': WeatherDayInfo(
        date: DateTime(2026, 7, 10),
        tempMinC: 21,
        tempMaxC: 31,
        precipitationProbMax: 20,
        aqi: 52,
      ),
    };
  });

  tearDown(() {
    Get.reset();
    WeatherService.debugOverride = null;
  });

  testWidgets('main tabs replace reminder with weather', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: MainPage()));
    await tester.pump();

    final bottomNav = find.byType(JichenBottomNav);
    expect(
      find.descendant(of: bottomNav, matching: find.text('日历')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: bottomNav, matching: find.text('择吉')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: bottomNav, matching: find.text('天气')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: bottomNav, matching: find.text('我的')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: bottomNav, matching: find.text('提醒')),
      findsNothing,
    );
  });

  testWidgets('weather tab opens first-level weather page', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: MainPage()));
    await tester.pump();

    await tester.tap(find.text('天气'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('天气'), findsOneWidget);
    expect(find.textContaining('未来5天'), findsOneWidget);
    expect(find.textContaining('31'), findsWidgets);
    expect(find.byIcon(Icons.more_horiz_rounded), findsNothing);
  });

  testWidgets('zeji search shows a loading dialog after button tap', (
    tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: MainPage()));
    await tester.pump();

    await tester.tap(find.text('择吉'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('让吉辰帮我选'));
    await tester.pump();
    await tester.tap(find.text('让吉辰帮我选'));
    await tester.pump();

    expect(find.text('正在择吉'), findsOneWidget);
    expect(find.text('吉辰正在筛选好日子'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();
    expect(find.text('正在择吉'), findsNothing);
  });
}
