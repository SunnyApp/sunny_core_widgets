import 'package:flutter/material.dart';
import 'package:sunny_core_widgets/container/spaced.dart';
import 'package:sunny_core_widgets/snapshots.dart';
import 'package:sunny_sdk_core/sunny_sdk_core.dart';

typedef DataServiceWidgetBuilder<X> = Widget Function(
    X data, DataService<X> service);

typedef DataServiceWidgetBuilderWithContext<X> = Widget Function(
    BuildContext context, X data, DataService<X> service);

typedef RecordDataServiceWidgetBuilder<X> = Widget Function(
    X data, RecordDataService<X> service);

typedef RecordDataServiceWidgetBuilderWithContext<X> = Widget Function(
    BuildContext context, X data, RecordDataService<X> service);

extension DataServiceBuilder<X> on DataService<X> {
  Widget buildFromStream(
      {DataServiceWidgetBuilder<X> builder,
      key,
      bool isSliver = false,
      bool crossFade = true,
      bool allowNull = false,
      SimpleWidgetBuilder loading}) {
    final service = this;
    return StreamBuilder<X>(
      key: key is Key ? key : Key("${X}${key ?? 'StreamBuilder'}"),
      stream: service.stream,
      builder: (context, snapshot) => snapshot.render(
        context,
        isSliver: isSliver,
        crossFade: crossFade,
        allowNull: allowNull,
        successFn: (data) {
          return builder(data, service);
        },
        loadingFn: loading,
      ),
      initialData: this.currentValue,
    );
  }

  Widget buildWithContext(
      {DataServiceWidgetBuilderWithContext<X> builder,
      String key,
      bool allowNull = false}) {
    final service = this;
    return StreamBuilder<X>(
      key: Key("${X}${key ?? 'StreamBuilder'}"),
      stream: service.stream,
      initialData: service.currentValue,
      builder: (context, snapshot) =>
          snapshot.render(context, allowNull: allowNull, successFn: (data) {
        return builder(context, data, service);
      }),
    );
  }
}

extension RecordDataServiceBuilder<X> on RecordDataService<X> {
  Widget buildFromRecordStream(String recordId,
      {RecordDataServiceWidgetBuilder<X> builder, String key}) {
    final service = this;
    assert(recordId != null);
    return StreamBuilder<X>(
      key: Key("${X}${key ?? recordId}"),
      stream: service.recordStream(recordId),
      builder: (context, snapshot) =>
          snapshot.render(context, successFn: (data) {
        return builder(data, service);
      }),
    );
  }

  Widget builder(
    String recordId, {
    RecordDataServiceWidgetBuilderWithContext<X> builder,
    String key,
    bool allowNull = false,

    /// This is useful when the record you want hasn't been loaded by this data
    /// service, but was loaded embedded into another object.  You can use that
    /// local version while you fetch the real one
    X initialValue,
  }) {
    final service = this;
    assert(recordId != null || initialValue != null);
    final _initialValue = service.isLoaded(recordId) ? null : initialValue;
    if (Sunny.get<IAuthState>().isNotLoggedIn) {
      return emptyBox;
    }
    return StreamBuilder<X>(
      key: Key("${X}${key ?? recordId}"),
      stream: service.recordStream(recordId),
      initialData: _initialValue,
      builder: (context, snapshot) => snapshot.render(
        context,
        allowNull: allowNull,
        successFn: (data) {
          return builder(context, data, service);
        },
      ),
    );
  }
}
