import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:info_x/info_x.dart';

import 'package:responsive_builder/responsive_builder.dart' as rb;
import 'package:sunny_core_widgets/core_ext/layout_info.dart';
import 'package:sunny_core_widgets/routes/platform_page_route.dart';
import 'package:sunny_sdk_core/api_exports.dart';

class PageRoutePaths {
  static const settingsPath = '/settings';

  const PageRoutePaths._();

  static const authPath = '/auth';
  static const loginPath = 'login';
  static const registerPath = 'register';

  static String get fullRegisterPath => '$authPath/$registerPath';
  static String get fullLoginPath => '$authPath/$loginPath';

  static String registerProvider(String providerName) {
    return '$fullRegisterPath/$providerName';
  }

  static String loginProvider(String providerName) {
    return '$fullLoginPath/$providerName';
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

  PageRouteInfo get loginRoute => match(PageRoutePaths.fullLoginPath);
  PageRouteInfo get settingsRoute => match(PageRoutePaths.settingsPath);
  PageRouteInfo get registerRoute {
    var foundMatch = match(PageRoutePaths.fullRegisterPath);
    return foundMatch;
  }

  PageRouteInfo loginProvider(String providerName) =>
      match(PageRoutePaths.loginProvider(providerName));
  PageRouteInfo registerProvider(String providerName) =>
      match(PageRoutePaths.registerProvider(providerName));

  PageRouteInfo match(String uri) {
    var matches = router.root.matcher.match(uri);
    if (matches == null || matches.isEmpty) {
      return illegalState('No route found for $uri');
    } else {
      return matches.first.toPageRouteInfo();
    }
  }

  PageRouteInfo? tryMatch(String? uri) {
    if (uri == null) return null;
    var matches = router.root.matcher.match(uri);
    if (matches == null || matches.isEmpty) {
      return null;
    } else {
      return matches.first.toPageRouteInfo();
    }
  }
}
