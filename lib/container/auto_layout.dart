import 'package:expanding_cards/resizing_pinned_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sunny_core_widgets/container/dividing_line.dart';
import 'package:sunny_core_widgets/image/platform_network_image.dart';
import 'package:sunny_core_widgets/theme/sunny_spacing.dart';
import 'package:sunny_dart/sunny_dart.dart';

import 'standard_column.dart';

List<Widget> divide(Iterable<Widget> widgets, Widget wrapped) {
  return [
    ...widgets.mapPos((item, pos) {
      return [
        if (pos.isNotFirst && wrapped != null) wrapped,
        item,
      ];
    }).expand((_) => _)
  ];
}

class AutoLayout {
  Layout _layout;
  TextStyle _style;
  double _spacing = 8;
  double _radius = 24;
  bool _softWrap = true;
  Color _color;
  TextAlign _textAlign;
  bool _useFlex = true;
  bool _isMax;
  bool _isCrossMax;
  CrossAxisAlignment _crossAxisAlignment;
  Widget _divider;
  EdgeInsets _padding;
  EdgeInsets _margin;
  Color _backgroundColor;
  BorderRadius _borderRadius;
  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.center;
  MainAxisSize _mainAxisSize = MainAxisSize.min;
  List<WidgetWrapper> _wrappers = [];

  AutoLayout(this._layout);

  AutoLayout.of(
      this._layout,
      this._color,
      this._radius,
      this._softWrap,
      this._spacing,
      this._divider,
      this._style,
      this._textAlign,
      this._useFlex,
      this._isMax,
      this._isCrossMax,
      this._mainAxisAlignment,
      this._mainAxisSize,
      this._crossAxisAlignment,
      this._padding,
      this._margin,
      this._backgroundColor,
      this._borderRadius,
      this._wrappers);

  Widget build(Iterable items) {
    assert(_layout != null, "You cannot build unless you have a layout");
    return applyTo(items, this._layout);
  }

  Widget applyPadding(Widget widget) {
    if (_padding == null && _margin == null && _backgroundColor == null && _borderRadius == null) {
      return widget;
    }
    return Container(
        padding: _padding,
        margin: _margin,
        decoration: _borderRadius == null && _backgroundColor == null
            ? null
            : BoxDecoration(color: _backgroundColor, borderRadius: _borderRadius),
        child: widget);
  }

  Widget autoWidget(final dynamic item) {
    if (item is Widget) {
      return item;
    }
    if (item is IconData) {
      return Icon(
        item,
        size: _radius?.times(2),
        color: _color,
      );
    }
    if (item is Uri) {
      return PlatformNetworkImage("$item", height: _radius?.times(2));
    }
    return Text(item?.toString(),
        softWrap: _softWrap, textAlign: _textAlign, style: (_style ?? TextStyle())?.copyWith(color: _color));
  }

  Widget applyWrappers(Widget built) {
    for (final wrapper in _wrappers.reversed) {
      built = wrapper(built) ?? built;
    }
    return built;
  }

  Widget applyTo(Iterable items, Layout builder) {
    final space = builder.space(_spacing, this);
    final widgets = divide(
      items.whereNotNull().map((item) {
        return _useFlex == true ? Flexible(flex: 1, child: autoWidget(item)) : autoWidget(item);
      }),
      space,
    );
    var fromLayout = builder.wrapWidgets(widgets, this);
    return applyWrappers(fromLayout);
  }
}

typedef LayoutConfigure = void Function(AutoLayout container);

class Layout {
  Widget space(double space, AutoLayout container) => null;

  Widget wrapWidgets(List<Widget> items, AutoLayout container) =>
      illegalState("This builder cannot be used to perform layout");

  static const Layout _row = _RowBuilder();
  static const Layout _container = _ContainerBuilder();
  static const Layout _column = _ColumnBuilder();
  static const Layout _wrap = _WrapBuilder();
  static const Layout _widget = _WidgetBuilder();

  static AutoLayout row() {
    return AutoLayout(_row);
  }

  static AutoLayout container() {
    return AutoLayout(_container);
  }

  static AutoLayout column() {
    return AutoLayout(_column);
  }

  static AutoLayout wrap() {
    return AutoLayout(_wrap);
  }

  static AutoLayout autoWidget() {
    return AutoLayout(_widget);
  }

  const Layout();
}

class _RowBuilder implements Layout {
  @override
  Widget space(double space, AutoLayout container) => SizedBox(width: space);

  @override
  Widget wrapWidgets(List<Widget> items, AutoLayout container) => container.applyPadding(
        Row(
          mainAxisSize: container._mainAxisSize ?? (container._isMax == true ? MainAxisSize.max : MainAxisSize.min),
          crossAxisAlignment: container._crossAxisAlignment ??
              (container._isCrossMax == true ? CrossAxisAlignment.stretch : CrossAxisAlignment.center),
          mainAxisAlignment: container._mainAxisAlignment,
          children: items,
        ),
      );

  const _RowBuilder();
}

class _ContainerBuilder implements Layout {
  @override
  Widget space(double space, AutoLayout container) => SizedBox(width: space);

