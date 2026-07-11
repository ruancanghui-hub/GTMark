import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/qing_theme.dart';
import '../../core/hydration/hydration_store.dart';
import '../../shared/visuals/qw_water_bottle_hero.dart';
import '../../shared/widgets/qw_screen_shell.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.redirectOnReady = true});

  final bool redirectOnReady;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    if (!widget.redirectOnReady) return;
    Future.delayed(const Duration(milliseconds: 600), () {
      final store = HydrationStore.of();
      if (store.profile?.onboardingDone == true) {
        Modular.to.navigate('/main/');
      } else {
        Modular.to.navigate('/onboarding/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QwScreenShell(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QwWaterBottleHero(progress: 0.62, size: 190),
              SizedBox(height: 22),
              Text(
                'Qing Water',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Hydrate gently',
                style: TextStyle(
                  color: QwColors.surface,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
