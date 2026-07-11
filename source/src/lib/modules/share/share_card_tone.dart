import 'package:flutter/material.dart';

/// 分享卡视觉气质：喜庆 vs 祭祀 solemn（Design-Brief §11 / 闭环详规 LOOP-008）。
abstract final class ShareCardTone {
  static const solemnFestivalIds = {
    'tf_qingming',
    'tf_hanshi',
    'tf_zhongyuan',
    'tf_hanyi',
    'tf_xiayuan',
  };

  static bool isSolemn({String? festivalId, String? poemTone}) {
    if (poemTone == 'solemn') return true;
    if (festivalId == null) return false;
    return solemnFestivalIds.contains(festivalId);
  }
}

/// 分享卡配色（仅分享卡，不进 App 主界面）。
class ShareCardPalette {
  const ShareCardPalette({
    required this.headlineColor,
    required this.accentColor,
    required this.bgTop,
    required this.bgBottom,
    required this.borderColor,
    required this.blessingBg,
    required this.blessingBorder,
    required this.watermarkIcon,
    required this.sealBorder,
    required this.sealFill,
  });

  final Color headlineColor;
  final Color accentColor;
  final Color bgTop;
  final Color bgBottom;
  final Color borderColor;
  final Color blessingBg;
  final Color blessingBorder;
  final IconData watermarkIcon;
  final Color sealBorder;
  final Color sealFill;

  static const festive = ShareCardPalette(
    headlineColor: Color(0xFFC41E3A),
    accentColor: Color(0xFFC41E3A),
    bgTop: Color(0xFFFFFBF5),
    bgBottom: Color(0xFFFFF8E7),
    borderColor: Color(0xFFD4AF37),
    blessingBg: Color(0x14C41E3A),
    blessingBorder: Color(0x26C41E3A),
    watermarkIcon: Icons.wb_sunny_outlined,
    sealBorder: Color(0xFFC41E3A),
    sealFill: Color(0x14C41E3A),
  );

  /// 清明/中元/寒衣等：灰青渐变，无喜庆朱红。
  static const solemn = ShareCardPalette(
    headlineColor: Color(0xFF4A5F6A),
    accentColor: Color(0xFF5A6B7A),
    bgTop: Color(0xFFF2F5F7),
    bgBottom: Color(0xFFE4EAED),
    borderColor: Color(0xFF8FA3AD),
    blessingBg: Color(0x145A6B7A),
    blessingBorder: Color(0x265A6B7A),
    watermarkIcon: Icons.nature_outlined,
    sealBorder: Color(0xFF5A6B7A),
    sealFill: Color(0x145A6B7A),
  );

  factory ShareCardPalette.forModel({required bool solemn}) =>
      solemn ? ShareCardPalette.solemn : ShareCardPalette.festive;
}
