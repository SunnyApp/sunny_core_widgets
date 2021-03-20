import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:logging/logging.dart';

import 'package:sunny_essentials/container/auto_layout.dart';
import 'package:sunny_essentials/theme.dart';
import 'package:sunny_essentials/text.dart';

typedef WidgetDataBuilder<I> = Widget Function(I input);
typedef WidgetContextDataBuilder<I> = Widget Function(
    BuildContext context, I input);
typedef WidgetErrorBuilder = Widget Function(Object err, StackTrace? stack);
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

extension SnapshotExtensions<X> on AsyncSnapshot<X> {
  Widget render(
    BuildContext context, {
    required WidgetDataBuilder<X>? successFn,
    WidgetErrorBuilder? errorFn,
    bool isSliver = false,
    SimpleWidgetBuilder? loadingFn,
    bool allowNull = false,
    bool? crossFade = true,
  }) {
    loadingFn ??= () => loadingIndicator;
    if (isSliver == true) {
      final _oldFn = loadingFn;
      loadingFn = () => SliverToBoxAdapter(child: (_oldFn()));
    }

    errorFn ??= (Object? err, StackTrace? stack) {
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
    };
    if (isSliver == true) {
      final _oldErr = errorFn;
      errorFn = (err, stack) => SliverToBoxAdapter(child: _oldErr(err, stack));
    }
    Widget widget;
    if (hasError) {
      widget = errorFn(this.error!, null);
    } else if (hasData || allowNull == true) {
      widget = successFn!(data!);
    } else {
      widget = loadingFn();
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
      bool allowNull = false,
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
          successFn: builder as Widget Function(T?)?,
          loadingFn: simpleLoader ??
              (loadingBuilder == null ? null : () => loadingBuilder(context)),
          allowNull: allowNull,
        );
      },
      initialData: initial,
    );
  }
}

extension FutureWidgetExt<T> on Future<T> {
  Widget build(WidgetDataBuilder<T> builder,
      {Key? key, SimpleWidgetBuilder? loading, bool crossFade = true}) {
    return FutureBuilder<T>(
      future: this,
      key: key,
      builder: (context, snap) {
        return snap.render(
          context,
          crossFade: crossFade,
          loadingFn: loading,
          successFn: builder as Widget Function(T?)?,
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
