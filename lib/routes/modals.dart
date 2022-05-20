import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sunny_platform_widgets/sunny_platform_widgets.dart';
import 'package:info_x/info_x.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;
import 'package:sunny_core_widgets/core_ext.dart';
import 'package:sunny_core_widgets/routes.dart';
import 'package:sunny_essentials/sunny_essentials.dart';
import 'package:sunny_fluro/sunny_fluro.dart';
import 'package:sunny_sdk_core/model_exports.dart';

typedef Route<T> RouteBuilder<T>(WidgetBuilder builder);

typedef OpenModal<T> = Future<T?> Function(BuildContext context,
    {required WidgetBuilder builder,
    bool displayDragHandle,
    Color? backgroundColor,
    bool dismissible,
    bool draggable,
    PathRouteSettings? settings,
    double? width,
    double? height,
    bool useScaffold,
    bool? displayTitle,
    bool expand,
    dynamic extraOptions,
    RouteBuilder<T>? routeBuilder,
    bool useRootNavigator,
    bool nestModals});

typedef ModalOpenerOverride = ModalOpener? Function(BuildContext context,
    {bool useScaffold});

class Modals {
  const Modals._();

  static const cupertino = const CupertinoModalOpener(useScaffold: true);
  static const cupertinoNoScaffold =
      const CupertinoModalOpener(useScaffold: false);
  static const android = const AndroidModalOpener();
  static const desktop = const DesktopModalOpener();
  static final _modalHandlers = <ModalOpenerOverride>[];

  static void register(ModalOpenerOverride handler) {
    if (!_modalHandlers.contains(handler)) {
      _modalHandlers.add(handler);
    }
  }

  static ModalOpener of<T>(BuildContext context, {bool useScaffold = true}) {
    final layoutInfo = sunny.get<LayoutInfo>(context: context);
    final ModalOpener? override = _modalHandlers
        .map((e) => e(context, useScaffold: useScaffold))
        .firstWhere((element) => element != null, orElse: () => null);
    if (override != null) {
      return override;
    }
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
      bool? displayTitle,
      Color? backgroundColor,
      ModalConstraints? constraints,
      PathRouteSettings? settings,
      bool expand = false,
      dynamic extraOptions,
      bool useRootNavigator = true,
      bool nestModals = false}) {
    var opener = Modals.of(context, useScaffold: useScaffold);
    return opener.open(
      context,
      builder: backgroundColor != null
          ? (context) => ModalScaffoldInfo(background: backgroundColor)
              .provide(child: builder(context))
          : builder,
      displayDragHandle: displayDragHandle,
      dismissible: dismissible,
      draggable: draggable,
      backgroundColor: backgroundColor,
      settings: settings,
      constraints: constraints,
      useRootNavigator: useRootNavigator,
      extraOptions: extraOptions,
      expand: expand,
      nestModals: nestModals,
      displayTitle: displayTitle,
    );
  }
}

/// Describes how to open modal windows on the various platforms.  A new modal
/// opener can be registered by using [Modals.register]
abstract class ModalOpener {
  Future<T?> open<T>(BuildContext context,
      {required WidgetBuilder builder,
      bool displayDragHandle = true,
      bool dismissible = true,
      bool draggable = true,
      Color? backgroundColor,
      PathRouteSettings? settings,
      bool? displayTitle,
      bool expand = false,
      bool useRootNavigator = true,
      ModalConstraints? constraints,
      bool nestModals = false,
      extraOptions});
}

