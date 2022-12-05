import 'package:dartxx/dartxx.dart';
import 'package:flutter/widgets.dart';
import 'package:info_x/sunny_get.dart';
import 'package:sunny_essentials/container/spaced.dart';
import 'package:sunny_essentials/theme.dart';
import 'package:sunny_sdk_core/data.dart';
import 'package:sunny_sdk_core/services/i_auth_state.dart';

import '../snapshots.dart';

class RecordBuilder<K, V> extends StatelessWidget {
  final RecordDataService<V, K> service;
  final V? initialValue;
  final bool isSliver;
  // final K? id;
  final SimpleWidgetBuilder loading;
  final SimpleWidgetBuilder? nullBuilder;
  final bool allowNull;
  final K? id;

  // ignore: non_constant_identifier_names
  static RecordBuilder<K, V> of<K, V>({
    Key? key,
    required RecordDataService<V, K> service,
  }) {
    return RecordBuilder(
      service,
      key: key,
    );
  }

  const RecordBuilder(
    this.service, {
    super.key,
    this.id,
    this.builder,
    this.nullBuilder,
    this.allowNull = false,
    this.initialValue,
    this.isSliver = false,
    this.loading = kLoader,
  });

  final Widget Function(V input)? builder;

  @override
  Widget build(BuildContext context) {
    assert(builder != null);
    assert(allowNull == true || (id != null || initialValue != null));
    if (id == null) {
      return initialValue == null
          ? (nullBuilder ?? loading)()
          : builder!(initialValue as V);
    } else {
      var isInitialized = service.isInitialized(id as K);

      /// If the record is loaded into memory, use that memory value to have an immediate rendering.
      final calculatedInitialValue =
          isInitialized ? service.tryGet(id!) : initialValue;

      if (sunny.get<IAuthState>().isNotLoggedIn) {
        return isSliver ? emptyBox.sliverBox() : emptyBox;
      }

      return StreamBuilder<V?>(
        stream: service

            /// We only stream updates because we will have fetched the _initialValue above
            .recordStream(id as K, immediate: calculatedInitialValue == null)!
            .where((event) => event != null)
            .cast(),
        initialData: calculatedInitialValue,
        builder: (context, snapshot) => allowNull
            ? snapshot.render(
                context,
                loadingFn: loading,
                isSliver: isSliver,
                builder: (V? data, loading) {
                  return data == null ? loading() : builder!(data);
                },
              )
            : snapshot.render(
                context,
                isSliver: isSliver,
                loadingFn: loading,
                allowNull: allowNull,
                successFn: ((data) {
                  return builder!(data as V);
                }),
              ),
      );
    }
  }

  Widget call({
    required K? id,
    required Widget Function(V input) builder,
    bool allowNull = false,
    V? initialValue,
    bool isSliver = false,
    SimpleWidgetBuilder loading = kLoader,
    SimpleWidgetBuilder? nullBuilder,
  }) {
    return RecordBuilder(
      service,
      key: key,
      id: id,
      builder: builder,
      nullBuilder: nullBuilder,
      allowNull: allowNull || nullBuilder != null,
      initialValue: initialValue,
      isSliver: isSliver,
      loading: loading,
    );
  }
}

class RelatedRecordBuilder<K, V> extends StatelessWidget {
  final RecordDataService<KeyedRelatedData<K, V>, K> service;
  final V? initialValue;
  final bool isSliver;
  // final K? id;
  final SimpleWidgetBuilder loading;
  final bool allowNull;
  final K? id;

  // ignore: non_constant_identifier_names
  static RelatedRecordBuilder<K, V> of<K, V>({
    Key? key,
    required RecordDataService<KeyedRelatedData<K, V>, K> service,
  }) {
    return RelatedRecordBuilder(
      service,
      key: key,
    );
  }

  const RelatedRecordBuilder(
    this.service, {
    super.key,
    this.id,
    this.builder,
    this.allowNull = false,
    this.initialValue,
    this.isSliver = false,
    this.loading = kLoader,
  });

  final Widget Function(V input)? builder;

