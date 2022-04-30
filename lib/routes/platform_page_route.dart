import 'package:dartxx/dartxx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:info_x/info_x.dart';

extension TypeToRouteExt on dynamic {
  String toSimpleRoute() {
    final self = this;
    if (self is Type) {
      return "/${self.simpleName.uncapitalize()}";
    } else {
      return "/${this?.toString().uncapitalize()}";
    }
  }
}

/// Creates a platform-appropriate page route.
// ignore: non_constant_identifier_names
PageRoute<T> PlatformPageRoute<T>({
  WidgetBuilder? builder,
  RouteSettings? settings,
  bool maintainState = true,
  bool fullscreenDialog = false,
  bool nonOpaque = true,
  bool forceMaterial = false,
  bool inPageRoute = false,
}) {
  if (inPageRoute == true) {
    return PageRouteBuilder<T>(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return builder!(context);
      },
      settings: settings,
      maintainState: maintainState,
    );
  } else if (infoX.isIOS && nonOpaque) {
    return NonOpaqueCupertinoPageRoute<T>(
        builder: builder!,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog);
  } else if (infoX.isIOS && !forceMaterial) {
    return CupertinoPageRoute<T>(
        builder: builder!,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog);
  } else if (infoX.isMacOS) {
    return PageRouteBuilder(
      settings: settings,
      transitionsBuilder: (context, a1, a2, page) {
        var curveTween = CurveTween(curve: Curves.easeIn);
        return FadeTransition(opacity: a1.drive(curveTween), child: page);
      },
      pageBuilder: (context, animation, animation2) =>
          Builder(builder: builder!),
    );
  } else {
    return MaterialPageRoute<T>(
      builder: builder!,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }
}

/// Creates a platform-appropriate page route.
// ignore: non_constant_identifier_names
//PageRouteBuilder<T> PlatformPageRouteBuilder<T>({
//  RoutePageBuilder pageBuilder,
//  RouteTransitionsBuilder routeTransitionsBuilder,
//  Duration transitionDuration,
//  TransitionType transition,
//  String title,
//  bool opaque = true,
//  RouteSettings settings,
//  bool maintainState = true,
//  bool fullscreenDialog = false,
//}) {
//
//  if (Platform.isIOS) {
//    final tbuilder = transition == TransitionType.dialog ?  FadeUpwardsPageTransitionsBuilder() : CupertinoPageTransitionsBuilder();
//    return PageRouteBuilder<T>(
//        pageBuilder: pageBuilder,
//        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
//
//          return tbuilder.buildTransitions(CupertinoPageRoute(
//            builder: pageBuilder(context)
//          ),
//            BuildContext context,
//            Animation<double> animation,
//            Animation<double> secondaryAnimation,
//            Widget child,)
//        },
//        transitionDuration: transitionDuration,
//        opaque: opaque,
//        settings: settings,
//        maintainState: maintainState);
//  } else {
//    return PageRouteBuilder<T>(
//        pageBuilder: pageBuilder,
//        transitionsBuilder: routeTransitionsBuilder,
//        transitionDuration: transitionDuration,
//        opaque: opaque,
//        settings: settings,
//        maintainState: maintainState);
//  }
//}
//
//enum TransitionType {
//  page,dialog
//}

class NonOpaqueCupertinoPageRoute<T> extends CupertinoPageRoute<T> {
  bool _opaque = true;

  bool get opaque {
    if (_opaque) {
      _opaque = false;
      return true;
    }
    return _opaque;
  }

  NonOpaqueCupertinoPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}

class AdvancedRouteSettings extends RouteSettings {
  final Type? widgetType;
  final String? title;

  /// Creates data used to construct routes.
  AdvancedRouteSettings.fromSettings({
    RouteSettings? other,
    String? nameOverride,
    this.widgetType,
    this.title,
  }) : super(
            name: _calculateRouteName(
                title: title,
                routeName: nameOverride ?? other?.name,
                widgetType: widgetType),
//            isInitialRoute: other?.isInitialRoute ?? false,
            arguments: other?.arguments);

  /// Creates data used to construct routes.
  AdvancedRouteSettings({
    String? name,
    this.title,
    this.widgetType,
    bool isInitialRoute = false,
    arguments,
  }) : super(
            name: _calculateRouteName(
                title: title, routeName: name, widgetType: widgetType),
//            isInitialRoute: isInitialRoute,

            arguments: arguments);
}

String? _calculateRouteName(
    {String? title, String? routeName, Type? widgetType}) {
  return routeName?.toSnakeCase() ??
      widgetType?.simpleName ??
      title?.toSnakeCase();
}