class DesktopModalOpener implements ModalOpener {
  @override
  Future<T?> open<T>(
    BuildContext context, {
    required builder,
    bool displayDragHandle = true,
    bool dismissible = true,
    bool draggable = true,
    Color? backgroundColor,
    PathRouteSettings? settings,
    ModalConstraints? constraints,
    bool? displayTitle,
    bool useRootNavigator = true,
    bool expand = false,
    bool nestModals = false,
    extraOptions,
  }) {
    constraints ??= ModalConstraints.medium;
    return showPlatformDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: dismissible,
      routeSettings: settings,
      builder: memoizeWidgetBuilder(
        (context) => Center(
          child: Layout.container()
              .borderRadiusAll(16)
              .backgroundColor(backgroundColor ??
                  (expand == false ? Colors.transparent : sunnyColors.white))
              .single(
                Container(
                  padding: EdgeInsets.all(16),
                  child: constraints!.build(
                    context,
                    child: Center(
                      child: builder(context),
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  const DesktopModalOpener();
}

extension GlobalKeyExt<S extends State> on GlobalKey<S> {
  /// Waits for a global key's state to become available
  Future<S> waitForState({int attempts = 10}) {
    if (this.currentState != null) return SynchronousFuture(this.currentState!);

    return _waitForState(attempts, 0);
  }

  Future<S> _waitForState(int attempts, int attempt) async {
    if (attempt > attempts) throw "Timeout exception after $attempt";
    await Duration(milliseconds: attempt * 100).pause();
    if (this.currentState != null) return this.currentState!;
    return _waitForState(attempts, attempt + 1);
  }
}

Future<T?>? _attachToNestedNavigator<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  required PathRouteSettings? settings,
}) {
  final nested = Provided.find<NestedNavigatorContainer>(context);

  if (nested?.navigator != null && nested?.navigatorKey != null) {
    return nested?.navigatorKey!.waitForState().then((state) {
      return state.push<T>(platformPageRoute(
        builder: builder,
        settings: settings,
        context: context,
      ));
    });
  } else {
    return null;
  }
}

class NestedNavigatorRoot {}

Widget _buildNestedNavigator<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  PathRouteSettings? settings,
  bool useRootNavigator = true,
  String? debugLabel,
  WrapNavigator? wrapNavigator,
}) {
  final parentNav = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );

  final nav = ModalNavigator(
    builder: builder,
    debugLabel: debugLabel,
    wrapNavigator: wrapNavigator,
    parentNav: parentNav,
  );

  return nav;
}

class WidgetBuilderOrFuture<T> {
  final WidgetBuilder? _builder;
  final Future<T?>? _future;

  const WidgetBuilderOrFuture.builder(WidgetBuilder builder)
      : _builder = builder,
        _future = null;
  const WidgetBuilderOrFuture.future(Future<T?> future)
      : _future = future,
        _builder = null;

  bool get isFuture {
    return _future != null;
  }

  Future<T?> get future => _future!;
  WidgetBuilder get builder => _builder!;
}

/// Based on whether [nestedModals] is enabled, this will return:
/// * a future, if the nested navigator already exists and we are simply pushing another route
/// * a builder, if we are creating the nested navigator (or building the plain widget)
WidgetBuilderOrFuture<T> getWidgetBuilderForModal<T>(BuildContext context,
    {required bool nestModals,
    required WidgetBuilder builder,
    required bool displayDragHandle,
    required String? debugLabel,
    required bool useRootNavigator,
    required PathRouteSettings? settings,
    WrapNavigator? wrapNavigator,
    required}) {
  if (nestModals == true) {
    var attempt = _attachToNestedNavigator<T>(
      context,
      builder: builder,
      settings: settings,
    );
    if (attempt != null) {
      return WidgetBuilderOrFuture.future(attempt);
    } else {
      return WidgetBuilderOrFuture.builder((context) {
        return _buildNestedNavigator(
          context,
          builder: builder,
          debugLabel: debugLabel,
          useRootNavigator: useRootNavigator,
          settings: settings,
          wrapNavigator: wrapNavigator,
        );
      });
    }
  } else {
    return WidgetBuilderOrFuture.builder(wrapNavigator == null
        ? builder
        : (context) => wrapNavigator(builder(context)));
  }
}

class CupertinoModalOpener<T> implements ModalOpener {
  final bool useScaffold;

  const CupertinoModalOpener({this.useScaffold = true});

  @override
  Future<T?> open<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool displayDragHandle = true,
    bool dismissible = true,
    bool draggable = true,
    PathRouteSettings? settings,
    bool? displayTitle,
    bool useRootNavigator = true,
    bool expand = false,
    Color? backgroundColor,
    bool nestModals = false,
    String? debugLabel,
    ModalConstraints? constraints,
    extraOptions,
  }) {
    final scaffold = CupertinoScaffold.of(context);
    var result = getWidgetBuilderForModal<T>(
      context,
      nestModals: nestModals,
      builder: builder,
      displayDragHandle: displayDragHandle,
      debugLabel: debugLabel,
      useRootNavigator: useRootNavigator,
      settings: settings,
    );

    if (result.isFuture) {
      return result.future;
    }
    var background = ModalScaffoldInfo(
      background: backgroundColor ?? sunnyColors.modalBackground,
    );
    var _builder = displayDragHandle
        ? (BuildContext context) => result.builder(context).withDragHandle()
        : result.builder;
    if (scaffold != null && useScaffold && useRootNavigator == true) {
      Widget? w;
      return CupertinoScaffold.showCupertinoModalBottomSheet<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        bounce: true,
        backgroundColor: background.background,
        enableDrag: draggable,
        expand: expand,
        settings: settings,
        isDismissible: dismissible,
        builder: (context) {
          return w ??= background.provide(child: _builder(context));
        },
      );
    } else {
      Widget? w;

      return showCupertinoModalBottomSheet<T>(
        context: context,
        bounce: true,
        expand: expand,
        enableDrag: draggable,
        backgroundColor: background.background,
        useRootNavigator: useRootNavigator,
        settings: settings,
        barrierColor: Colors.black54,
        isDismissible: dismissible,
        builder: (context) {
          return w ??= background.provide(child: _builder(context));
        },
      );
    }
  }
}

