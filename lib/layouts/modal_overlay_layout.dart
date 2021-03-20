import 'package:flutter/material.dart';
import 'package:sunny_core_widgets/core_ext/layout_info.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

import 'sunny_page.dart';
import 'sunny_page_layouts.dart';

class ModalOverlayLayout with SunnyPageLayoutMixin implements SunnyPageLayout {
  final SunnyPageState state;
  final bool shrinkWrap;

  const ModalOverlayLayout(this.state, {this.shrinkWrap = true});

  @override
  Widget buildScrollView(BuildContext context, dynamic scrollables,
      Widget? headerSliver, PlatformLayoutInfo layoutInfo,
      {bool shrinkWrap = false}) {
    return CustomScrollView(
      controller: widget.scroller,
      shrinkWrap: shrinkWrap,
      slivers: [
        if (headerSliver != null) headerSliver,
        ...scrollables,
      ],
    );
  }

  /// A modal page doesn't need a scaffold, and doesn't take up as much space as possible
  @override
  Widget wrapInScaffold(BuildContext context, PlatformLayoutInfo info) {
    final SunnyPage widget = state.widget;
    final overrideBg = widget.isWhiteBg ? sunnyColors.white : null;
    var pageGuts = (widget.fab != null ||
            widget.underlay != null ||
            widget.overlay != null)
        ? Stack(
            children: [
              if (widget.underlay != null) widget.underlay!,
              buildPageGuts(context, info),
              if (widget.fab != null) widget.fab!(context),
              if (widget.overlay != null) widget.overlay!,
            ],
          )
        : buildPageGuts(context, info, shrinkWrap: shrinkWrap);
    return Container(
      color: overrideBg ?? sunnyColors.scaffoldBackground,
      child: pageGuts,
    );
  }

  /// On web, the top header is replaced by a static bar, and the "regular" header
  /// is placed down within the card
  Widget? buildHeader(
    BuildContext context,
    PlatformLayoutInfo layoutInfo,
  ) {
    final overrideBg = widget.isWhiteBg ? sunnyColors.white : null;
    return pageTitle == null
        ? null
        : SunnyPageLayout.buildAppBar(
            context,
            headerHeight: widget.headerHeight,
            centerTitle: true,
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
}
