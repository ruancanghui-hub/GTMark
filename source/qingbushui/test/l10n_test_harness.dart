import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qingbushui/l10n/app_locale.dart';
import 'package:qingbushui/l10n/app_localizations.dart';

/// Wraps widgets under test with app localizations.
Widget l10nTestApp(Widget home, {AppLocale locale = AppLocale.en}) {
  return MaterialApp(
    locale: locale.flutterLocale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: home,
  );
}

/// Pumps [home] and waits for localization delegates to resolve.
Future<void> pumpL10nApp(
  WidgetTester tester,
  Widget home, {
  AppLocale locale = AppLocale.en,
}) async {
  await tester.pumpWidget(l10nTestApp(home, locale: locale));
  await tester.pump();
}
