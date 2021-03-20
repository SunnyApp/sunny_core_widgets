import 'package:flutter/cupertino.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sunny_core_widgets/core_ext.dart';

import 'package:sunny_essentials/sunny_essentials.dart';

class ResponsiveConstraint extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveConstraint({Key key, this.child, this.maxWidth = 880})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceScreenType screenType = context.sub<LayoutInfo>().screenType;
    switch (screenType) {
      // ignore: deprecated_member_use
      case DeviceScreenType.Mobile:
      case DeviceScreenType.mobile:
        return child;

      default:
        return ResponsiveBuilder(
            builder: (context, size) => Center(
                  child: Layout.row().noFlex.spaceAround.crossAxisStart.build([
                    SizedBox(width: maxWidth ?? 880, child: child),
                  ]),
                ));
    }
  }
}

class ResponsiveSliverConstraint extends StatelessWidget {
  final Widget sliver;
  final double maxWidth;

  const ResponsiveSliverConstraint({Key key, this.sliver, this.maxWidth = 880})
      : super(key: key);

  ResponsiveSliverConstraint.ofBox({Key key, Widget child, this.maxWidth = 880})
      : sliver = sliverBox(child),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceScreenType screenType = context.sub<LayoutInfo>().screenType;
    switch (screenType) {
      // ignore: deprecated_member_use
      case DeviceScreenType.Mobile:
      case DeviceScreenType.mobile:
        return sliver;

      default:
        return SliverLayoutBuilder(builder: (context, size) {
          final cx = size.crossAxisExtent;
          if (cx <= maxWidth) {
            return sliver;
          } else {
            final x2 = (cx - maxWidth) / 2;
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
  Widget get responsive {
    return ResponsiveConstraint(
      child: this,
    );
  }
}