  @override
  Widget build(BuildContext context) {
    assert(builder != null);
    assert(allowNull == true || (id != null || initialValue != null));
    if (id == null) {
      return initialValue == null ? loading() : builder!(initialValue as V);
    } else {
      var isInitialized = service.isInitialized(id as K);

      /// If the record is loaded into memory, use that memory value to have an immediate rendering.
      final calculatedInitialValue =
          isInitialized ? service.tryGet(id!)?.related : initialValue;

      if (sunny.get<IAuthState>().isNotLoggedIn) {
        return isSliver ? emptyBox.sliverBox() : emptyBox;
      }

      return StreamBuilder<V?>(
        stream: service

            /// We only stream updates because we will have fetched the _initialValue above
            .recordStream(id as K, immediate: calculatedInitialValue == null)!
            .where((event) => event != null)
            .map((input) => input!.related)
            .cast(),
        initialData: calculatedInitialValue,
        builder: (context, snapshot) => allowNull
            ? snapshot.render(
                context,
                loadingFn: loading,
                isSliver: isSliver,
                builder: (V? data, loading) {
                  return data == null ? loading() : builder!(data);
                },
              )
            : snapshot.render(
                context,
                isSliver: isSliver,
                loadingFn: loading,
                allowNull: allowNull,
                successFn: ((data) {
                  return builder!(data as V);
                }),
              ),
      );
    }
  }

  Widget call({
    required K? id,
    required Widget Function(V input) builder,
    bool allowNull = false,
    V? initialValue,
    bool isSliver = false,
    SimpleWidgetBuilder loading = kLoader,
  }) {
    return RelatedRecordBuilder(
      service,
      key: key,
      id: id,
      builder: builder,
      allowNull: allowNull,
      initialValue: initialValue,
      isSliver: isSliver,
      loading: loading,
    );
  }
}

class DataServiceBuilder<V> extends SunnyStreamBuilder<V> {
  final DataService<V> service;

  // ignore: non_constant_identifier_names
  static DataServiceBuilder<V> of<V>({
    Key? key,
    required DataService<V> service,
  }) {
    return DataServiceBuilder(
      service,
      key: key,
    );
  }

  DataServiceBuilder(
    this.service, {
    super.key,
    super.builder,
    super.nullBuilder,
    super.allowNull,
    super.isSliver,
    super.loading,
  }) : super(() {
          var initialData = service.currentValue;
          return Tuple(
              (initialData == null
                      ? service

                          /// We only stream updates because we will have fetched the _initialValue above
                          .stream
                      : service.updateStream)
                  .where((event) => event != null)
                  .cast(),
              initialData);
        });

  Widget call({
    required Widget Function(V input) builder,
    bool allowNull = false,
    V? initialValue,
    bool isSliver = false,
    SimpleWidgetBuilder loading = kLoader,
    SimpleWidgetBuilder? nullBuilder,
  }) {
    return DataServiceBuilder(
      service,
      key: key,
      builder: builder,
      allowNull: allowNull,
      isSliver: isSliver,
      loading: loading,
      nullBuilder: nullBuilder,
    );
  }
}

typedef StreamInitializeGetter<V> = Tuple<Stream<V>, V?> Function();
typedef ParameterizedStreamInitializeGetter<K, V> = Tuple<Stream<V>, V?>
    Function(K parameter);

class SunnyStreamBuilder<V> extends StatelessWidget {
  final StreamInitializeGetter<V> streamAndInitialValueGetter;
  final bool isSliver;
  // final K? id;
  final SimpleWidgetBuilder loading;
  final bool allowNull;
  final SimpleWidgetBuilder? nullBuilder;

  // ignore: non_constant_identifier_names
  static SunnyStreamBuilder<V> of<V>({
    Key? key,
    required Stream<V> stream,
    V? initialValue,
  }) {
    return SunnyStreamBuilder<V>(
      () => Tuple(stream, initialValue),
      key: key,
    );
  }

  // ignore: non_constant_identifier_names
  static SunnyStreamBuilder<V> get<V>(
    StreamInitializeGetter<V> getter, {
    Key? key,
  }) {
    return SunnyStreamBuilder<V>(
      getter,
      key: key,
    );
  }

  // ignore: non_constant_identifier_names
  static SunnyStreamBuilder<T> mapped<F, T>(
    StreamInitializeGetter<F> getter, {
    Key? key,
    required T map(F from),
    bool filter(T item)?,
    bool allowNull = false,
    bool isSliver = false,
    SimpleWidgetBuilder loading = kLoader,
  }) {
    return SunnyStreamBuilder<T>(
      () {
        final tuple = getter();
        var stream = tuple.first.map(map);
        var initial = tuple.second;
        if (filter != null) {
          stream = stream.where(filter);
        }

        T? initialMapped;
        if (initial is F) {
          initialMapped = map(initial);

          if (filter != null && !filter(initialMapped!)) {
            initialMapped = null;
          }
        }
        return Tuple(stream, initialMapped);
      },
      allowNull: allowNull,
      isSliver: isSliver,
      loading: loading,
      key: key,
    );
  }

