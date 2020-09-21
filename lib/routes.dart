import 'package:flutter/material.dart';
import 'package:grocery_manager/login.dart';

class Routes {
  static dynamic goToRoute(RouteSettings routeSettings) {
    final dynamic routeArgs = routeSettings.arguments;

    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Login());
        break;
      case '/user_details':
        return MaterialPageRoute(
          builder: (_) => Container(),
        );
        break;
    }
  }
}
