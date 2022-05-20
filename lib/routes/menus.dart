import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sunny_platform_widgets/sunny_platform_widgets.dart';
import 'package:info_x/info_x.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;
import 'package:sunny_core_widgets/core_ext.dart';
import 'package:sunny_core_widgets/routes.dart';
import 'package:sunny_essentials/sunny_essentials.dart';
import 'package:sunny_fluro/sunny_fluro.dart';


typedef OpenMenu<T> = Future<T?> Function(BuildContext context,
    {required MenuBuilder<T> builder,
    bool displayDragHandle,
    bool dismissible,
    Widget? title,
    Widget? content,
    bool draggable,
    PathRouteSettings? settings,
    double? width,
    dynamic extraOptions,
    double? height,
    bool expand,
    bool useRootNavigator,
    Constraints? constraints,
    bool nestModals});

typedef MenuOpenerOverride = OpenMenu<T>? Function<T>(BuildContext context);
Future<T?> showPlatformMenu<T>(BuildContext context,
    {required MenuBuilder<T> builder,
    bool useScaffold = true,
    bool displayDragHandle = true,
    bool dismissible = true,
    bool draggable = true,
    Constraints? constraints,
    PathRouteSettings? settings,
    double? width,
    double? height,
    Widget? title,
    Widget? content,
    dynamic extraOptions,
    bool expand = false,
    bool useRootNavigator = true,
    bool nestModals = false}) {
  final opener = Menus.of<T>(context, useScaffold: useScaffold);
  return opener(
    context,
    builder: builder,
    displayDragHandle: displayDragHandle,
    dismissible: dismissible,
    draggable: draggable,
    settings: settings,
    width: width,
    title: title,
    content: content,
    useRootNavigator: useRootNavigator,
    height: height,
    extraOptions: extraOptions,
    expand: expand,
    nestModals: nestModals,
    constraints: constraints,
  );
}

typedef MenuBuilder<T> = PlatformContextMenuBase<T> Function(
    BuildContext context);
typedef MenuItemSelected<T> = void Function(T selected);

abstract class PlatformContextMenuBase<K> implements Widget {
  Widget? get title;
  Widget? get content;
  List<PlatformContextMenuElement<K>> get items;
  MenuItemSelected<K>? get onItemSelected;
}

extension PlatformMenuBaseExtension<K> on PlatformContextMenuBase<K> {
  PlatformContextMenuItem<K>? findByValue(K? value) {
    var filtered = items
        .whereType<PlatformContextMenuItem<K>>()
        .where((element) => element.value == value);
    return filtered.isEmpty ? null : filtered.first;
  }
}

abstract class PlatformContextMenuElement<K> {}

class PlatformContextMenuDivider<K> implements PlatformContextMenuElement<K> {
  const PlatformContextMenuDivider();
}

class PlatformContextMenuLabel<K> implements PlatformContextMenuElement<K> {
  final String label;

  const PlatformContextMenuLabel(this.label);
}

class PlatformContextMenuItem<K> implements PlatformContextMenuElement<K> {
  final String label;
  final List<PlatformContextMenuItem<K>> children;
  final K value;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool isDefaultAction;
  final bool isCloseOnTap;

  const PlatformContextMenuItem({
    required this.label,
    this.isDestructive = false,
    this.isDefaultAction = false,
    this.onTap,
    this.isCloseOnTap = true,
    this.children = const [],
    required this.value,
  });

  static PlatformContextMenuItem<String> simple(String label,
          {bool isCloseOnTap = true,
          bool isDestructive = false,
          VoidCallback? onTap}) =>
      PlatformContextMenuItem<String>(
        label: label,
        value: label,
        isCloseOnTap: isCloseOnTap,
        isDestructive: isDestructive,
        onTap: onTap,
      );
}

class Menus {
  const Menus._();

  static final _menuHandlers = <MenuOpenerOverride>[];
  static void register(MenuOpenerOverride handler) {
    if (!_menuHandlers.contains(handler)) {
      _menuHandlers.add(handler);
    }
  }

  static OpenMenu<T> of<T>(BuildContext context, {bool useScaffold = true}) {
    final layoutInfo = sunny.get<LayoutInfo>(context: context);
    final OpenMenu<T>? override = _menuHandlers
        .map((e) => e<T>(context))
        .firstWhere((element) => element != null, orElse: () => null);
    if (override != null) {
      return override;
    }
    if (layoutInfo.screenType == DeviceScreenType.desktop) {
      return showDesktopMenu<T>;
    } else if (infoX.isAndroid) {
      return openAndroidMenu<T>;
    } else if (useScaffold && infoX.isIOS) {
      return cupertinoMenuOpener<T>(useScaffold: useScaffold);
    } else if (infoX.isIOS) {
      return cupertinoMenuOpener<T>(useScaffold: false);
    } else {
      return openAndroidMenu<T>;
    }
  }
}

Future<T?> showDesktopMenu<T>(
  BuildContext context, {
  required MenuBuilder<T> builder,
  bool displayDragHandle = true,
  bool dismissible = true,
  bool draggable = true,
  PathRouteSettings? settings,
  Widget? title,
  Widget? content,
  double? width,
  double? height,
  dynamic extraOptions,
  bool useRootNavigator = true,
  bool expand = false,
  bool nestModals = false,
  Constraints? constraints,
}) {
  width ??= 600.px;
  height ??= 570.px;
  return showPlatformDialog<T>(
    context: context,
    extraOptions: extraOptions,
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
    ),
  );
}

OpenMenu<T> cupertinoMenuOpener<T>({bool useScaffold = true}) {
  return <T>(
    BuildContext context, {
    required MenuBuilder<T> builder,
    bool displayDragHandle = true,
    bool dismissible = true,
    bool draggable = true,
    Widget? title,
    Widget? content,
    PathRouteSettings? settings,
    double? width,
    double? height,
    bool useRootNavigator = true,
    bool expand = false,
    bool nestModals = false,
    Constraints? constraints,
    dynamic extraOptions,
  }) {
    var menu = builder(context);

    Widget? w;

    Widget buildNested(BuildContext context) {
      return CupertinoActionSheet(
        title: menu.title ?? title,
        message: menu.content ?? content,
        actions: [
          for (final item in menu.items.whereType<PlatformContextMenuItem<T>>())
            CupertinoActionSheetAction(
              child: Text(item.label),
              isDestructiveAction: item.isDestructive,
              isDefaultAction: item.isDefaultAction,
              onPressed: () {
                if (item.isCloseOnTap) {
                  Navigator.pop(context, item.value);
                }
                item.onTap?.call();
                menu.onItemSelected?.call(item.value);
              },
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    return showCupertinoModalPopup<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierColor: Colors.black54,
      builder: (context) {
        return w ??= buildNested(context);
      },
    );
  };
}

Future<T?> openAndroidMenu<T>(
  BuildContext context, {
  required MenuBuilder<T> builder,
  bool displayDragHandle = true,
  bool dismissible = true,
  bool draggable = true,
  PathRouteSettings? settings,
  double? width,
  double? height,
  Widget? title,
  Widget? content,
  bool expand = false,
  bool useRootNavigator = true,
  bool nestModals = false,
  Constraints? constraints,
  dynamic extraOptions,
}) {
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
