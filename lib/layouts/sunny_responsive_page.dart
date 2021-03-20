import 'package:expanding_cards/expanding_cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunny_core_widgets/core_ext/layout_info.dart';
import 'package:sunny_core_widgets/layouts/sunny_page.dart';
import 'package:sunny_core_widgets/layouts/sunny_page_layouts.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

typedef WidgetFactory = Widget Function();
typedef WidgetContextFactory = Widget Function(BuildContext context);
typedef DynamicContextFactory = dynamic Function(BuildContext context);
typedef WidgetScrollerContextFactory = Widget Function(
    BuildContext context, ScrollController controller);
typedef WidgetListFactory = List<Widget> Function();
typedef WidgetListContextFactory = List<Widget> Function(BuildContext context);
typedef WidgetListScrollerContextFactory = List<Widget> Function(
    BuildContext context, ScrollController controller);

@deprecated
class SunnyResponsivePage extends SunnyPage {
  final dynamic body;

  final dynamic pageTitle;
  final WidgetBuilder fab;
  final Widget leading;
  final AsyncCallback onStretch;
  final List<Widget> actions;
  final bool hideAppBar;
  final bool cachePage;
  final HeroBar expanded;
  final bool showTabBarWithKeyboard;
  final DecorationImage bgImage;
  final Widget underlay;
  final Widget overlay;
  final Color appBarColor;
  final bool isWhiteBg;
  final double headerHeight;
  final ScrollController scroller;
  final bool isImpliedLeading;
  final bool showAppBarDivider;
  final bool isContentPadding;
  final SunnyPageLayoutFactory layout;
  final bool useBody;

  const SunnyResponsivePage(
      {Key key,
      this.body,
      this.expanded,
      this.useBody = false,
      this.isWhiteBg = false,
      this.pageTitle,
      this.cachePage = false,
      this.isContentPadding = true,
      this.leading,
      this.isImpliedLeading = true,
      this.headerHeight,
      this.actions,
      this.showAppBarDivider = false,
      this.showTabBarWithKeyboard = false,
      this.hideAppBar = false,
      this.fab,
      this.appBarColor,
      this.scroller,
      this.bgImage,
      this.underlay,
      this.overlay,
      this.onStretch,
      this.layout})
      : assert(pageTitle == null || pageTitle is String || pageTitle is Widget),
        assert(useBody != true || body is Widget),
        super(key: key);

  @override
  SunnyResponsivePageState createState() => SunnyResponsivePageState();
}

class SunnyResponsivePageState extends SunnyPageState {
  SunnyPageLayout _layout;

  @override
  void initState() {
    super.initState();
    _layout =
        (widget.layout ?? (state) => ResponsivePageLayout(state)).call(this);
  }

  @override
  void dispose() {
    _layout.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    final _layoutInfo = context.sub<LayoutInfo>();
    final platformLayoutInfo = PlatformLayoutInfo.ofLayoutInfo(
      _layoutInfo,
      Theme.of(context).platform,
      _mediaQuery.padding,
      context.get(),
    );
    return Provider.value(
      value: platformLayoutInfo,
      child: _layout.build(context, platformLayoutInfo),
      updateShouldNotify: (a, b) => a != b,
    );
  }
}
