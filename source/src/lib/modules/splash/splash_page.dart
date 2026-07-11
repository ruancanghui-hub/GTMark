import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lianji/l10n/gen/app_localizations.dart';

import '../../shared/theme/jichen_tokens.dart';
import 'splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(SplashController());
    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) unawaited(_controller.finish());
    });
  }

  @override
  void dispose() {
    Get.delete<SplashController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: JichenTokens.canvas,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/brand/ip_deer.png',
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.appTitle,
                style: context.jichenDisplay(color: JichenTokens.accent),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.splashTagline,
                textAlign: TextAlign.center,
                style: context.jichenBody(color: JichenTokens.labelSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
