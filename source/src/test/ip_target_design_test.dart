import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lianji/core/weather/weather_day_info.dart';
import 'package:lianji/core/weather/weather_service.dart';
import 'package:lianji/modules/main/main_page.dart';

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

  testWidgets('four tabs expose the selected IP target layout markers', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const GetMaterialApp(home: MainPage()));
    await tester.pump();

    expect(find.text('今日建议'), findsOneWidget);

    await tester.tap(find.text('择吉'));
    await tester.pump();
    expect(find.text('选个合适的日子'), findsOneWidget);
    expect(find.text('让吉辰帮我选'), findsOneWidget);

    await tester.tap(find.text('天气'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('未来5天'), findsOneWidget);

    await tester.tap(find.text('我的'));
    await tester.pump();
    expect(find.text('陪你规划每一天'), findsOneWidget);
    expect(find.text('提醒与纪念日'), findsOneWidget);
    expect(find.text('数据备份'), findsOneWidget);
    expect(find.text('发祝福'), findsOneWidget);
    expect(find.text('永久去广告'), findsNothing);
    expect(find.text('收藏'), findsNothing);
  });
}