class AndroidModalOpener<T> implements ModalOpener {
  @override
  Future<T?> open<T>(
    BuildContext context, {
    required builder,
    bool displayDragHandle = true,
    bool dismissible = true,
    bool draggable = true,
    PathRouteSettings? settings,
    Color? backgroundColor,
    bool? displayTitle,
    bool expand = false,
    bool useRootNavigator = true,
    bool nestModals = false,
    ModalConstraints? constraints,
    extraOptions,
  }) {
    Widget? w;

    return showMaterialModalBottomSheet<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      bounce: true,
      expand: expand,
      enableDrag: draggable,
      backgroundColor: backgroundColor ?? sunnyColors.modalBackground,
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

class ModalNavigator extends StatefulWidget {
  final WidgetBuilder builder;
  final String? debugLabel;
  final NavigatorState? parentNav;
  final WrapNavigator? wrapNavigator;

  const ModalNavigator(
      {Key? key,
      required this.builder,
      required this.wrapNavigator,
      required this.debugLabel,
      required this.parentNav})
      : super(key: key);

  @override
  State<ModalNavigator> createState() => _ModalNavigatorState();
}

int _navCount = 0;

class _ModalNavigatorState extends State<ModalNavigator> {
  late GlobalKey<NavigatorState> navKey;

  @override
  void initState() {
    super.initState();
    navKey = GlobalKey<NavigatorState>(
      debugLabel: widget.debugLabel ?? 'nestedNavKey${_navCount++}',
    );
  }

  @override
  Widget build(BuildContext context) {
    var nav = Navigator(
      key: navKey,
      pages: [
        platformPage(
          child: Provider.value(
            value: NestedNavigatorRoot(),
            updateShouldNotify: (a, b) => false,
            builder: (context, child) => widget.builder(context),
          ),
          fullscreenDialog: false,
          context: context,
        )
      ],
      onPopPage: (_, __) {
        return false;
      },
    );
    return Provider(
      create: (context) => NestedNavigatorContainer(
        navigator: nav,
        parent: widget.parentNav,
        navigatorKey: navKey,
      ),
      child: widget.wrapNavigator == null ? nav : widget.wrapNavigator!(nav),
    );
  }
}
