import 'package:flutter/material.dart';
import 'package:sunny_core_widgets/routes/nested_navigation.dart';
import 'package:sunny_dart/helpers/functions.dart';
import 'package:sunny_fluro/sunny_fluro.dart';
import 'package:sunny_sdk_core/model_exports.dart';

import 'key_args.dart';
import 'routing.dart';

extension AppRouteNavigationExtension<R, P extends RouteParams>
    on AppRoute<R, P> {
  Future<R> modalNested(BuildContext context, {P args}) async {
    if (this is AppPageRoute<R, P>) {
      final ar = this as AppPageRoute<R, P>;
      return nestedModal<R>(context, (context) {
        return ar.handleAny(context, args);
      }, settings: null);
    }
    return go(context, args: args);
  }

  Future<R> openModal(
    BuildContext context, {
    P args,
    ModalArgsBuilder<P> argsBuilder,
    bool expand = true,
    bool showHandle = true,
    String label,
    bool replace = false,
    bool nestModals = false,
  }) async {
    final _args = args ?? argsBuilder?.call(null);
    if (this is AppPageRoute<R, P>) {
      final ar = this as AppPageRoute<R, P>;
      return await modal<R>(
        context,
        displayDragHandle: showHandle,
        builder: memoizeScrollBuild(
          (context) {
            final _args = args ?? argsBuilder?.call(null);
            return ar.handleAny(context, _args);
          },
        ),
        expand: expand,
        settings: PathRouteSettings.ofAppRoute(ar, routeParams: _args),
        nestModals: nestModals,
      );
    }

    return await go(context, args: _args);
  }

  // Route<R> toRoute([P params]) {
  //   final AppRoute<R, P> self = this;
  //   final creator =
  //       SunnyRouting.router.routeFactory.generate<R, P>(self, null, null, null);
  //   return creator(self.route, params);
  // }
}

extension RouteCast on Route {
  Route<T> cast<T>() => this as Route<T>;
}

extension AppRouteKeyNavExtension<R, T> on AppRoute<R, KeyArgs<T>> {
  Future<R> goToRecord(BuildContext context, MSchemaRef ref, String id,
      {Map<String, dynamic> others, T record}) async {
    return go(
      context,
      args: KeyArgs<T>.fromId(ref, id, args: others, record: record),
    );
  }
}

WidgetHandler<R, P> simple<R, P>(Widget builder()) {
  return (_, __) => builder();
}

extension TabPageExt on FRouter {
  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
  AppRoute<dynamic, TabRouteArgs> tabPage(
    String route, {
    String name,
    WidgetHandler<dynamic, TabRouteArgs> handler,
  }) =>
      defineWithParams<dynamic, TabRouteArgs>(
        route,
        handler: handler,
        name: name,
        paramConverter: TabRouteArgs.of,
      );

  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
  AppRoute<R, ScrollerArgs> defineScroll<R>(String routePath,
      {String name,
      @required WidgetHandler<R, ScrollerArgs> handler,
      TransitionType transitionType}) {
    return register<R, ScrollerArgs>(
      AppPageRoute(routePath, handler, (_) => ScrollerArgs.from(_),
          name: name,
          transitionType: transitionType,
          toRouteUri: (settings) => routePath),
    );
  }
}

/// Passes the ScrollController to the route args
typedef ModalArgsBuilder<P extends RouteParams> = P Function(
    ScrollController controller);

class TabRouteArgs extends DefaultRouteParams implements InternalArgs {
  final ScrollController scroller;

  static TabRouteArgs of(final args) {
    if (args == null) return null;
    if (args is TabRouteArgs) {
      return args;
    } else if (args is RouteParams) {
      return TabRouteArgs(args["scroller"] as ScrollController);
    } else if (args is Map<String, dynamic>) {
      return TabRouteArgs(args["scroller"] as ScrollController);
    } else {
      return illegalState("Invalid args: ${args?.runtimeType ?? 'null'}");
    }
  }

  TabRouteArgs(this.scroller) : super({"scroller": scroller});
}

extension AppRouteMatchGoExtension on AppRouteMatch {
  Future<R> go<R, P extends RouteParams>(BuildContext context,
      {P args, bool replace = false, bool useRootNavigator = false}) async {
    final rtn = await this.route.go(context,
        args: args, replace: replace, useRootNavigator: useRootNavigator);
    return rtn as R;
  }
}

extension AppRouteGoNavigationExtension<R, P extends RouteParams>
    on AppRoute<R, P> {
  Future<R> go(
    BuildContext context, {
    P args,
    bool replace = false,
    bool useRootNavigator = false,
    bool nestModals = false,
  }) async {
    final routes = SunnyRouting.router;
    if (R == dynamic) {
      return (await routes.navigateToDynamicRoute(context, this,
          replace: replace,
          parameters: args,
          rootNavigator: useRootNavigator)) as R;
    } else {
      return routes.navigateToRoute(context, this,
          replace: replace, parameters: args, rootNavigator: useRootNavigator);
    }
  }
}
