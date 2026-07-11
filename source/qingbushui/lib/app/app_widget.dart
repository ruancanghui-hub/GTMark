import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/hydration/hydration_store.dart';
import 'qing_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: HydrationStore.themeListenable,
      builder: (context, _) {
        return MaterialApp.router(
          title: '轻补水',
          debugShowCheckedModeBanner: false,
          theme: QingTheme.light,
          darkTheme: QingTheme.dark,
          themeMode: HydrationStore.currentThemeMode(),
          routerConfig: Modular.routerConfig,
        );
      },
    );
  }
}
