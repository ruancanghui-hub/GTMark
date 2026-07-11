import 'package:flutter/material.dart';

import 'lianji_typography.dart';

/// 吉辰万年历 · 新国风骨架稿色彩令牌。
abstract final class JichenTokens {
  /// 页面暖米白底（设计规范）。
  static const Color canvas = Color(0xFFF7F2EA);
  static const Color background = canvas;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cloudGray = Color(0xFFEFECE7);

  /// 吉辰红 · 主色。
  static const Color accent = Color(0xFFD94734);
  static const Color accentDark = Color(0xFFC43828);
  static const Color accentLight = Color(0xFFE85A48);

  /// 鎏金点缀。
  static const Color gold = Color(0xFFD8A74A);

  /// 底部导航 / 范围选中浅红。
  static const Color tabActive = Color(0xFFFFECE8);

  static const Color labelPrimary = Color(0xFF333333);
  static const Color labelSecondary = Color(0xFF888888);
  static const Color separator = Color(0xFFEBEBEB);
  static const Color cardBorder = Color(0xFFEEEEEE);

  static const Color yiBg = Color(0xFFE8F5E9);
  static const Color yiText = Color(0xFF4CAF50);
  static const Color jiBg = Color(0xFFFFEBEA);
  static const Color jiText = Color(0xFFFF3B30);
  static const Color restMark = Color(0xFF007AFF);
  static const Color workdayAdjust = Color(0xFFFF9500);

  /// 图标浅红底。
  static const Color iconCircleBg = Color(0xFFFFEBEE);

  /// 月历大字排版（适老阅读）。
  static const double calendarSolar = 22;
  static const double calendarLunar = 14;
  static const double calendarMark = 13;
  static const double calendarWeek = 16;
  static const double calendarHeroDay = 56;

  /// 择吉范围选中色。
  static const Color zejiRangeActive = accent;
  static const Color zejiMatterIcon = Color(0xFFB8956B);

  static const double sheetTopRadius = 28;
  static const double cardRadius = 16;
  static const double chipRadius = 12;
  static const double pillRadius = 24;
}

/// 复用 iOS 17 字号体系（与 LianjiTypography 数值一致）。
typedef JichenTypography = LianjiTypography;

extension JichenTypographyContext on BuildContext {
  double get _jichenScale => MediaQuery.textScalerOf(this).scale(1);

  TextStyle jichenDisplay({Color? color}) =>
      lianjiDisplay(color: color ?? JichenTokens.labelPrimary);

  TextStyle jichenTitle1({Color? color}) =>
      lianjiTitle1(color: color ?? JichenTokens.labelPrimary);

  TextStyle jichenTitle2({Color? color}) =>
      lianjiTitle2(color: color ?? JichenTokens.labelPrimary);

  TextStyle jichenTitle3({Color? color}) =>
      lianjiTitle2(color: color ?? JichenTokens.labelPrimary);

  TextStyle jichenBody({Color? color, FontWeight? weight}) =>
      lianjiBody(color: color ?? JichenTokens.labelPrimary, weight: weight);

  TextStyle jichenCaption({Color? color}) =>
      lianjiCaption(color: color ?? JichenTokens.labelSecondary);

  TextStyle jichenSubhead({Color? color, FontWeight? weight}) =>
      lianjiSubhead(color: color ?? JichenTokens.labelSecondary, weight: weight);

  /// 设计规范 Caption 1（12pt）— 择吉参考说明等弱信息。
  TextStyle jichenFootnote({Color? color, FontWeight? weight}) => TextStyle(
        fontSize: _jichenScale * 12,
        fontWeight: weight ?? FontWeight.w400,
        height: 16 / 12,
        color: color ?? JichenTokens.labelSecondary,
      );

  /// 骨架稿页头大字标题。
  TextStyle jichenPageHeader({Color? color}) => TextStyle(
        fontSize: _jichenScale * 32,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: 1,
        color: color ?? Colors.white,
      );

  TextStyle jichenCalendarSolar({
    Color? color,
    FontWeight weight = FontWeight.w700,
  }) =>
      TextStyle(
        fontSize: _jichenScale * JichenTokens.calendarSolar,
        fontWeight: weight,
        height: 1.15,
        color: color ?? JichenTokens.labelPrimary,
      );

  TextStyle jichenCalendarLunar({Color? color}) => TextStyle(
        fontSize: _jichenScale * JichenTokens.calendarLunar,
        fontWeight: FontWeight.w500,
        height: 1.15,
        color: color ?? JichenTokens.labelSecondary,
      );

  TextStyle jichenCalendarMark({
    Color? color,
    FontWeight weight = FontWeight.w700,
  }) =>
      TextStyle(
        fontSize: _jichenScale * JichenTokens.calendarMark,
        fontWeight: weight,
        height: 1.1,
        color: color ?? JichenTokens.accent,
      );

  TextStyle jichenCalendarWeek({Color? color}) => TextStyle(
        fontSize: _jichenScale * JichenTokens.calendarWeek,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color ?? JichenTokens.labelPrimary,
      );

  TextStyle jichenHeroDay({Color? color}) => TextStyle(
        fontSize: _jichenScale * JichenTokens.calendarHeroDay,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -1,
        color: color ?? JichenTokens.accent,
      );
}
