import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  bool _navigated = false;

  Future<void> finish() async {
    if (_navigated) return;
    _navigated = true;
    Modular.to.navigate(AppRoutes.main);
  }
}
