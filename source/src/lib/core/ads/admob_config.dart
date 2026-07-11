import 'package:flutter/foundation.dart';

/// AdMob 配置（LOOP-009 / SPEC-030）。
///
/// 当前用户提供的是 iOS 应用 ID 与 iOS 广告单元 ID，因此运行时仅在 iOS
/// 启用请求。Android 后续如果要上架，需要单独创建 Android 应用 ID 与广告位。
abstract final class AdMobConfig {
  static const productionAppId = 'ca-app-pub-1210970407399902~6241246348';
  static const productionAppOpenAdUnitId =
      'ca-app-pub-1210970407399902/1083298754';
  static const productionBannerAdUnitId =
      'ca-app-pub-1210970407399902/8699888720';

  /// Google 官方 iOS 测试广告位，Debug 下使用以保证模拟器/开发机可见填充。
  static const debugAppOpenAdUnitId =
      'ca-app-pub-3940256099942544/5572853029';
  static const debugBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  static const appId = productionAppId;

  static String get appOpenAdUnitId =>
      kDebugMode ? debugAppOpenAdUnitId : productionAppOpenAdUnitId;

  static String get bannerAdUnitId =>
      kDebugMode ? debugBannerAdUnitId : productionBannerAdUnitId;

  static bool get isSupportedPlatform =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
}
