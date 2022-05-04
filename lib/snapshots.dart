import 'package:flutter/widgets.dart';
import 'package:sunny_platform_widgets/sunny_platform_widgets.dart';
import 'package:logging/logging.dart';

import 'package:sunny_essentials/container/auto_layout.dart';
import 'package:sunny_essentials/theme.dart';
import 'package:sunny_essentials/text.dart';

typedef WidgetDataBuilder<I> = Widget Function(I input);
typedef WidgetOrLoaderBuilder<I> = Widget Function(
    I? input, SimpleWidgetBuilder loader);
typedef WidgetContextDataBuilder<I> = Widget Function(
    BuildContext context, I input);
typedef WidgetErrorBuilder = Widget Function(
    BuildContext context, Object err, StackTrace? stack);
typedef SimpleWidgetBuilder = Widget Function();

//typedef WidgetBuilder = Widget Function();
final _log = Logger("snapshots");

class Snapshots {}

final loadingIndicator = Center(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: PlatformCircularProgressIndicator(),
  ),
);
final sliverLoadingIndicator = SliverToBoxAdapter(
    child: Center(child: PlatformCircularProgressIndicator()));

Widget kErrorHandler(BuildContext context, Object? err, StackTrace? stack) {
  _log.severe(
      "Error rendering snapshot!: $err", err, stack ?? StackTrace.current);
  // analytics.encounteredError(err, stack, "Rendering snapshot ${X}");
  return Layout.container().alignCenter.padAll(sunnySpacing * 2).single(
        context.richText(
          (_) => _
              .center()
              .color(sunnyColors.red)
              .softWrap()
              .body1("There was a problem loading"),
        ),
      );
}

Widget kLoader() => loadingIndicator;

extension SnapshotExtensions<X> on AsyncSnapshot<X> {
  Widget render(
    BuildContext context, {
    WidgetOrLoaderBuilder<X>? builder,
    WidgetDataBuilder<X>? successFn,
    WidgetErrorBuilder errorFn = kErrorHandler,
    bool isSliver = false,
    SimpleWidgetBuilder loadingFn = kLoader,
    bool allowNull = false,
    bool? crossFade = true,
  }) {
    assert(successFn != null || builder != null,
        "Must have either builder or successFn");

    if (isSliver == true) {
      final _oldLoad = loadingFn;
      loadingFn = () => SliverToBoxAdapter(child: (_oldLoad()));

      final _oldErr = errorFn;
      errorFn = (context, err, stack) =>
          SliverToBoxAdapter(child: _oldErr(context, err, stack));
    }

    Widget widget;
    if (hasError) {
      widget = errorFn(context, this.error!, null);
    } else if (hasData || allowNull == true) {
      widget = successFn != null ? successFn(data!) : builder!(data, loadingFn);
    } else {
      widget = builder != null ? builder(null, loadingFn) : loadingFn();
    }
    return (crossFade != true || isSliver == true)
        ? widget
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 300), child: widget);
  }
}

extension StreamWidgetBuilder<T> on Stream<T> {
  Widget build(
      {WidgetDataBuilder<T>? builder,
      WidgetOrLoaderBuilder<T>? buildAll,
      bool isSliver = false,
      WidgetBuilder? loadingBuilder,
      SimpleWidgetBuilder? simpleLoader,
      T? initial,
      bool? crossFade,
      Key? key}) {
    return StreamBuilder<T>(
      key: key,
      stream: this,
      builder: (context, snap) {
        return snap.render(
          context,
          isSliver: isSliver,
          crossFade: crossFade,
          successFn: builder,
          builder: buildAll,
          loadingFn: simpleLoader ??
              (loadingBuilder == null
                  ? kLoader
                  : () => loadingBuilder(context)),
          allowNull: false,
        );
      },
      initialData: initial,
    );
  }

  Widget buildNullable(
      {WidgetDataBuilder<T?>? builder,
      bool isSliver = false,
      WidgetBuilder? loadingBuilder,
      SimpleWidgetBuilder? simpleLoader,
      T? initial,
      bool? crossFade,
      Key? key}) {
    return StreamBuilder<T>(
      key: key,
      stream: this,
      builder: (context, snap) {
        return snap.render(
          context,
          isSliver: isSliver,
          crossFade: crossFade,
          builder: (data, _) => builder!(data),
          loadingFn: simpleLoader ??
              (loadingBuilder == null
                  ? kLoader
                  : () => loadingBuilder(context)),
          allowNull: true,
        );
      },
      initialData: initial,
    );
  }
}

extension FutureWidgetExt<T> on Future<T> {
  Widget build(WidgetDataBuilder<T> builder,
      {Key? key,
      SimpleWidgetBuilder loading = kLoader,
      bool crossFade = true}) {
    return FutureBuilder<T>(
      future: this,
      key: key,
      builder: (context, snap) {
        return snap.render(
          context,
          crossFade: crossFade,
          loadingFn: loading,
          successFn: builder,
        );
      },
    );
  }

  Widget buildContext(
      {WidgetContextDataBuilder<T>? builder, T? initialValue, Key? key}) {
    return StreamBuilder<T>(
      key: key,
      stream: Stream.fromFuture(this),
      initialData: initialValue,
      builder: (context, snap) =>
          snap.render(context, successFn: ((data) => builder!(context, data))),
    );
  }
}
