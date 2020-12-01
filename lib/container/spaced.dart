import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sunny_core_widgets/theme/sunny_spacing.dart';
import 'package:sunny_core_widgets/theme.dart';

// Applies the space between each item in the list.  No space is applied after the last item in the list.
List<Widget> spaced({List<Widget> children, EdgeInsets space}) {
  space ??= EdgeInsets.all(sunnySpacing.spaceUnit);
  final spaced = children
      .map((item) =>
          item is Flexible ? item : Container(padding: space, child: item))
      .toList();
  return spaced;
}

SunnyPad shim(Widget child) => SunnyPad._(
    child: child, padding: EdgeInsets.all(sunnySpacing.spaceUnit * 0.5));

SunnyPad pad(Widget child) => SunnyPad(child: child);

SunnyPad wpad(Widget child) => SunnyPad(child: child, color: Colors.white);

SunnyPad hpad(Widget child, [bool white = true]) => SunnyPad.horizontal(
    child: child, color: white == true ? Colors.white : null);

SunnyPad vpad(Widget child, [bool white = true]) =>
    SunnyPad.vertical(child: child, color: white == true ? Colors.white : null);

class SunnyPad extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;

  SunnyPad({Key key, this.child, this.color, bool dense})
      : padding = dense == true ? sunnySpacing.half : sunnySpacing.all,
        super(key: key);

  const SunnyPad._({Key key, this.child, this.color, this.padding})
      : super(key: key);

  SunnyPad.vertical({Key key, this.child, Color color, bool dense, bool opaque})
      : padding = dense == true ? sunnySpacing.vert / 2 : sunnySpacing.vert,
        color = opaque == true ? sunnyColors.white : color,
        super(key: key);

  SunnyPad.horizontal(
      {Key key, this.child, Color color, bool dense, bool opaque})
      : padding = dense == true ? sunnySpacing.horiz / 2 : sunnySpacing.horiz,
        color = opaque == true ? sunnyColors.white : color,
        super(key: key);

  SunnyPad._header({Key key, this.child})
      : padding = sunnySpacing.horiz * 2,
        color = sunnyColors.appBarBackground,
        super(key: key);

  static Widget header({
    Key key,
    @required Widget child,
    @required double height,
  }) =>
      PreferredSize(
        key: key,
        child: SunnyPad._header(child: child),
        preferredSize: Size.fromHeight(height),
      );

  @override
  Widget build(BuildContext context) {
    return Container(color: color, padding: padding, child: child);
  }

  SunnyPad operator *(double amount) {
    return SunnyPad._(
      child: child,
      color: color,
      padding: padding * amount,
    );
  }
}

class SunnyMargin extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool dense;

  const SunnyMargin({Key key, this.child, this.color, this.dense})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color,
        margin: dense == true ? sunnySpacing.half : sunnySpacing.all,
        child: child);
  }
}

const horizontalSpace = HorizontalSpace();
const horizontalShim = HorizontalSpace(0.5);
const doubleHorizontalSpace = HorizontalSpace(2);
const verticalSpace = VerticalSpace();

Widget verticalSpacer(double size) => SizedBox(height: size);
const verticalShim = VerticalSpace(0.5);
const emptyBox = SizedBox(width: 0, height: 0);
const expandedBox = Expanded(child: SizedBox());
const sliverEmptyBox = SliverToBoxAdapter(child: emptyBox);
const sliverLoader = const SliverFillRemaining(
    child: Center(child: CircularProgressIndicator()));
Widget sliverLoaderFn() {
  return sliverLoader;
}
const sliverSpinner = sliverLoader;
const sliverSpinnerFn = sliverLoaderFn;

const noBorder = const Border.fromBorderSide(BorderSide.none);

class HorizontalSpace extends StatelessWidget {
  final double units;

  const HorizontalSpace([this.units = 1.0]) : super();

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: sunnySpacing.spaceUnit * units);

  HorizontalSpace operator *(double num) => HorizontalSpace(this.units * num);
}

class VerticalSpace extends StatelessWidget {
  final double units;

  const VerticalSpace([this.units = 1.0]) : super();

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: sunnySpacing.spaceUnit * units);

  VerticalSpace operator *(double num) => VerticalSpace(this.units * num);

  VerticalSpace operator /(double num) => VerticalSpace(this.units / num);
}
