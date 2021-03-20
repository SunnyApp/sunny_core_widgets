import 'package:flutter/widgets.dart';
import 'package:sunny_fluro/sunny_fluro.dart';
import 'package:responsive_builder/responsive_builder.dart' as rb;
import 'package:sunny_core_widgets/core_ext/layout_info.dart';
import 'package:sunny_core_widgets/routes/platform_page_route.dart';
import 'package:sunny_core_widgets/routes/routing.dart';
import 'package:sunny_sdk_core/api_exports.dart';
import 'package:sunny_dart/sunny_get.dart';

class RouteExtensions {}

extension AppRouteExtension on AppRoute {
  String? routeUriForId(key) {
    if (key is MKey) {
      key = key.mxid;
    } else if (key is RecordKey) {
      key = key.mxid;
    } else {
      key = "$key";
    }
    return routeUri({"id": key});
  }
}

extension AppRouteMatchExtensions on AppRouteMatch {
  Future go(BuildContext context) {
    return SunnyRouting.router.navigateToDynamicRoute(context, this.route,
        parameters: this.parameters);
  }
}

extension BuildContextDeviceScreenTypeExt on BuildContext {
  LayoutInfo get layoutInfo => sunny.get(context: this);
  rb.DeviceScreenType get screenType => layoutInfo.screenType;
  Future<T?> page<T>(WidgetBuilder builder) {
    var navigatorState = Navigator.of(this);
    return navigatorState.push<T>(PlatformPageRoute(
      builder: builder,
      maintainState: true,
    ));
  }
}
