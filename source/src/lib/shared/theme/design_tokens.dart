import 'package:flutter/material.dart';

/// 设计令牌，与 [docs/ds.json] 同步（FD Project Management 深色 + 紫主色）。
abstract final class DsColors {
  /// 画布 / scaffold（参考工程 canvasColor）
  static const Color bgPrimary = Color(0xFF1F1D2C);

  /// 卡片（参考工程 cardColor 38,40,55）
  static const Color bgCard = Color(0xFF262837);

  /// 悬停 / 选中底
  static const Color bgHover = Color(0xFF323548);

  static const Color borderDefault = Color(0xFF3D4055);

  static const Color textPrimary = Color(0xFFFAFAFA);

  /// 对齐参考工程 `kFontColorPallets[1]`（210,210,210）
  static const Color textSecondary = Color(0xFFD2D2D2);

  /// 对齐参考工程 `kFontColorPallets[2]`（170,170,170）
  static const Color textMuted = Color(0xFFAAAAAA);

  /// 主强调（参考 primary 128,109,255）；沿用 [accentBlue] 名以减少全库重命名。
  static const Color accentBlue = Color(0xFF806DFF);

  static const Color accentPurple = Color(0xFF9F54FC);
  static const Color accentPink = Color(0xFFFF6B9D);

  static const Color primaryDark = Color(0xFF6F58FF);
}

/// ds.json spacing（FD 基准间距 20 见 [DsSpacing.shell]）
abstract final class DsSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;

  /// FD `kSpacing`
  static const double shell = 20;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

/// ds.json radius（FD 大圆角 20）
abstract final class DsRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;

  /// FD `kBorderRadius` 卡片 / 壳层
  static const double xl = 20;
  static const double full = 9999;
}

/// 动效时长
abstract final class DsMotion {
  static const Duration microInteraction = Duration(milliseconds: 200);
}

/// 品牌渐变（紫系，对齐 FD）
abstract final class DsGradients {
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      DsColors.primaryDark,
      DsColors.accentBlue,
      DsColors.accentPurple,
    ],
    stops: <double>[0, 0.5, 1],
  );
}

/// 宽屏三栏断点（逻辑像素）
abstract final class DsBreakpoints {
  static const double wideShell = 1100;
}

/// 字号与行高倍数，与 [docs/ds.json] typography 一致（FD + 移动端可读性）。
abstract final class DsTypography {
  static const double lineHeightHero = 1.1;
  static const double lineHeightHeading = 1.2;
  static const double lineHeightBody = 1.6;
  static const double lineHeightTight = 1.35;

  static const double hero = 72;
  static const double h1 = 48;
  static const double h2 = 36;
  static const double h3 = 24;

  static const double bodyLg = 18;
  static const double body = 16;
  static const double sm = 14;

  /// 辅助说明、标签
  static const double caption = 12;

  /// 极密区域（日历格脚等），较原 9/10pt 略放大
  static const double micro = 11;
  static const double calendarCaption = 12;

  /// 宽屏壳层标题 / 导航项（对齐 FD 视觉权重）
  static const double shellTitle = 20;
  static const double shellNavLabel = 15;

  /// 列表/区块标题（介于 [h3] 与正文之间）
  static const double headlineMinor = 22;
}
