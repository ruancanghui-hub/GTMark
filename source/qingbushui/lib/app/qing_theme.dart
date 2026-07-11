import 'package:flutter/material.dart';

class WtColors {
  static const blueLight = Color(0xFF4FC3F7);
  static const blueMid = Color(0xFF1E88E5);
  static const blueDark = Color(0xFF0D47A1);
  static const blueDeep = Color(0xFF1565C0);
  static const greenHandle = Color(0xFF4CAF50);
  static const notificationGreen = Color(0xFF66BB6A);
  static const textDark = Color(0xFF212121);
  static const textMuted = Color(0xFF757575);

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blueLight, blueMid, blueDark],
  );

  static const buttonGradient = LinearGradient(colors: [blueMid, blueDeep]);

  static const nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A1A3A), Color(0xFF1A237E)],
  );
}

class QwColors {
  static const skyTop = Color(0xFF2F96FF);
  static const skyMid = Color(0xFF8DCDFF);
  static const skyMist = Color(0xFFEAF7FF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceBlue = Color(0xFFEAF5FF);
  static const primary = Color(0xFF3D95F7);
  static const primaryDeep = Color(0xFF2366E8);
  static const aqua = Color(0xFF61D8FF);
  static const mint = Color(0xFF6BE4C4);
  static const ink = Color(0xFF172033);
  static const muted = Color(0xFF8FA0B8);
  static const line = Color(0xFFE4EEF8);
}

class QwGradients {
  static const sky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      QwColors.skyTop,
      QwColors.skyMid,
      QwColors.skyMist,
      QwColors.surface,
    ],
    stops: [0, 0.32, 0.68, 1],
  );

  static const primary = LinearGradient(
    colors: [QwColors.aqua, QwColors.primary, QwColors.primaryDeep],
  );

  static const card = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF62CBFF), QwColors.primary, QwColors.primaryDeep],
  );
}

class QingTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    primaryColor: QwColors.primary,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: QwColors.primary,
      primary: QwColors.primary,
      surface: QwColors.surface,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    primaryColor: WtColors.blueMid,
    scaffoldBackgroundColor: WtColors.blueDark,
    fontFamily: 'Roboto',
  );
}
