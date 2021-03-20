import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sunny_core_widgets/core_ext/layout_info.dart';
import 'package:sunny_core_widgets/layouts/sunny_page.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

import 'sunny_page_layouts.dart';

class MobilePageLayout with SunnyPageLayoutMixin {
  final SunnyPageState state;

  MobilePageLayout(this.state);

  @override
  Widget buildHeader(BuildContext context, PlatformLayoutInfo layoutInfo) {
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
