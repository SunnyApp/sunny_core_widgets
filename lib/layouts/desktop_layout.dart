import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sunny_core_widgets/core_ext/layout_info.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

import 'responsive_constraint.dart';
import 'sunny_page.dart';
import 'sunny_page_layouts.dart';

class DesktopPageLayout with SunnyPageLayoutMixin {
  final SunnyPageState state;

  const DesktopPageLayout(this.state);

  @override
  Widget buildScrollView(BuildContext context, dynamic scrollables,
      Widget? headerSliver, PlatformLayoutInfo layoutInfo,
      {bool shrinkWrap = false}) {
    var psc = PrimaryScrollController.of(context);
    return super.buildScrollViewWithWrapper(
      context,
      scrollables,
      headerSliver,
      layoutInfo,
      sliverWrapper: (slivers) => ResponsiveSliverConstraint(sliver: slivers),
      shrinkWrap: shrinkWrap,
    );
  }

  @override
  Widget? buildHeader(BuildContext context, PlatformLayoutInfo layoutInfo) {
    final overrideBg = widget.isWhiteBg ? sunnyColors.white : null;
    return pageTitle == null
        ? null
        : SunnyPageLayout.buildAppBar(
            context,
            headerHeight: widget.headerHeight,
            centerTitle: layoutInfo.platformStyle == PlatformStyle.Cupertino,
            pageTitle: pageTitle,
            actions: widget.actions,
            leading: widget.leading,
            appBarColor: widget.appBarColor,
            pageBackground: overrideBg,
            onStretch: widget.onStretch,
            expanded: widget.expanded,
            showAppBarDivider: widget.showAppBarDivider,
          );
  }

// /// On web, the top header is replaced by a static bar, and the "regular" header
// /// is placed down within the card
// Widget buildHeader(
//   BuildContext context,
//   PlatformLayoutInfo layoutInfo,
// ) {
//   if (widget.hideAppBar) return null;
//
//   return SliverPersistentHeader(
//     pinned: true,
//     delegate: FixedPinnedHeader(
//       child: Hero(
//         tag: "sunny-desktop-header",
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.symmetric(vertical: sunnyColors.g200.borderSide1),
//             color: Colors.white,
//           ),
//           child: Layout.row().spaceBetween.noFlex.build([
//             Container(),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: 880),
//               child: Layout.row().spaceBetween.build(
//                 [
//                   Align(alignment: Alignment.centerLeft, child: pageTitle),
//                   if (widget.actions.isNotNullOrEmpty)
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: Layout.row().noFlex.build(widget.actions),
//                     ),
//                 ],
//               ),
//             ),
//             Container(),
//           ]),
//         ),
//       ),
//       fixedHeight: widget.headerHeight ?? SunnySpacing().appBarHeight,
//     ),
//   );
// }
}