  @override
  Widget wrapWidgets(List<Widget> items, AutoLayout container) => container.applyPadding(
        Row(
          mainAxisSize: container._mainAxisSize ?? (container._isMax == true ? MainAxisSize.max : MainAxisSize.min),
          crossAxisAlignment: container._crossAxisAlignment ??
              (container._isCrossMax == true ? CrossAxisAlignment.stretch : CrossAxisAlignment.center),
          mainAxisAlignment: container._mainAxisAlignment,
          children: items,
        ),
      );

  Widget _single(Widget child, AutoLayout container) {
    final withPadding = container.applyPadding(
      Container(
        alignment: container._mainAxisAlignment?.toAlignment(),
        child: child,
      ),
    );
    final withWrappers = container.applyWrappers(withPadding);
    return withWrappers;
  }

  const _ContainerBuilder();
}

extension AutoLayoutConversion on MainAxisAlignment {
  Alignment toAlignment() {
    final self = this;
    switch (self) {
      case MainAxisAlignment.start:
        return Alignment.centerLeft;
        break;
      case MainAxisAlignment.end:
        return Alignment.centerRight;
        break;
      case MainAxisAlignment.center:
        return Alignment.center;
        break;
      case MainAxisAlignment.spaceBetween:
        return Alignment.center;
        break;
      case MainAxisAlignment.spaceAround:
        return Alignment.center;
        break;
      case MainAxisAlignment.spaceEvenly:
        return Alignment.center;
        break;
      default:
        return Alignment.center;
    }
  }
}

class _ColumnBuilder implements Layout {
  @override
  Widget space(double space, AutoLayout container) => SizedBox(height: space);

  @override
  Widget wrapWidgets(List<Widget> items, AutoLayout container) => container.applyPadding(
        Column(
          mainAxisAlignment: container._mainAxisAlignment,
          mainAxisSize: container._isMax == true ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: container._crossAxisAlignment ??
              (container._isCrossMax == true ? CrossAxisAlignment.stretch : CrossAxisAlignment.center),
          children: container._divider != null ? DividingLine.divideWithLines(items, container._divider) : items,
        ),
      );

  const _ColumnBuilder();
}

class _WrapBuilder extends Layout {
  @override
  Widget wrapWidgets(List<Widget> items, AutoLayout container) => container.applyPadding(Wrap(
        spacing: container._spacing,
        children: items,
      ));

  const _WrapBuilder() : super();
}

class _WidgetBuilder extends Layout {
  const _WidgetBuilder() : super();
}

extension AutoLayoutBuilderExt on AutoLayout {
  AutoLayout softWrap([bool isSoftWrap = true]) {
    return this.._softWrap = isSoftWrap == true;
  }

  AutoLayout style(TextStyle style) {
    return this.._style = style;
  }

  AutoLayout get noSpacing {
    return this.._spacing = 0;
  }

  AutoLayout spacing(double spacing) {
    return this.._spacing = spacing;
  }

  AutoLayout color(Color color) {
    return this.._color = color;
  }

  AutoLayout get nowrap {
    return this.._softWrap = false;
  }

  AutoLayout get flex {
    return this.._useFlex = true;
  }

  AutoLayout get noFlex {
    return this.._useFlex = false;
  }

  AutoLayout get reset {
    return this..noFlex.noSpacing;
  }

  AutoLayout radius(double radius) {
    return this.._radius = radius;
  }

  AutoLayout get textAlignLeft {
    return this.._textAlign = TextAlign.left;
  }

  AutoLayout get textAlignCenter {
    return this.._textAlign = TextAlign.center;
  }

  AutoLayout get textAlignRight {
    return this.._textAlign = TextAlign.right;
  }

  AutoLayout textAlign(TextAlign align) {
    return this.._textAlign = align;
  }

  AutoLayout get max {
    return this.._isMax = true;
  }

  AutoLayout get crossMax {
    return this
      .._isCrossMax = true
      .._crossAxisAlignment = CrossAxisAlignment.stretch;
  }

  AutoLayout get alignCenter {
    return this.._mainAxisAlignment = MainAxisAlignment.center;
  }

  AutoLayout get spaceAround {
    return this.._mainAxisAlignment = MainAxisAlignment.spaceAround;
  }

  AutoLayout get spaceBetween {
    return this.._mainAxisAlignment = MainAxisAlignment.spaceBetween;
  }

  AutoLayout get alignStart {
    return this.._mainAxisAlignment = MainAxisAlignment.start;
  }

  AutoLayout mainAlignment(MainAxisAlignment mainAxis) {
    return this.._mainAxisAlignment = mainAxis;
  }

  AutoLayout get min {
    return this.._mainAxisSize = MainAxisSize.min;
  }

  AutoLayout get mainAxisMax {
    return this.._mainAxisSize = MainAxisSize.max;
  }

  AutoLayout get alignEnd {
    return this.._mainAxisAlignment = MainAxisAlignment.end;
  }

  AutoLayout get alignLeft {
    return this.._mainAxisAlignment = MainAxisAlignment.start;
  }

  AutoLayout get crossAxisStart {
    return this.._crossAxisAlignment = CrossAxisAlignment.start;
  }

