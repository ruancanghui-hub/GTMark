import 'package:flutter_modular/flutter_modular.dart';

import 'drink_select_page.dart';
import 'slide_drink_page.dart';

class DrinkModule extends Module {
  @override
  void routes(r) {
    r.child('/select', child: (_) => const DrinkSelectPage());
    r.child('/slide', child: (_) => const SlideDrinkPage());
  }
}
