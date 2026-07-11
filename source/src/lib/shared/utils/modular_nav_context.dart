import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// 无 [BuildContext] 时获取根 Navigator 上下文（用于 Dialog / BottomSheet）。
BuildContext? modularRootContext() {
  return Modular.routerDelegate.navigatorKey.currentContext;
}
