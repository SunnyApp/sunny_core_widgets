import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:info_x/info_x.dart';
import 'package:info_x/sunny_get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;
import 'package:sunny_core_widgets/core_ext.dart';
import 'package:sunny_core_widgets/routes.dart';
import 'package:sunny_core_widgets/routes/handle_sheet.dart';
import 'package:sunny_essentials/sunny_essentials.dart';
import 'package:sunny_fluro/sunny_fluro.dart';

import 'nested_navigation.dart';
import '../widgets/widget_extensions.dart';

typedef OpenModal<T> = Future<T?> Function(BuildContext context,
    {required WidgetBuilder builder,
    bool displayDragHandle,
    bool dismissible,
    bool draggable,
    PathRouteSettings? settings,
    double? width,
    double? height,
    bool expand,
    bool useRootNavigator,
    bool nestModals});

class Modals {
  const Modals._();

  static const cupertino = const CupertinoModalOpener(useScaffold: true);
  static const cupertinoNoScaffold =
      const CupertinoModalOpener(useScaffold: false);
  static const android = const AndroidModalOpener();
  static const desktop = const DesktopModalOpener();

  static ModalOpener of<T>(BuildContext context, {bool useScaffold = true}) {
    final layoutInfo = sunny.get<LayoutInfo>(context: context);
    if (layoutInfo.screenType == DeviceScreenType.desktop) {
      return desktop;
    } else if (infoX.isAndroid) {
      return android;
    } else if (useScaffold && infoX.isIOS) {
      return cupertino;
    } else if (infoX.isIOS) {
      return cupertinoNoScaffold;
    } else {
      return android;
    }
  }

  static Future<T?> open<T>(BuildContext context,
      {required WidgetBuilder builder,
      bool useScaffold = true,
      bool displayDragHandle = true,
      bool dismissible = true,
      bool draggable = true,
      PathRouteSettings? settings,
      double? width,
      double? height,
      bool expand = false,
      bool useRootNavigator = true,
      bool nestModals = false}) {
    return Modals.of(context, useScaffold: useScaffold).open(context,
        builder: builder,
        displayDragHandle: displayDragHandle,
        dismissible: dismissible,
        draggable: draggable,
        settings: settings,
        width: width,
        useRootNavigator: useRootNavigator,
        height: height,
        expand: expand,
        nestModals: nestModals);
  }
}

abstract class ModalOpener {
  Future<T?> open<T>(BuildContext context,
      {required WidgetBuilder builder,
      bool displayDragHandle = true,
      bool dismissible = true,
      bool draggable = true,
      PathRouteSettings? settings,
      double? width,
      double? height,
      bool expand = false,
      bool useRootNavigator = true,
      bool nestModals = false});
}

class DesktopModalOpener implements ModalOpener {
  @override
  Future<T?> open<T>(BuildContext context,
      {required builder,
      bool displayDragHandle = true,
      bool dismissible = true,
      bool draggable = true,
      PathRouteSettings? settings,
      double? width,
      double? height,
      bool useRootNavigator = true,
      bool expand = false,
      bool nestModals = false}) {
    width ??= 600.px;
    height ??= 570.px;
    return showPlatformDialog<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        barrierDismissible: dismissible,
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
  }

  const DesktopModalOpener();
}

class CupertinoModalOpener<T> implements ModalOpener {
  final bool useScaffold;

  const CupertinoModalOpener({this.useScaffold = true});

  @override
  Future<T?> open<T>(BuildContext context,
      {required builder,
      bool displayDragHandle = true,
      bool dismissible = true,
      bool draggable = true,
      PathRouteSettings? settings,
      double? width,
      double? height,
      bool useRootNavigator = true,
      bool expand = false,
      bool nestModals = false}) {
    final scaffold = CupertinoScaffold.of(context);
    final nested = Provided.find<NestedNavigatorContainer>(context);
    if (nested?.child != null &&
        nestModals &&
        nested?.navigatorKey?.currentState != null) {
      return nested!.navigatorKey!.currentState!
          .push<T>(PlatformPageRoute(builder: builder));
    } else {
      final buildNested = (BuildContext context) {
        final parentNav = !nestModals
            ? null
            : Navigator.of(context, rootNavigator: useRootNavigator);
        final navKey = !nestModals
            ? null
            : GlobalKey<NavigatorState>(debugLabel: 'nestedNavKey');
        final nav = !nestModals
            ? null
            : Navigator(
                key: navKey,
                pages: [
                  CupertinoPage(
                      child: Builder(builder: builder), fullscreenDialog: true)
                ],
                onPopPage: (_, __) {
                  return false;
                },
              );

        final theWidget =
            (nestModals ? nav! : Builder(builder: builder)).maybeWrap(
          height != null,
          (child) => SizedBox(height: height!, child: child),
        );
        final widgetWithHandle =
            displayDragHandle ? theWidget.withDragHandle() : theWidget;

        return !nestModals
            ? widgetWithHandle
            : Provider(
                create: (_) => NestedNavigatorContainer(
                      child: nav,
                      parent: parentNav,
                      navigatorKey: navKey,
                    ),
                child: widgetWithHandle);
      };
      if (scaffold != null && useScaffold && useRootNavigator == true) {
        return CupertinoScaffold.showCupertinoModalBottomSheet<T>(
          context: context,
          useRootNavigator: useRootNavigator,
          bounce: true,
          backgroundColor: sunnyColors.modalBackground,
          enableDrag: draggable,
          expand: expand,
          settings: settings,
          isDismissible: dismissible,
          builder: (context) {
            Widget? w;
            return w ??= buildNested(context);
          },
        );
      } else {
        Widget? w;

        return showCupertinoModalBottomSheet<T>(
          context: context,
          bounce: true,
          expand: expand,
          enableDrag: draggable,
          backgroundColor: sunnyColors.modalBackground,
          useRootNavigator: useRootNavigator,
          settings: settings,
          barrierColor: Colors.black54,
          isDismissible: dismissible,
          builder: (context) {
            return w ??= buildNested(context);
          },
        );
      }
    }
  }
}

class AndroidModalOpener<T> implements ModalOpener {
  @override
  Future<T?> open<T>(BuildContext context,
      {required builder,
      bool displayDragHandle = true,
      bool dismissible = true,
      bool draggable = true,
      PathRouteSettings? settings,
      double? width,
      double? height,
      bool expand = false,
      bool useRootNavigator = true,
      bool nestModals = false}) {
    Widget? w;

    return showMaterialModalBottomSheet<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      bounce: true,
      expand: expand,
      enableDrag: draggable,
      backgroundColor: sunnyColors.modalBackground,
      isDismissible: dismissible,
      builder: (context) {
        return w ??= displayDragHandle
            ? builder(context).withDragHandle()
            : builder(context);
      },
    );
  }

  const AndroidModalOpener();
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