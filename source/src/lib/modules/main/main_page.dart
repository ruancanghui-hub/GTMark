import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/theme/jichen_tokens.dart';
import '../../../shared/ui/jichen_banner_ad.dart';
import '../../../shared/ui/jichen_bottom_nav.dart';
import 'main_controller.dart';
import 'tabs/mine_tab.dart';
import 'tabs/today_tab.dart';
import 'tabs/weather_tab.dart';
import 'tabs/zeji_tab.dart';
import 'today_controller.dart';
import 'zeji_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const _pages = [TodayTab(), ZejiTab(), WeatherTab(), MineTab()];

  static const _labels = ['日历', '择吉', '天气', '我的'];

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    Get.put(TodayController());
    Get.put(ZejiController());
    final c = Get.find<MainController>();
    return Obx(() {
      final index = c.currentIndex.value;
      return Scaffold(
        backgroundColor: JichenTokens.canvas,
        body: IndexedStack(index: index, children: _pages),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const JichenBannerAd(),
            JichenBottomNav(
              currentIndex: index,
              onTap: c.switchTab,
              labels: _labels,
            ),
          ],
        ),
      );
    });
  }
}
