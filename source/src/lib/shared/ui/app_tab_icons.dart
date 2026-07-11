import 'package:flutter/material.dart';

/// 与 [assets/images/icons/] 下资源对应。
abstract final class AppTabIcons {
  static const String add = 'assets/images/icons/add.png';
  /// 列表 / 侧栏等与「列表」相关的位图（与根目录旧名「列表.png」同源）。
  static const String list = 'assets/images/icons/list.png';
  static const String calendar = 'assets/images/icons/calendar.png';
  /// 中文界面（含繁体）：「今」字日历图标。
  static const String recordDay = 'assets/images/icons/record_day.png';
  /// 非中文界面：`today` 文案图标。
  static const String recordDayEn = 'assets/images/icons/record_day_en.png';

  /// 与 [MaterialApp.locale] 一致：简体中文/繁体等 `zh*` 用 [recordDay]，否则 [recordDayEn]。
  static String recordDayForLocale(Locale locale) {
    final code = locale.languageCode.toLowerCase();
    if (code.startsWith('zh')) {
      return recordDay;
    }
    return recordDayEn;
  }
  static const String countdownBook = 'assets/images/icons/countdown_book.png';
  static const String profile = 'assets/images/icons/profile.png';
  static const String back = 'assets/images/icons/back.png';
}

/// Tab / 导航栏 PNG 图标。
///
/// 使用 [ImageIcon] + [AssetImage]（与 [Icon] 一致），比 [Image.asset] 的
/// `color` + [BlendMode.srcIn] 对部分「白底 / 非纯透明」PNG 更稳定；
/// 若仍不显示，请检查 [pubspec.yaml] 是否已声明对应路径并完整重启 App。
Widget appTabIconAsset(
  String assetPath,
  Color color, {
  double size = 28,
}) {
  return ImageIcon(
    AssetImage(assetPath),
    size: size,
    color: color,
  );
}
