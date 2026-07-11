import 'package:flutter/material.dart';

/// 《链记》APP UI 设计规范 · 二、字体层级（iOS 17+ 大字排版）
abstract final class LianjiTypography {
  static const double displayLarge = 34;
  static const double title1 = 28;
  static const double title2 = 22;
  static const double body = 17;
  static const double subhead = 15;
  static const double caption = 13;
  static const double button = 17;

  static TextTheme textTheme({Color ink = const Color(0xFF333333)}) => TextTheme(
        displayLarge: TextStyle(
          fontSize: displayLarge,
          fontWeight: FontWeight.w700,
          height: 41 / displayLarge,
          letterSpacing: -0.4,
          color: ink,
        ),
        headlineMedium: TextStyle(
          fontSize: title1,
          fontWeight: FontWeight.w700,
          height: 34 / title1,
          letterSpacing: -0.3,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontSize: title2,
          fontWeight: FontWeight.w600,
          height: 28 / title2,
          color: ink,
        ),
        bodyLarge: TextStyle(
          fontSize: body,
          fontWeight: FontWeight.w400,
          height: 22 / body,
          color: ink,
        ),
        bodyMedium: TextStyle(
          fontSize: subhead,
          fontWeight: FontWeight.w400,
          height: 20 / subhead,
          color: const Color(0xFF8F88AC),
        ),
        bodySmall: TextStyle(
          fontSize: caption,
          fontWeight: FontWeight.w400,
          height: 18 / caption,
          color: const Color(0xFFB5AFC9),
        ),
        labelLarge: TextStyle(
          fontSize: button,
          fontWeight: FontWeight.w600,
          height: 22 / button,
          color: Colors.white,
        ),
      );
}

extension LianjiTypographyContext on BuildContext {
  double get _scale => MediaQuery.textScalerOf(this).scale(1);

  TextStyle lianjiDisplay({Color? color}) => TextStyle(
        fontSize: _scale * LianjiTypography.displayLarge,
        fontWeight: FontWeight.w700,
        height: 41 / LianjiTypography.displayLarge,
        letterSpacing: -0.4,
        color: color,
      );

  TextStyle lianjiTitle1({Color? color}) => TextStyle(
        fontSize: _scale * LianjiTypography.title1,
        fontWeight: FontWeight.w700,
        height: 34 / LianjiTypography.title1,
        letterSpacing: -0.3,
        color: color,
      );

  TextStyle lianjiTitle2({Color? color, FontWeight? weight}) => TextStyle(
        fontSize: _scale * LianjiTypography.title2,
        fontWeight: weight ?? FontWeight.w600,
        height: 28 / LianjiTypography.title2,
        color: color,
      );

  TextStyle lianjiBody({Color? color, FontWeight? weight}) => TextStyle(
        fontSize: _scale * LianjiTypography.body,
        fontWeight: weight ?? FontWeight.w400,
        height: 22 / LianjiTypography.body,
        color: color,
      );

  TextStyle lianjiSubhead({Color? color, FontWeight? weight}) => TextStyle(
        fontSize: _scale * LianjiTypography.subhead,
        fontWeight: weight ?? FontWeight.w400,
        height: 20 / LianjiTypography.subhead,
        color: color,
      );

  TextStyle lianjiCaption({Color? color, FontWeight? weight}) => TextStyle(
        fontSize: _scale * LianjiTypography.caption,
        fontWeight: weight ?? FontWeight.w400,
        height: 18 / LianjiTypography.caption,
        color: color,
      );

  TextStyle lianjiButton({Color? color}) => TextStyle(
        fontSize: _scale * LianjiTypography.button,
        fontWeight: FontWeight.w600,
        height: 22 / LianjiTypography.button,
        color: color,
      );
}
