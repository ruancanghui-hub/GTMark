import 'package:flutter_modular/flutter_modular.dart';

import '../core/services/app_service.dart';
import '../modules/main/main_module.dart';
import '../modules/not_found/not_found_module.dart';
import '../modules/splash/splash_module.dart';
import 'routes/app_routes.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(AppService.new);
  }

  @override
  void routes(r) {
    r.redirect('/', to: AppRoutes.splash);
    r.module('/splash', module: SplashModule());
    r.module('/main', module: MainModule());
    r.module('/404', module: NotFoundModule());
  }
}
