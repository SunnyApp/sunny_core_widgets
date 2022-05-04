import 'package:flutter/material.dart';
import 'package:sunny_platform_widgets/sunny_platform_widgets.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';


class MobilePageLayout with SunnyPageLayoutMixin {
  final SunnyPageState state;

  MobilePageLayout(this.state);

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
            // auautomaticallyImplyLeading: widget.isImpliedLeading,
            appBarColor: widget.appBarColor,
            pageBackground: overrideBg,
            onStretch: widget.onStretch,
            expanded: widget.expanded,
            showAppBarDivider: widget.showAppBarDivider,
          );
  }
}
