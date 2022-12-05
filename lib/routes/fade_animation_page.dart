import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PageRoute<T> FadeAnimationPageRoute<T>(
    {required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
    bool maintainState = true}) {
  return PageRouteBuilder(
      pageBuilder: (context, a, b) => builder(context),
      settings: settings,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
      barrierDismissible: false,
      opaque: true,
      transitionsBuilder: (context, a1, b, page) {
        var curveTween = CurveTween(curve: Curves.easeIn);
        return FadeTransition(opacity: a1.drive(curveTween), child: page);
      });
}

class FadeAnimationPage<T> extends Page<T> {
  final Widget child;
  final String? route;

  const FadeAnimationPage(
      {super.key,
      super.name,
      super.arguments,
      required this.child,
      this.route,
      super.restorationId});

  Route<T> createRoute(BuildContext context) {
    return FadeAnimationPageRoute(
      builder: (context) => child,
      fullscreenDialog: false,
      maintainState: true,
      settings: this,
    );
  }
}
