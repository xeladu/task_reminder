import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) async {
    await navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  void pop() {
    navigatorKey.currentState!.pop();
  }
}
