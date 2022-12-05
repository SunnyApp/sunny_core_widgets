import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:sunny_core_widgets/layouts/build_context_layout_ext.dart';
import 'package:sunny_core_widgets/routes/path_route_settings.dart';
import 'package:sunny_essentials/platform/modal_options.dart';
import 'package:sunny_sdk_core/api_exports.dart';

import 'modals.dart';
import 'nested_navigation.dart';

//
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
      builder: memoizeScrollBuild(toWidget),
    );
  }

  Widget toWidget(BuildContext context, {RootStackRouter? router}) {
    var next = context.router;
    router ??= context.router.root as RootStackRouter;
    var match = router.matcher.matchByRoute(this);
    if (match == null) {
      throw ArgumentError('Cannot match route: $routeName');
    }
    var pageFactory = router.pagesMap[routeName] ??
        illegalState('Pag factory not found for $routeName');

    var page = pageFactory!(RouteData(
        route: match, router: router, pendingChildren: match.children ?? []));
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
    return PathRouteSettings(route: this.path, label: this.routeName);
  }
}
