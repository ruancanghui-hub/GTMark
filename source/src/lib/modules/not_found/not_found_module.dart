import 'package:flutter_modular/flutter_modular.dart';

import 'not_found_page.dart';

class NotFoundModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (context) => const NotFoundPage());
  }
}
