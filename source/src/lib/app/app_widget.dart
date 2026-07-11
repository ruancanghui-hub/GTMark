import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/ads/admob_service.dart';
import '../core/navigation/template_route_observer.dart';
import '../core/services/app_service.dart';
import '../l10n/gen/app_localizations.dart';
import '../modules/legal/legal_consent_wrapper.dart';
import '../shared/ui/app_open_ad_gate.dart';
import '../shared/theme/jichen_theme.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Modular.setObservers([TemplateRouteObserver(Modular.get<AppService>())]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '吉辰万年历',
      debugShowCheckedModeBanner: false,
      theme: JichenTheme.light,
      locale: const Locale('zh'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return LegalConsentWrapper(
          onConsentAccepted: () {
            unawaited(AdMobService.instance.start());
          },
          child: AppOpenAdGate(child: child ?? const SizedBox.shrink()),
        );
      },
      routerConfig: Modular.routerConfig,
    );
  }
}