  const SunnyStreamBuilder(
    this.streamAndInitialValueGetter, {
    super.key,
    this.builder,
    this.nullBuilder,
    this.allowNull = false,
    this.isSliver = false,
    this.loading = kLoader,
  });

  final Widget Function(V input)? builder;

  @override
  Widget build(BuildContext context) {
    assert(builder != null);

    if (sunny.get<IAuthState>().isNotLoggedIn) {
      return isSliver ? emptyBox.sliverBox() : emptyBox;
    }

    final tuple = streamAndInitialValueGetter();

    return StreamBuilder<V?>(
      stream: tuple.first,
      initialData: tuple.second,
      builder: (context, snapshot) => allowNull
          ? snapshot.render(
              context,
              loadingFn: loading,
              isSliver: isSliver,
              builder: (V? data, loading) {
                return data == null ? loading() : builder!(data);
              },
            )
          : snapshot.render(
              context,
              isSliver: isSliver,
              loadingFn: loading,
              allowNull: allowNull,
              successFn: ((data) {
                return builder!(data as V);
              }),
            ),
    );
  }

  Widget call({
    required Widget Function(V input) builder,
    bool allowNull = false,
    V? initialValue,
    bool isSliver = false,
    SimpleWidgetBuilder loading = kLoader,
    SimpleWidgetBuilder? nullBuilder,
  }) {
    return SunnyStreamBuilder(
      streamAndInitialValueGetter,
      key: key,
      builder: builder,
      allowNull: allowNull,
      nullBuilder: nullBuilder,
      isSliver: isSliver,
      loading: loading,
    );
  }

  SunnyStreamBuilder<T> map<T>({
    required Widget Function(T input) builder,
    required T map(V input),
    bool filter(T input)?,
    bool allowNull = false,
    bool isSliver = false,
    SimpleWidgetBuilder loading = kLoader,
  }) {
    return SunnyStreamBuilder.mapped<V, T>(streamAndInitialValueGetter,
        map: map,
        filter: filter,
        allowNull: allowNull,
        isSliver: isSliver,
        loading: loading);
  }
}

class SunnyParameterizedStreamBuilder<K, V> extends StatelessWidget {
  final ParameterizedStreamInitializeGetter<K, V> streamAndInitialValueGetter;
  final bool isSliver;
  final K? id;
  final SimpleWidgetBuilder loading;
  final bool allowNull;
  final SimpleWidgetBuilder? nullBuilder;

  static SunnyParameterizedStreamBuilder<K, V> of<K, V>(
    ParameterizedStreamInitializeGetter<K, V> getter, {
    Key? key,
  }) {
    return SunnyParameterizedStreamBuilder<K, V>(
      getter,
      key: key,
    );
  }

  const SunnyParameterizedStreamBuilder(
    this.streamAndInitialValueGetter, {
    super.key,
    this.builder,
    this.nullBuilder,
    this.id,
    this.allowNull = false,
    this.isSliver = false,
    this.loading = kLoader,
  });

  final Widget Function(V input)? builder;

  @override
  Widget build(BuildContext context) {
    assert(builder != null);

    if (sunny.get<IAuthState>().isNotLoggedIn) {
      return isSliver ? emptyBox.sliverBox() : emptyBox;
    }

    final tuple = streamAndInitialValueGetter(id!);

    return StreamBuilder<V?>(
      stream: tuple.first,
      initialData: tuple.second,
      builder: (context, snapshot) => allowNull
          ? snapshot.render(
              context,
              loadingFn: loading,
              isSliver: isSliver,
              builder: (V? data, loading) {
                return data == null ? loading() : builder!(data);
              },
            )
          : snapshot.render(
              context,
              isSliver: isSliver,
              loadingFn: loading,
              allowNull: allowNull,
              successFn: ((data) {
                return builder!(data as V);
              }),
            ),
    );
  }

  Widget call({
    required Widget Function(V input) builder,
    required K id,
    bool allowNull = false,
    V? initialValue,
    bool isSliver = false,
    SimpleWidgetBuilder loading = kLoader,
    SimpleWidgetBuilder? nullBuilder,
  }) {
    return SunnyParameterizedStreamBuilder(
      streamAndInitialValueGetter,
      key: key,
      id: id,
      builder: builder,
      allowNull: allowNull,
      nullBuilder: nullBuilder,
      isSliver: isSliver,
      loading: loading,
    );
  }
}
