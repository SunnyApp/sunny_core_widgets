import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sunny_core_widgets/core_ext.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

const kDefaultResponsiveWidth = 880.0;

class ResponsiveConstraint extends StatelessWidget {
  final Widget? child;
  final double maxWidth;
  final ResponsiveMaxWidth? calculated;

  static ResponsiveConstraint of(
    Widget child, {
    double maxWidth = kDefaultResponsiveWidth,
    ResponsiveMaxWidth? calculated,
  }) =>
      ResponsiveConstraint(
        child: child,
        maxWidth: maxWidth,
        calculated: calculated,
      );

  const ResponsiveConstraint({
    Key? key,
    this.child,
    this.maxWidth = kDefaultResponsiveWidth,
    this.calculated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceScreenType screenType = context.sub<LayoutInfo>().screenType;
    switch (screenType) {
      // ignore: deprecated_member_use
      case DeviceScreenType.Mobile:
      case DeviceScreenType.mobile:
        return child!;

      default:
        var mq = MediaQuery.of(context);
        final width = mq.size.width;

        return ResponsiveBuilder(
          builder: (context, size) {
            final _maxWidth = calculated?.call(size) ?? maxWidth;

            return width <= _maxWidth
                ? child!
                : Center(
                    child: Layout.row().noFlex.spaceAround.crossAxisStart.build([
                      SizedBox(
                        width: _maxWidth,
                        child: child,
                      ),
                    ]),
                  );
          },
        );
    }
  }
}

typedef ResponsiveMaxWidth = double Function(SizingInformation sizing);
typedef ResponsiveSliverMaxWidth = double Function(BuildContext context, SliverConstraints sizing);

class ResponsiveSliverConstraint extends StatelessWidget {
  final Widget? sliver;
  final double maxWidth;
  final ResponsiveSliverMaxWidth? calculated;

  const ResponsiveSliverConstraint({
    Key? key,
    this.sliver,
    this.maxWidth = kDefaultResponsiveWidth,
    this.calculated,
  }) : super(key: key);

  ResponsiveSliverConstraint.ofBox({
    Key? key,
    required Widget child,
    this.calculated,
    this.maxWidth = kDefaultResponsiveWidth,
  })  : sliver = sliverBox(child),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceScreenType screenType = context.sub<LayoutInfo>().screenType;
    switch (screenType) {
      // ignore: deprecated_member_use
      case DeviceScreenType.Mobile:
      case DeviceScreenType.mobile:
        return sliver!;

      default:
        return SliverLayoutBuilder(builder: (context, size) {
          final cx = size.crossAxisExtent;
          final _maxWidth = calculated?.call(context, size) ?? maxWidth;

          if (cx <= _maxWidth) {
            return sliver!;
          } else {
            final x2 = (cx - _maxWidth) / 2;
            return SliverPadding(
              sliver: sliver,
              padding: EdgeInsets.symmetric(horizontal: x2),
            );
          }
        });
    }
  }
}

extension WidgetConstraint on Widget {
  Widget responsive({
    double maxWidth = kDefaultResponsiveWidth,
    ResponsiveMaxWidth? calculated,
  }) {
    return ResponsiveConstraint(
      child: this,
      maxWidth: maxWidth,
      calculated: calculated,
    );
  }

  Widget responsiveSliver({
    double maxWidth = kDefaultResponsiveWidth,
    ResponsiveSliverMaxWidth? calculated,
  }) {
    return ResponsiveSliverConstraint(
      sliver: this,
      maxWidth: maxWidth,
      calculated: calculated,
    );
  }
}

extension IterableWidgetConstraint on Iterable<Widget> {
  List<Widget> responsive({
    double maxWidth = kDefaultResponsiveWidth,
    ResponsiveMaxWidth? calculated,
  }) {
    return [
      for (var self in this)
        ResponsiveConstraint(
          child: self,
          maxWidth: maxWidth,
          calculated: calculated,
        ),
    ];
  }

  List<Widget> sliverResponsive({
    double maxWidth = kDefaultResponsiveWidth,
    ResponsiveSliverMaxWidth? calculated,
  }) {
    return [
      for (var self in this)
        ResponsiveSliverConstraint(
          sliver: self,
          maxWidth: maxWidth,
          calculated: calculated,
        ),
    ];
  }
}
