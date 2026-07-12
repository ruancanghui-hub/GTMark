import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/hydration/hydration_store.dart';
import '../l10n/app_locale.dart';
import '../l10n/app_localizations.dart';
import 'qing_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        HydrationStore.themeListenable,
        HydrationStore.localeListenable,
      ]),
      builder: (context, _) {
        final locale = HydrationStore.currentLocale();
        return MaterialApp.router(
          title: locale == AppLocale.zh ? '轻补水' : 'Qing Water',
          debugShowCheckedModeBanner: false,
          theme: QingTheme.light,
          darkTheme: QingTheme.dark,
          themeMode: HydrationStore.currentThemeMode(),
          locale: locale.flutterLocale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: Modular.routerConfig,
        );
      },
    );
  }
}
