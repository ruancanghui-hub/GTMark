import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'jichen_tokens.dart';
import 'lianji_typography.dart';

abstract final class JichenTheme {
  static ThemeData get light {
    const ink = JichenTokens.labelPrimary;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: JichenTokens.canvas,
      colorScheme: ColorScheme.light(
        primary: JichenTokens.accent,
        surface: JichenTokens.surface,
        onSurface: ink,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: JichenTokens.canvas,
        foregroundColor: ink,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: JichenTokens.surface,
        selectedItemColor: JichenTokens.accent,
        unselectedItemColor: JichenTokens.labelSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      textTheme: LianjiTypography.textTheme(ink: ink),
      dividerColor: JichenTokens.separator,
    );
  }
}
