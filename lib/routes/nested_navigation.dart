// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_builder/responsive_builder.dart' as rb;
import 'package:sunny_core_widgets/routes/route_extensions.dart';
import 'package:sunny_essentials/sunny_essentials.dart';
import 'package:sunny_fluro/sunny_fluro.dart';

final nestedGlobalKey =
    GlobalKey<NavigatorState>(debugLabel: "nestedGlobalKey");

class NestedNavigatorContainer extends StatelessWidget {
  static void popAll(
    BuildContext context, {
    bool rootNavigator = false,
    Object? result,
  }) {
    final nested = Provided.find<NestedNavigatorContainer>(context);
    if (nested?.parent != null) {
      nested!.parent!.pop(result);
    } else {
      return Navigator.of(context, rootNavigator: rootNavigator).pop(result);
    }
  }

  static void popSingle(
    BuildContext context, {
    bool rootNavigator = false,
    Object? result,
  }) {
    final nested = Provided.find<NestedNavigatorContainer>(context);
    if (nested?.navigatorKey != null) {
      nested!.navigatorKey?.currentState?.pop(result);
    } else {
      return Navigator.of(context, rootNavigator: rootNavigator).pop(result);
    }
  }

  final Navigator? child;
  final GlobalKey<NavigatorState>? navigatorKey;
  final NavigatorState? parent;
  final ScrollController? scroller;

  const NestedNavigatorContainer(
      {Key? key,
      this.navigatorKey,
      required this.parent,
      required this.child,
      this.scroller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child!;
  }
}

extension BuildContextNestedNavigator on BuildContext {
  bool get isInModal {
    return this.find<NestedNavigatorContainer>() != null;
  }
}

typedef OnGenerateRoute<T> = Route<T> Function(RouteSettings settings);

Future<T?> bottomSheetModal<T>(
  BuildContext context,
  WidgetBuilder scrollBuilder, {
  bool displayDragHandle = true,
}) {
  switch (context.screenType) {
    case rb.DeviceScreenType.desktop:
      return showPlatformDialog<T>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: true,
        builder: memoizeWidgetBuilder(
          (context) => Center(
            child: Layout.container()
                .borderRadiusAll(16)
                .backgroundColor(Colors.white)
                .padAll(sunnySpacing * 2)
                .single(
                  Container(
                    child: SizedBox(
                      width: 600.px,
                      height: 600.px,
                      child: scrollBuilder(context),
                    ),
                  ),
                ),
          ),
        ),
      );
    default:
      return showCupertinoModalBottomSheet<T>(
        context: context,
        useRootNavigator: true,
        enableDrag: true,
        isDismissible: true,
        builder: memoizeScrollBuild(scrollBuilder),
      );
  }
}

WidgetBuilder memoizeScrollBuild(WidgetBuilder builder) {
  Widget? _memoized;
  return (context) => _memoized ??= builder(context);
}

WidgetBuilder memoizeWidgetBuilder(WidgetBuilder builder) {
  Widget? _memoized;
  return (context) => _memoized ??= builder(context);
}

WidgetBuilder memoizeScrollToNon(WidgetBuilder builder) {
  Widget? _memoized;
  return (context) => _memoized ??= builder(context);
}

Future<T?> nestedModal<T>(
  BuildContext context,
  WidgetBuilder scrollBuilder, {
  bool displayDragHandle = true,
  required PathRouteSettings? settings,
}) {
  Widget? w;
  return context.page<T>((context) {
    return w ??= scrollBuilder(context);
  });
}
