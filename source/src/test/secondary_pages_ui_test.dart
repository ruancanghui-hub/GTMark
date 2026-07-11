import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lianji/core/weather/weather_day_info.dart';
import 'package:lianji/core/weather/weather_service.dart';
import 'package:lianji/modules/backup/backup_page.dart';
import 'package:lianji/modules/main/main_page.dart';
import 'package:lianji/modules/main/tabs/reminder_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
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

  testWidgets('mine hides unfinished secondary entries', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: MainPage()));
    await tester.pump();

    await tester.tap(find.text('我的'));
    await tester.pump();

    expect(find.text('提醒与纪念日'), findsOneWidget);
    expect(find.text('数据备份'), findsOneWidget);
    expect(find.text('发祝福'), findsOneWidget);
    expect(find.text('收藏'), findsNothing);
    expect(find.text('永久去广告'), findsNothing);
  });

  testWidgets('zeji hides unfinished zodiac filter', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: MainPage()));
    await tester.pump();

    await tester.tap(find.text('择吉'));
    await tester.pump();

    expect(find.text('只看周末'), findsOneWidget);
    expect(find.text('避开我的生肖冲日'), findsNothing);
  });

  testWidgets('reminder secondary page uses unified back affordance', (
    tester,
  ) async {
    await tester.pumpWidget(
      const GetMaterialApp(home: ReminderTab(asSecondaryPage: true)),
    );
    await tester.pump();

    expect(find.text('提醒与纪念日'), findsOneWidget);
    expect(find.byTooltip('返回'), findsOneWidget);
  });

  testWidgets(
    'backup page hides unfinished account sync and internal checklist',
    (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: BackupPage()));
      await tester.pump();

      expect(find.text('数据备份'), findsOneWidget);
      expect(find.byTooltip('返回'), findsOneWidget);
      expect(find.text('账号同步'), findsNothing);
      expect(find.text('打开账号同步'), findsNothing);
      expect(find.text('发布前回归清单'), findsNothing);
    },
  );
}
