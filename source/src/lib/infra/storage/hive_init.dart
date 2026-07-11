import 'package:hive_flutter/hive_flutter.dart';

/// 吉辰万年历 Hive 初始化（Phase 0 精简：不加载链记业务 Box）。
Future<void> initHive() async {
  await Hive.initFlutter();
}