  AutoLayout get crossAxisCenter {
    return this.._crossAxisAlignment = CrossAxisAlignment.center;
  }

  AutoLayout get crossAxisEnd {
    return this.._crossAxisAlignment = CrossAxisAlignment.end;
  }

  AutoLayout get crossAxisStretch {
    return this.._crossAxisAlignment = CrossAxisAlignment.stretch;
  }

  AutoLayout get alignRight {
    return this.._mainAxisAlignment = MainAxisAlignment.end;
  }

  AutoLayout get divided {
    return this.._divider = dividingLine;
  }

  AutoLayout get dividedIndentLeft {
    return this.._divider = const DividingLine.indent();
  }

  AutoLayout get dividedIndentBoth {
    return this.._divider = const DividingLine.indent2();
  }

  EdgeInsets get _paddingOrCreate {
    return _padding ??= EdgeInsets.zero;
  }

  EdgeInsets get _marginOrCreate {
    return _margin ??= EdgeInsets.zero;
  }

  AutoLayout padTop(double num) {
    return this.._padding = _paddingOrCreate.copyWith(top: num);
  }

  AutoLayout padLeft(double num) {
    return this.._padding = _paddingOrCreate.copyWith(left: num);
  }

  AutoLayout padRight(double num) {
    return this.._padding = _paddingOrCreate.copyWith(right: num);
  }

  AutoLayout padBottom(double num) {
    return this.._padding = _paddingOrCreate.copyWith(bottom: num);
  }

  AutoLayout padVert(double num) {
    return this.._padding = _paddingOrCreate.copyWith(bottom: num, top: num);
  }

  AutoLayout padHoriz(double num) {
    return this.._padding = _paddingOrCreate.copyWith(left: num, right: num);
  }

  AutoLayout padAll(double num) {
    return this.._padding = EdgeInsets.all(num);
  }

  AutoLayout marginTop(double num) {
    return this.._margin = _marginOrCreate.copyWith(top: num);
  }

  AutoLayout marginLeft(double num) {
    return this.._margin = _marginOrCreate.copyWith(left: num);
  }

  AutoLayout marginRight(double num) {
    return this.._margin = _marginOrCreate.copyWith(right: num);
  }

  AutoLayout marginBottom(double num) {
    return this.._margin = _marginOrCreate.copyWith(bottom: num);
  }

  AutoLayout marginVert(double num) {
    return this.._margin = _marginOrCreate.copyWith(bottom: num, top: num);
  }

  AutoLayout marginHoriz(double num) {
    return this.._margin = _marginOrCreate.copyWith(left: num, right: num);
  }

  AutoLayout marginAll(double num) {
    return this.._margin = EdgeInsets.all(num);
  }

  AutoLayout backgroundColor(Color color) {
    return this.._backgroundColor = color;
  }

  AutoLayout borderRadiusAll([double radius = 12]) {
    return this.._borderRadius = BorderRadius.circular(radius);
  }

  AutoLayout borderRadius(BorderRadius radius) {
    return this.._borderRadius = radius;
  }

  AutoLayout isHeader({bool pinned = false, bool floating = false, double height, double expandedHeight}) {
    assert(height != null);
    return this
      .._wrappers.add((widget) {
        final delegate = (expandedHeight != null && expandedHeight != height)
            ? ResizingPinnedHeader(
                expandedHeight: expandedHeight,
                minExtent: height,
                builder: (double height, double ratio, Widget child) => widget,
                child: widget)
            : FixedPinnedHeader(child: widget, fixedHeight: height);
        return SliverPersistentHeader(
          delegate: delegate,
          pinned: pinned,
          floating: floating,
        );
      });
  }

  /// Expands in both directions
  AutoLayout get expand {
    return this
      ..max
      ..crossMax;
  }

  AutoLayout copy() {
    return AutoLayout.of(
        _layout,
        _color,
        _radius,
        _softWrap,
        _spacing,
        _divider,
        _style,
        _textAlign,
        _useFlex,
        _isMax,
        _isCrossMax,
        _mainAxisAlignment,
        _mainAxisSize,
        _crossAxisAlignment,
        _padding,
        _margin,
        _backgroundColor,
        _borderRadius,
        _wrappers);
  }

  R using<R>(R block(AutoLayout layout)) {
    return block(this);
  }
}

extension AutoLayoutSingleExt on AutoLayout {
  Widget single(Widget child) {
    if (this._layout is _ContainerBuilder) {
      return (this._layout as _ContainerBuilder)._single(child, this);
    } else {
      return this.build([child]);
    }
  }
}

extension WidgetListExtensions on List<Widget> {
  List<Widget> toSlivers() {
    return [
      for (var w in this) SliverToBoxAdapter(child: w),
    ];
  }

  List<Widget> hpadEach([int units = 2]) {
    return [
      for (var c in this) Padding(padding: EdgeInsets.symmetric(horizontal: sunnySpacing.spaceUnit * units), child: c)
    ];
  }

  List<Widget> bpad([int units = 2]) {
    return [
      ...this,
      sunnySpacing.vspace(units),
    ];
  }
}
