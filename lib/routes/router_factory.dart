import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:sunny_core_widgets/provided.dart';
import 'package:sunny_core_widgets/routes/nested_navigation.dart';
import 'package:sunny_core_widgets/routes/platform_page_route.dart';

final _log = Logger("routes");

class SunnyRouterFactory implements RouterFactory {
  final bool allowNestedModals;
  const SunnyRouterFactory({this.allowNestedModals = false});

  @override
  RouteCreator<R, P> generate<R, P extends RouteParams>(
      AppRoute<R, P> appRoute,
      TransitionType transition,
      Duration transitionDuration,
      transitionsBuilder) {
    return (name, params) {
      _log.info("Creating route for ${appRoute} using ${params}");
      if (appRoute is CompletableAppRoute<R, P>) {
        _log.info(" [${appRoute.route}] is CompletableRoute");
        return CompletableRouteAdapter<R>((context) {
          return appRoute.handleAny(context, params,
              (context, appRoute, params) {
            final c = generateAny(appRoute, TransitionType.native,
                Duration(milliseconds: 300), null);
            final route = c(appRoute.routeTitle(params), params);
            return Navigator.of(context).push(route);
          }).then((_) => _ as R);
        });
      } else if (appRoute is AppPageRoute<R, P>) {
        _log.info(" [${appRoute.route}] is AppPageRoute");
        final routeSettings = PathRouteSettings.ofAppRoute(
          appRoute,
          routeParams: params,
        );
        // ignore: missing_required_param
        return PlatformPageRoute<R>(
          settings: routeSettings,
          builder: (context) {
            /// Do we support nested navigation?
            if (allowNestedModals) {
              /// Previous behavior
              final nn = Provided.find<NestedNavigatorContainer>(context);
              final navState = nestedGlobalKey.currentState;
              Widget _p;
              if (nn != null) {
                return _p ??= appRoute.handle(context, params);
              }
            }
            return appRoute.handleAny(context, params);
          },
          fullscreenDialog: transition == TransitionType.nativeModal,
        );
      } else {
        throw "Invalid route type ${appRoute?.runtimeType}";
      }
    };
  }

  @override
  RouteCreator generateAny(AppRoute appRoute, TransitionType transition,
      Duration transitionDuration, transitionsBuilder) {
    return generate<dynamic, RouteParams>(
        appRoute, transition, transitionDuration, transitionsBuilder);
  }
}
