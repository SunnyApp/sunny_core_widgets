import 'package:expanding_cards/expanding_cards.dart';
import 'package:flutter/material.dart';
import 'package:sunny_core_widgets/core_ext/layout_info.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';
import 'package:sunny_dart/sunny_dart.dart';
import 'package:sunny_essentials/slivers/resizing_pinned_header.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

import 'responsive_constraint.dart';
import 'sunny_page.dart';
import 'sunny_page_layouts.dart';

class BoxedDesktopPageLayout with SunnyPageLayoutMixin {
  final SunnyPageState state;

  BoxedDesktopPageLayout(this.state);

  @override
  Widget buildScrollView(BuildContext context, dynamic scrollables,
      Widget? headerSliver, PlatformLayoutInfo layoutInfo,
      {bool shrinkWrap = false}) {
    return CustomScrollView(
      controller: widget.scroller,
      shrinkWrap: shrinkWrap,
      slivers: [
        if (headerSliver != null) headerSliver,
        ..._desktopCard(context, scrollables),
      ],
    );
  }

  List<Widget> _desktopCard(BuildContext context, dynamic scrollables) {
    return [
      SliverFillRemaining(
        hasScrollBody: true,
        fillOverscroll: true,
        child: Layout.column().reset.build(
          [
            ResponsiveConstraint(
              child: HeroAnimation.expanded().provide(
                child: PlatformCard(
                  args: PlatformCardArgs(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    color: sunnyColors.scaffoldBackground,
                    height: 545.px,
                    width: 880.px,
                    borderRadius: SunnySpacing.sixteenPxRadiusAll,
                    shouldClip: true,
                  ),
                  child: SizedBox(
                    height: 545.px,
                    child: Layout.row().noFlex.spacing(0).crossMax.build(
                      [
                        if (widget.expanded != null)
                          Flexible(
                            flex: 489,
                            child: ClipRRect(
                              borderRadius: SunnySpacing.sixteenPxRadiusLeft,
                              child:
                                  widget.expanded!.buildUnconstrained(context),
                            ),
                          ),
                        Flexible(
                          flex: 391,
                          child: CustomScrollView(
                            slivers: expandScrollables(scrollables),
                          ),
                        ),
                        SizedBox(height: sunnySpacing * 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ];
  }

  /// On web, the top header is replaced by a static bar, and the "regular" header
  /// is placed down within the card
  Widget? buildHeader(
    BuildContext context,
    PlatformLayoutInfo layoutInfo,
  ) {
    if (widget.hideAppBar) return null;

    return SliverPersistentHeader(
      pinned: true,
      delegate: FixedPinnedHeader(
        child: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(vertical: sunnyColors.g200.borderSide1),
            color: Colors.white,
          ),
          child: Layout.row().spaceBetween.noFlex.build([
            Container(),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 880),
              child: Layout.row().spaceBetween.build(
                [
                  Align(alignment: Alignment.centerLeft, child: pageTitle),
                  if (widget.actions.isNotNullOrEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Layout.row().noFlex.build(widget.actions),
                    ),
                ],
              ),
            ),
            Container(),
          ]),
        ),
        fixedHeight: widget.headerHeight ?? SunnySpacing().appBarHeight,
      ),
    );
  }
}
