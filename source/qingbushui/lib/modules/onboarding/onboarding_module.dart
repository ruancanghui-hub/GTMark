import 'package:flutter_modular/flutter_modular.dart';
import 'onboarding_page.dart';

class OnboardingModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const OnboardingPage());
  }
}
