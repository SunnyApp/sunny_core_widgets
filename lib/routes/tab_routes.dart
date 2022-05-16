import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sunny_core_widgets/routes/nested_navigation.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';
import 'package:sunny_fluro/sunny_fluro.dart';
import 'package:sunny_sdk_core/model_exports.dart';

import 'key_args.dart';
import 'modals.dart';
import 'routing.dart';

extension AppRouteNavigationExtension<R, P extends RouteParams>
    on AppRoute<R, P> {
  Future<R?> modalNested(BuildContext context, {P? args}) async {
    if (this is AppPageRoute<R, P>) {
      final ar = this as AppPageRoute<R, P>;
      return nestedModal<R>(context, (context) {
        return ar.handleAny(context, args);
      }, settings: null);
    }
    return go(context, args: args ?? const DefaultRouteParams() as P);
  }

  Future<R?> openModal(
    BuildContext context, {
    bool useScaffold = true,
    P? args,
    ModalArgsBuilder<P>? argsBuilder,
    bool displayTitle = true,
    dynamic extraOptions,
    bool expand = true,
    bool showHandle = true,
    Color? backgroundColor,
    bool dismissible = true,
    String? label,
    bool replace = false,
    ModalConstraints? constraints,
    bool nestModals = false,
    bool useRootNavigator = true,
  }) async {
    final _args = args ?? argsBuilder?.call(null);
    if (this is AppPageRoute<R, P>) {
      final ar = this as AppPageRoute<R, P>;
      return await Modals.open<R>(
        context,
        useScaffold: useScaffold,
        backgroundColor: backgroundColor,
        displayDragHandle: showHandle,
        dismissible: dismissible,
        draggable: dismissible,
        extraOptions: extraOptions,
        displayTitle: displayTitle,
        nestModals: nestModals,
        useRootNavigator: useRootNavigator,
        expand: expand,
        settings: PathRouteSettings.ofAppRoute(ar, routeParams: _args),
        constraints: constraints,
        builder: memoizeScrollBuild(
          (context) {
            final _args = args ?? argsBuilder?.call(null);
            return ar.handleAny(context, _args);
          },
        ),
      );
    } else {
      return await go(context, args: _args);
    }
  }

  Future<R?> openNestedModal(
    BuildContext context, {
    P? args,
    ModalArgsBuilder<P>? argsBuilder,
    dynamic extraOptions,
    bool showHandle = true,
    bool expand = true,
    String? label,
    bool replace = false,
    bool useRootNavigator = true,
  }) async {
    final _args = args ?? argsBuilder?.call(null);
    if (this is AppPageRoute<R, P>) {
      final ar = this as AppPageRoute<R, P>;
      return await Modals.open<R>(
        context,
        useScaffold: true,
        // backgroundColor: backgroundColor,
        displayDragHandle: showHandle,
        dismissible: false,
        draggable: true,
        extraOptions: extraOptions,
        displayTitle: false,
        nestModals: true,
        useRootNavigator: useRootNavigator,
        expand: expand,
        settings: PathRouteSettings.ofAppRoute(ar, routeParams: _args),
        builder: (context) {
          final _args = args ?? argsBuilder?.call(null);
          return ar.handleAny(context, _args);
        },
      );
    } else {
      return await go(context, args: _args);
    }
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
  Future<R?> goToRecord(BuildContext context, MSchemaRef ref, String id,
      {Map<String, dynamic>? others, T? record}) async {
    return this.go(
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
    String? name,
    required WidgetHandler<dynamic, TabRouteArgs> handler,
  }) =>
      defineWithParams<dynamic, TabRouteArgs>(
        route,
        handler: handler,
        name: name,
        paramConverter: TabRouteArgs.of,
      );

  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
  AppRoute<R, ScrollerArgs> defineScroll<R>(String routePath,
      {String? name,
      required WidgetHandler<R, ScrollerArgs> handler,
      TransitionType? transitionType}) {
    return register<R, ScrollerArgs, AppPageRoute<R, ScrollerArgs>>(
      AppPageRoute(routePath, handler, (_) => ScrollerArgs.from(_),
          name: name,
          transitionType: transitionType,
          toRouteUri: (settings) => routePath),
    );
  }
}

/// Passes the ScrollController to the route args
typedef ModalArgsBuilder<P extends RouteParams> = P Function(
    ScrollController? controller);

class TabRouteArgs extends DefaultRouteParams implements InternalArgs {
  final ScrollController? scroller;

  static TabRouteArgs of(final args) {
    if (args == null) return TabRouteArgs(null);
    if (args is TabRouteArgs) {
      return args;
    } else if (args is RouteParams) {
      return TabRouteArgs(args["scroller"] as ScrollController?);
    } else if (args is Map<String, dynamic>) {
      return TabRouteArgs(args["scroller"] as ScrollController?);
    } else {
      return illegalState("Invalid args: ${args?.runtimeType ?? 'null'}");
    }
  }

  TabRouteArgs(this.scroller) : super({"scroller": scroller});
}

extension AppRouteMatchGoExtension on AppRouteMatch {
  Future<R?> go<R, P extends RouteParams>(BuildContext context,
      {P? args, bool replace = false, bool useRootNavigator = false}) async {
    final dynamic rtn = await this.route.go(context,
        args: args, replace: replace, useRootNavigator: useRootNavigator);
    return rtn as R?;
  }
}

extension AppRouteGoNavigationExtension<R, P extends RouteParams>
    on AppRoute<R, P>? {
  Future<R?> go(
    BuildContext context, {
    P? args,
    bool replace = false,
    bool useRootNavigator = false,
    bool nestModals = false,
    NavigatorState? navigator,
  }) async {
    final routes = SunnyRouting.router;
    if (R == dynamic) {
      return (await routes.navigateToDynamicRoute(
        context,
        this,
        replace: replace,
        parameters: args ?? (const DefaultRouteParams()),
        rootNavigator: useRootNavigator,
        navigator: navigator,
      )) as R?;
    } else {
      return routes.navigateToRoute<R, P>(
        context,
        this!,
        replace: replace,
        parameters: args ?? const DefaultRouteParams() as P,
        rootNavigator: useRootNavigator,
        navigator: navigator,
      );
    }
  }
}
