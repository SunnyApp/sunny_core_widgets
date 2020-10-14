import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef WidgetWrapFn = Widget Function(WidgetBuilder builder);
typedef WidgetWrapper = Widget Function(Widget widget);

// ignore: non_constant_identifier_names
Widget column(Iterable<Widget> children,
    {Color color, WidgetWrapper wrapper, Widget ifEmpty()}) {
  if (children.isEmpty && ifEmpty != null) {
    return ifEmpty();
  }
  return Container(
    color: color,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...?children?.map((widget) => wrapper?.call(widget) ?? widget),
      ],
    ),
  );
}

Widget stack(Iterable<Widget> children, {AlignmentGeometry alignment}) => Stack(
      alignment: alignment ?? Alignment.center,
      children: [...?children],
    );

Widget row(Iterable<Widget> children) => Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...?children,
        ],
      ),
    );

Widget centerRow(Iterable<Widget> children) => Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...?children,
        ],
      ),
    );

Widget centerColumn(Iterable<Widget> children, {Color color}) => Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...?children,
        ],
      ),
    );

// ignore: non_constant_identifier_names
Widget wrap(
        {Iterable<Widget> children,
        double runspacing = 5,
        double spacing = 10}) =>
    Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: spacing,
      runSpacing: runspacing,
      children: [
        ...?children,
      ],
    );
