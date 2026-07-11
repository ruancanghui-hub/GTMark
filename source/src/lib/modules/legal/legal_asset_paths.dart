import 'package:flutter/material.dart';

/// 与 [pubspec.yaml] `assets/legal/` 声明一致。
abstract final class LegalAssetPaths {
  static const termsZh = 'assets/legal/terms_zh.md';
  static const privacyZh = 'assets/legal/privacy_zh.md';
  static const termsEn = 'assets/legal/terms_en.md';
  static const privacyEn = 'assets/legal/privacy_en.md';

  /// 简体/繁体等 `zh*` 使用中文正文，其余使用英文正文。
  static bool useChineseMarkdown(Locale locale) {
    return locale.languageCode.toLowerCase().startsWith('zh');
  }

  static String termsPath(Locale locale) =>
      useChineseMarkdown(locale) ? termsZh : termsEn;

  static String privacyPath(Locale locale) =>
      useChineseMarkdown(locale) ? privacyZh : privacyEn;
}
