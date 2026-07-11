import 'package:flutter/widgets.dart';

/// 路由栈追踪（自参考工程迁移；用于按 name 关闭等扩展）。
class AppService {
  final List<String> openedRoutes = [];
  final List<Route<dynamic>> routeTree = [];

  void addRoute(Route<dynamic> route) {
    final name = route.settings.name;
    if (name != null) {
      openedRoutes.add(name);
      routeTree.add(route);
    }
  }

  void removeRoute(Route<dynamic> route) {
    final name = route.settings.name;
    if (name != null) {
      openedRoutes.remove(name);
      routeTree.remove(route);
    }
  }

  bool isOpened(String name) {
    return openedRoutes.contains(name);
  }

  List<Route<dynamic>> getRoute(String name) {
    return routeTree.where((r) => r.settings.name == name).toList();
  }

  void closeRouteByName(String name, NavigatorState? navigator) {
    final routes = getRoute(name);
    for (final route in routes) {
      navigator?.removeRoute(route);
      openedRoutes.remove(name);
      routeTree.remove(route);
    }
  }
}
