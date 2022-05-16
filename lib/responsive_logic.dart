// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:info_x/sunny_get.dart';
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;
import 'package:sunny_essentials/sunny_essentials.dart';
import 'package:sunny_essentials/widget_wrapper.dart';

import 'core_ext/layout_info.dart';

class ResponsiveSwitcher extends StatelessWidget {
  final WidgetBuilder mobile;
  final WidgetBuilder desktop;

  const ResponsiveSwitcher(
      {Key? key, required this.mobile, required this.desktop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, layout) {
      return layout.isSmall ? mobile(context) : desktop(context);
    });
  }
}

typedef List<Widget> WidgetListBuilder(BuildContext context);

///
/// Does runtime analysis to determine whether to build any of the provided
/// widgets.
List<Widget> OptionalBuilder(
  BuildContext context, {
  WidgetBuilder? mobile,
  WidgetBuilder? tablet,
  WidgetBuilder? desktop,
  WidgetListBuilder? desktops,
}) =>
    ResponsiveList<Widget>(
      context,
      mobile: mobile,
      desktop: desktop,
      tablet: tablet,
      desktops: desktops,
    );

T ForScreenSize<T>(
  BuildContext context, {
  T? mobile,
  T? tablet,
  T? desktop,
  T? defaultValue,
}) {
  final layoutInfo = sunny.get<LayoutInfo>(context: context);
  switch (layoutInfo.screenType) {
    case DeviceScreenType.mobile:
      return mobile ?? defaultValue as T;
    case DeviceScreenType.tablet:
      return tablet ?? desktop ?? defaultValue as T;
    case DeviceScreenType.desktop:
      return desktop ?? defaultValue as T;
    case DeviceScreenType.watch:
      return defaultValue as T;

    default:
      return defaultValue as T;
  }
}

WidgetWrapper restOfScreen(BuildContext context) {
  return (child) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: child,
    );
  };
}

Widget returnChild(Widget child) => child;
Widget ResponsiveWrap(
  BuildContext context, {
  required Widget child,
  WrapWidget? mobile,
  WrapWidget? tablet,
  WrapWidget? desktop,
  WrapWidget defaultValue = returnChild,
}) {
  var wrapper = ResponsiveWrapper(
    context,
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
    defaultValue: defaultValue,
  );
  return wrapper(child);
}

WrapWidget ResponsiveWrapper(
  BuildContext context, {
  WrapWidget? mobile,
  WrapWidget? tablet,
  WrapWidget? desktop,
  WrapWidget defaultValue = returnChild,
}) {
  final layoutInfo = sunny.get<LayoutInfo>(context: context);
  switch (layoutInfo.screenType) {
    case DeviceScreenType.mobile:
      return mobile ?? defaultValue;
    case DeviceScreenType.tablet:
      return tablet ?? desktop ?? defaultValue;
    case DeviceScreenType.desktop:
      return desktop ?? defaultValue;
    case DeviceScreenType.watch:
      return defaultValue;

    default:
      return defaultValue;
  }
}

typedef ResponsiveExpression<R> = R Function(BuildContext context);
typedef ResponsiveListExpression<R> = List<R> Function(BuildContext context);

List<R> ResponsiveList<R>(
  BuildContext context, {
  ResponsiveExpression<R>? mobile,
  ResponsiveExpression<R>? tablet,
  ResponsiveExpression<R>? desktop,
  ResponsiveListExpression<R>? desktops,
  ResponsiveListExpression<R>? tablets,
}) {
  if (mobile == null && desktop == null && tablet == null) {
    return const [];
  }

  final layoutInfo = sunny.get<LayoutInfo>(context: context);
  switch (layoutInfo.screenType) {
    case DeviceScreenType.mobile:
      return mobile != null ? [mobile(context)] : const [];
    case DeviceScreenType.tablet:
      final fn = tablet ?? desktop;
      final fns = tablets ?? desktops;
      return [
        if (fn != null) fn(context),
        if (fns != null) ...fns.call(context),
      ];

    case DeviceScreenType.desktop:
      return [
        if (desktop != null) desktop(context),
        if (desktops != null) ...desktops(context)
      ];
    case DeviceScreenType.watch:
      return [];

    default:
      throw "Invalid type: ${layoutInfo.screenType}";
  }
}

R ResponsiveItem<R>(
  BuildContext context, {
  ResponsiveExpression<R>? mobile,
  ResponsiveExpression<R>? tablet,
  ResponsiveExpression<R>? desktop,
  R? defaultValue,
}) {
  if (mobile == null && desktop == null && tablet == null) {
    return defaultValue as R;
  }

  final layoutInfo = sunny.get<LayoutInfo>(context: context);
  switch (layoutInfo.screenType) {
    case DeviceScreenType.mobile:
      return mobile != null ? mobile(context) : defaultValue as R;
    case DeviceScreenType.tablet:
      final fn = tablet ?? desktop;
      return fn != null ? fn(context) : defaultValue as R;
    case DeviceScreenType.desktop:
      return desktop != null ? desktop(context) : defaultValue as R;
    case DeviceScreenType.watch:
      return defaultValue as R;

    default:
      return throw "Invalid type: ${layoutInfo.screenType}";
  }
}
