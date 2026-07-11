import 'package:flutter_modular/flutter_modular.dart';
import 'main_page.dart';

class MainModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const MainPage());
  }
}
