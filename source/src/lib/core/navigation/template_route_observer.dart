import 'package:flutter/widgets.dart';

import '../services/app_service.dart';

/// 与参考工程中 GetObserver 等价：同步路由栈到 [AppService]。
class TemplateRouteObserver extends NavigatorObserver {
  TemplateRouteObserver(this._appService);

  final AppService _appService;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      _appService.addRoute(route);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      _appService.removeRoute(route);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      _appService.removeRoute(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute?.settings.name != null) {
      _appService.removeRoute(oldRoute!);
    }
    if (newRoute?.settings.name != null) {
      _appService.addRoute(newRoute!);
    }
  }
}
