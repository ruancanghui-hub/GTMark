import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lianji/core/ads/admob_config.dart';
import 'package:lianji/core/ads/admob_service.dart';
import 'package:lianji/modules/main/main_page.dart';

void main() {
  tearDown(Get.reset);

  test('AdMob production ids are configured', () {
    expect(
      AdMobConfig.productionAppId,
      'ca-app-pub-1210970407399902~6241246348',
    );
    expect(
      AdMobConfig.productionAppOpenAdUnitId,
      'ca-app-pub-1210970407399902/1083298754',
    );
    expect(
      AdMobConfig.productionBannerAdUnitId,
      'ca-app-pub-1210970407399902/8699888720',
    );
  });

  testWidgets('banner ad is disabled in widget tests', (tester) async {
    expect(AdMobService.instance.isSupported, isFalse);

    await tester.pumpWidget(const GetMaterialApp(home: MainPage()));
    await tester.pump();

    expect(find.byType(AdWidget), findsNothing);
  });
}
