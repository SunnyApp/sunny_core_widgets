import 'package:flutter/material.dart';
import 'package:sunny_core_widgets/snapshots.dart';
import 'package:sunny_essentials/sunny_essentials.dart';
import 'package:sunny_sdk_core/sunny_sdk_core.dart';

typedef DataServiceWidgetBuilder<X> = Widget Function(X data, DataService<X> service);

typedef DataServiceWidgetBuilderWithContext<X> = Widget Function(BuildContext context, X data, DataService<X> service);

typedef RecordDataServiceWidgetBuilder<X, KType> = Widget Function(X data, RecordDataService<X, KType> service);

typedef RecordDataServiceWidgetBuilderWithContext<X, KType> = Widget Function(
    BuildContext context, X data, RecordDataService<X, KType> service);

extension DataServiceBuilder<X> on DataService<X> {
  Widget buildFromStream(
      {DataServiceWidgetBuilder<X>? builder,
      key,
      bool isSliver = false,
      bool crossFade = true,
      bool allowNull = false,
      SimpleWidgetBuilder loading = kLoader}) {
    final service = this;
    return StreamBuilder<X>(
      key: key is Key ? key : Key("${X}${key ?? 'StreamBuilder'}"),
      stream: service.stream.where((event) => event != null).cast(),
      builder: (context, snapshot) => snapshot.render(
        context,
        isSliver: isSliver,
        crossFade: crossFade,
        allowNull: allowNull,
        successFn: (X data) {
          return builder!(data, service);
        },
        loadingFn: loading,
      ),
      initialData: this.currentValue,
    );
  }

  Widget buildWithContext(
      {DataServiceWidgetBuilderWithContext<X>? builder,
      String? key,
      bool allowNull = false,
      bool isSliver = false,
      bool crossFade = true,
      SimpleWidgetBuilder? loading}) {
    final service = this;
    return StreamBuilder<X>(
      key: Key("${X}${key ?? 'StreamBuilder'}"),
      stream: service.stream.where((event) => event != null).cast(),
      initialData: service.currentValue,
      builder: (context, snapshot) => snapshot.render(
        context,
        allowNull: allowNull,
        crossFade: crossFade,
        isSliver: isSliver,
        successFn: (X data) {
          return builder!(context, data, service);
        },
      ),
    );
  }
}

extension RecordDataServiceBuilder<X, KType> on RecordDataService<X, KType> {
  Widget buildFromRecordStream(KType recordId,
      {RecordDataServiceWidgetBuilder<X, KType>? builder,
      String? key,
      X? initialValue,
      SimpleWidgetBuilder loadingFn = kLoader}) {
    final service = this;
    assert(recordId != null);
    return StreamBuilder<X>(
      key: Key("${X}${key ?? recordId}"),
      stream: service.recordStream(recordId)!.where((event) => event != null).cast(),
      initialData: initialValue,
      builder: (context, snapshot) => snapshot.render(
        context,
        loadingFn: loadingFn,
        successFn: (data) {
          return builder!(data, service);
        },
      ),
    );
  }

  Widget builder(
    KType recordId, {
    RecordDataServiceWidgetBuilderWithContext<X?, KType>? builder,
    WidgetDataBuilder<X>? successFn,
    String? key,
    bool isSliver = false,
    bool allowNull = false,

    /// This is useful when the record you want hasn't been loaded by this data
    /// service, but was loaded embedded into another object.  You can use that
    /// local version while you fetch the real one
    X? initialValue,
  }) {
    final service = this;
    assert(allowNull == true || (recordId != null || initialValue != null));
    if (recordId == null && initialValue == null) {
      return Builder(builder: (context) => builder!(context, null, this));
    }

    var isInitialized = service.isInitialized(recordId);

    /// If the record is loaded into memory, use that memory value to have an immediate rendering.
    final _initialValue = isInitialized ? service.tryGet(recordId) : initialValue;

    if (sunny.get<IAuthState>().isNotLoggedIn) {
      return isSliver ? emptyBox.sliverBox() : emptyBox;
    }
    return StreamBuilder<X>(
      key: Key("${X}${key ?? recordId}"),
      stream: service

          /// We only stream updates because we will have fetched the _initialValue above
          .recordStream(recordId, immediate: _initialValue == null)!
          .where((event) => event != null)
          .cast(),
      initialData: _initialValue,
      builder: (context, snapshot) => allowNull
          ? snapshot.render(
              context,
              isSliver: isSliver,
              builder: (X? data, loading) {
                return data == null ? loading() : builder!(context, data, service);
              },
            )
          : snapshot.render(
              context,
              isSliver: isSliver,
              allowNull: allowNull,
              successFn: successFn ??
                  ((X data) {
                    return builder!(context, data, service);
                  }),
            ),
    );
  }
}
