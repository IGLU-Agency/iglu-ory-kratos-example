/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

import 'package:flutter/material.dart';

class Nav {
  static Future push(
    BuildContext context, {
    required Widget screen,
    RouteSettings? settings,
    bool root = false,
    bool fullScreen = false,
    String? name,
  }) async {
    return Navigator.of(
      context,
      rootNavigator: fullScreen,
    ).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        fullscreenDialog: fullScreen,
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
        transitionDuration: const Duration(milliseconds: 300),
        settings: RouteSettings(name: name ?? screen.toString()),
      ),
    );
  }

  static Future pushReplacement(
    BuildContext context, {
    required Widget screen,
    RouteSettings? settings,
    bool root = false,
    bool fullScreen = false,
    String? name,
  }) async {
    return Navigator.of(
      context,
      rootNavigator: fullScreen,
    ).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        fullscreenDialog: fullScreen,
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
        transitionDuration: const Duration(milliseconds: 300),
        settings: RouteSettings(name: name ?? screen.toString()),
      ),
    );
  }
}

class CustomPageRoute<T> extends PageRoute<T> {
  CustomPageRoute(this.child);
  @override
  Color get barrierColor => Colors.black;

  @override
  String? get barrierLabel => null;

  final Widget child;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}
