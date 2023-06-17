import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:sunny_core_widgets/layouts/build_context_layout_ext.dart';
import 'package:sunny_core_widgets/routes/path_route_settings.dart';
import 'package:sunny_essentials/platform/modal_options.dart';
import 'package:sunny_essentials/theme.dart';
import 'package:sunny_sdk_core/api_exports.dart';

import 'modals.dart';
import 'nested_navigation.dart';

extension AutoRouteInfoExt<T> on PageRouteInfo<T> {
  Future<R?> openModal<R>(
    BuildContext context, {
    bool useScaffold = true,
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
      settings: routeSettings,
      constraints: constraints,
      builder: memoizeScrollBuild((context) => toWidget(
            context,
            useRootRouter: useRootNavigator,
          )),
    );
  }

  Widget toWidget(BuildContext context,
      {StackRouter? router, bool useRootRouter = false}) {
    /// Start with self, and walk backwards looking for an AutoRouter that handles

    RoutingController? tmpRouter = router ?? context.router;
    final root = tmpRouter.root as RootStackRouter;
    RouteMatch? match;
    final attempts = <RoutingController>[];
    while (match == null && tmpRouter != null) {
      attempts.add(tmpRouter);

      match = tmpRouter.matcher.matchByRoute(this);
      if (match == null) tmpRouter = tmpRouter.parent<RoutingController>();
    }

    if (match == null) {
      throw ArgumentError(
          'Cannot match route: $routeName: checked: ${attempts.map((e) => e.key)}');
    }
    var pageFactory = root.pagesMap[routeName] ??
        illegalState('Page factory not found for $routeName');

    var page = pageFactory!(
      RouteData(
        type: RouteType.adaptive(),
        stackKey: ValueKey('global'),
        route: match,
        router: tmpRouter!,
        pendingChildren: match.children ?? [],
      ),
    );
    if (page is AutoRoutePage) {
      return page.buildPage(context);
    } else if (page is MaterialPage) {
      return page.child;
    } else if (page is CupertinoPage) {
      return page.child;
    } else {
      return illegalState(
          'Cannot get widget from page of type ${page.runtimeType}');
    }
  }

  PathRouteSettings get routeSettings {
    return PathRouteSettings(route: this.routeName, label: this.fragment);
    // return PathRouteSettings(route: this.path, label: this.routeName);
  }
}
