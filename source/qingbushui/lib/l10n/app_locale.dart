import 'package:flutter/material.dart';

/// Supported app locales.
enum AppLocale {
  zh('zh', '中文'),
  en('en', 'English');

  const AppLocale(this.code, this.displayName);

  final String code;
  final String displayName;

  Locale get flutterLocale => Locale(code);

  static AppLocale fromCode(String? code) {
    return AppLocale.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLocale.zh,
    );
  }

  static AppLocale? fromFlutterLocale(Locale? locale) {
    if (locale == null) return null;
    final lang = locale.languageCode;
    return AppLocale.values.where((l) => l.code == lang).firstOrNull;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
