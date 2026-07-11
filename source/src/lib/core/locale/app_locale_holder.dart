import 'package:flutter/material.dart';

/// 无 [BuildContext] 的代码（如 Dio）用 [lookupAppLocalizations] 时读取当前应用语言。
/// 由 [AppWidget] 在加载/切换语言时更新。
class AppLocaleHolder {
  AppLocaleHolder._();

  static Locale value = const Locale('en');

  static void set(Locale locale) {
    value = locale;
  }

  /// 与 [value] 对齐，供 `intl` [DateFormat] 使用；避免未传 locale 时跟随系统语言。
  static String get intlDateFormatLocale =>
      value.languageCode == 'zh' ? 'zh_CN' : 'en_US';
}
