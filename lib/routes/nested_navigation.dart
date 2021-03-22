// ignore_for_file: deprecated_member_use

import 'package:sunny_fluro/sunny_fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart' as rb;
import 'package:sunny_essentials/sunny_essentials.dart';

import 'package:sunny_core_widgets/routes/handle_sheet.dart';
import 'package:sunny_core_widgets/routes/platform_page_route.dart';
import 'package:sunny_core_widgets/routes/route_extensions.dart';
import 'package:info_x/info_x.dart';

final nestedGlobalKey =
    GlobalKey<NavigatorState>(debugLabel: "nestedGlobalKey");

class NestedNavigatorContainer extends StatelessWidget {
  final Navigator? child;
  final ScrollController? scroller;

  const NestedNavigatorContainer({Key? key, required this.child, this.scroller})
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
        androidBarrierDismissible: true,
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

Future<T?> modal<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool displayDragHandle = true,
  PathRouteSettings? settings,
  double? width,
  double? height,
  bool expand = true,
  bool nestModals = false,
}) {
  // switch (context.screenType) {
  //   case rs.DeviceScreenType.desktop:

  // if (expand != true) {
  //   Widget _p;
  //
  //   return showBarModalBottomSheet<T>(
  //     context: context,
  //     useRootNavigator: true,
  //     expand: expand,
  //     enableDrag: true,
  //     bounce: true,
  //     isDismissible: true,
  //     // routeSettings: settings,
  //
  //     builder: (context) => displayDragHandle
  //         ? (_p ??= builder(context).withDragHandle())
  //         : (_p ??= builder(context)),
  //   );
  // }
  if (infoX.isIOS == false) {
    width ??= 600.px;
    height ??= 570.px;
    return showPlatformDialog<T>(
        context: context,
        useRootNavigator: true,
        androidBarrierDismissible: true,
        barrierDismissible: true,
        routeSettings: settings,
        builder: memoizeWidgetBuilder(
          (context) => Center(
            child: Layout.container()
                .borderRadiusAll(16)
                .backgroundColor(
                    expand == false ? Colors.transparent : sunnyColors.white)
                .single(
                  Container(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: Center(child: builder(context)),
                    ),
                  ),
                ),
          ),
        ));
  } else {
    /// Previous behavior
    final nn = Provided.find<NestedNavigatorContainer>(context);
    final navState = nestedGlobalKey.currentState;
    Widget? _p;
    if (navState != null && nestModals == true) {
      return navState.push<T>(
        PlatformPageRoute(
          settings: settings,
          builder: (context) {
            if (displayDragHandle) {
              return _p ??= builder(context).withDragHandle();
            } else {
              return _p ??= builder(context);
            }
          },
        ),
      );
    } else {
      final scaffold = CupertinoScaffold.of(context);
      if (scaffold != null && expand) {
        return CupertinoScaffold.showCupertinoModalBottomSheet<T>(
          context: context,
          useRootNavigator: true,
          bounce: true,
          enableDrag: true,
          expand: expand,
          settings: settings,
          isDismissible: true,
          builder: (context) {
            Widget? w;
            return w ??= Provider(
                create: (_) => NestedNavigatorContainer(child: null),
                child: displayDragHandle
                    ? builder(context).withDragHandle()
                    : builder(context));
          },
        );
      } else {
        Widget? w;

        return showCupertinoModalBottomSheet<T>(
          context: context,
          useRootNavigator: true,
          bounce: true,
          expand: expand,
          enableDrag: true,
          settings: settings,
          barrierColor: Colors.black54,
          isDismissible: true,
          builder: (context) {
            return w ??= Provider(
                create: (_) => NestedNavigatorContainer(child: null),
                child: displayDragHandle
                    ? builder(context).withDragHandle()
                    : builder(context));
          },
        );
      }
    }
  }
}

extension WidgetDragHandle on Widget {
  Widget withDragHandle() {
    return widgetWithDragHandle(child: this);
  }
}

Widget widgetWithDragHandle({Widget? child}) {
  return Stack(
    alignment: Alignment.topCenter,
    fit: StackFit.loose,
    children: [
      child!,
      SizedBox(
        height: 18,
        child: const Center(child: const DragHandle()),
      ),
    ],
  );
}
