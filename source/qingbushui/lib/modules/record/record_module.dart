import 'package:flutter_modular/flutter_modular.dart';
import 'record_page.dart';

class RecordModule extends Module {
  @override
  void routes(r) {
    r.child('/add', child: (_) => const RecordPage());
  }
}
