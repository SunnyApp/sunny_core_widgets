import 'package:expanding_cards/expanding_cards.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:logging/logging.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sunny_core_widgets/core_ext/layout_info.dart';
import 'package:sunny_core_widgets/routes.dart';
import 'package:sunny_essentials/sunny_essentials.dart';
import 'package:info_x/info_x.dart';

import 'desktop_layout.dart';
import 'mobile_layout.dart';
import 'sunny_page.dart';
import 'sunny_responsive_page.dart';

class ResponsivePageLayout extends SunnyPageLayout {
  final SunnyPageState state;
  final DesktopPageLayout desktop;
  final MobilePageLayout mobile;

  ResponsivePageLayout(this.state)
      : desktop = DesktopPageLayout(state),
        mobile = MobilePageLayout(state);

  @override
  Widget build(BuildContext context, PlatformLayoutInfo layoutInfo) {
    return infoX.isIOS
        ? mobile.build(context, layoutInfo)
        : desktop.build(context, layoutInfo);
  }
}

typedef SliverWrapper = Widget Function(Widget widget);
typedef SunnyPageLayoutFactory = SunnyPageLayout Function(SunnyPageState state);

final _log = Logger("sunnyLayout");

mixin SunnyPageLayoutMixin implements SunnyPageLayout {
  Widget? buildHeader(BuildContext context, PlatformLayoutInfo layoutInfo);

  void _verifyNoHeader(Widget? headerSliver) {
    if (headerSliver != null) {
      _log.warning(
          "Potential loss of header!  If your body is a CustomScrollView, you shouldn't also"
          "return a separate header");
    }
  }

  Widget buildScrollView(BuildContext context, final dynamic scrollables,
      Widget? headerSliver, PlatformLayoutInfo layoutInfo,
      {required bool shrinkWrap}) {
    return buildScrollViewWithWrapper(
      context,
      scrollables,
      headerSliver,
      layoutInfo,
      shrinkWrap: shrinkWrap,
    );
  }

  Widget buildScrollViewWithWrapper(
      BuildContext context,
      final dynamic scrollables,
      Widget? headerSliver,
      PlatformLayoutInfo layoutInfo,
      {SliverWrapper sliverWrapper = sameWidget,
      bool shrinkWrap = false}) {
    var psc = PrimaryScrollController.of(context);
    var msc = ModalScrollController.of(context);
    var scroller = msc ?? psc;
    if (scrollables is CustomScrollView ||
        scrollables is NestedScrollView ||
        widget.useBody == true) {
      _verifyNoHeader(headerSliver);
      return scrollables as Widget;
    } else if (scrollables is StreamBuilder) {
      return scrollables;
    } else if (scrollables is Widget) {
      if (scroller?.hasClients == true) {
        scroller = null;
      }
      return CustomScrollView(
        controller: widget.scroller ?? scroller,
        shrinkWrap: shrinkWrap,
        physics: scroller == null
            ? AlwaysScrollableScrollPhysics()
            : ModalScrollPhysics(),
        slivers: [
          if (headerSliver != null) headerSliver,
          scrollables,
        ],
      );
    } else {
      if (scroller?.hasClients == true) {
        scroller = null;
      }
      return CustomScrollView(
        controller: widget.scroller ?? scroller,
        shrinkWrap: shrinkWrap,
        physics: scroller == null
            ? AlwaysScrollableScrollPhysics()
            : ModalScrollPhysics(),
        slivers: [
          if (headerSliver != null) headerSliver,
          if (scrollables is List<Widget>)
            for (var sliver in scrollables) sliverWrapper(sliver),
        ],
      );
    }
  }

  Widget? get pageTitle {
    return (widget.pageTitle is String)
        ? AppBarTitle(widget.pageTitle as String)
        : widget.pageTitle as Widget?;
  }

  @mustCallSuper
  void dispose() {}

  SunnyPage get widget => state.widget;

  Widget build(BuildContext context, PlatformLayoutInfo info) {
    return wrapInScaffold(context, info);
  }

  Widget buildPageGuts(BuildContext context, PlatformLayoutInfo layoutInfo,
      {bool shrinkWrap = false}) {
    return Builder(builder: (scaffoldCtx) {
      final scrollables = buildScrollables(scaffoldCtx, layoutInfo, shrinkWrap);
      final sliverHeader = buildHeader(scaffoldCtx, layoutInfo);

      return buildScrollView(scaffoldCtx, scrollables, sliverHeader, layoutInfo,
          shrinkWrap: shrinkWrap);
    });
  }

  List<Widget> expandScrollables(final dynamic scrollables) {
    if (scrollables is List<Widget>) {
      return scrollables;
    } else {
      return [scrollables as Widget];
    }
  }

  Widget wrapInScaffold(BuildContext context, PlatformLayoutInfo info) {
    final SunnyPage widget = state.widget;
    final overrideBg = widget.isWhiteBg ? sunnyColors.white : null;
    return CupertinoScaffold(
      body: PlatformScaffold(
        iosContentBottomPadding: widget.showTabBarWithKeyboard,
        backgroundColor: overrideBg ?? sunnyColors.scaffoldBackground,
        iosContentPadding: widget.isContentPadding,
        cupertino: (context, platform) => CupertinoPageScaffoldData(
          backgroundColor: overrideBg ?? sunnyColors.scaffoldBackground,
          resizeToAvoidBottomInset: widget.isContentPadding,
          resizeToAvoidBottomInsetTab: widget.isContentPadding,
          backgroundColorTab: sunnyColors.white.withOpacity(0.2),
        ),
        body: (widget.fab != null ||
                widget.underlay != null ||
                widget.overlay != null)
            ? Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.underlay != null) widget.underlay!,
                  buildPageGuts(context, info),
                  if (widget.fab != null) widget.fab!(context),
                  if (widget.overlay != null) widget.overlay!,
                ],
              )
            : buildPageGuts(context, info),
      ),
    );
  }

  /// Returns either a single widget (may be a CustomScrollView) or a List of widgets
  dynamic buildScrollables(
    BuildContext context,
    PlatformLayoutInfo layoutInfo,
    bool shrinkWrap, [
    dynamic _body,
  ]) {
    _body ??= _body ?? widget.body;

    if (_body is Stream<Widget>) {
      final sb = StreamBuilder<Widget>(
        stream: _body,
        builder: (context, snap) {
          return snap.data ?? sliverEmptyBox;
        },
      );
      _body = sb;
    } else if (_body is Stream<List<Widget>>) {
      return StreamBuilder<List<Widget>>(
        stream: _body,
        builder: (context, snap) {
          return buildScrollView(
            context,
            snap.data ?? <Widget>[],
            buildHeader(context, layoutInfo),
            layoutInfo,
            shrinkWrap: shrinkWrap,
          );
        },
      );
    } else if (_body is Function) {
      late DynamicContextFactory producer;
      if (_body is WidgetFactory || _body is WidgetListFactory) {
        producer = (_) => _body();
      } else if (_body is WidgetContextFactory ||
          _body is WidgetListContextFactory) {
        producer = (context) => _body(context);
      } else if (_body is WidgetScrollerContextFactory ||
          _body is WidgetListScrollerContextFactory) {
        producer = (context) => _body(context, widget.scroller);
      }

      _body = producer(context);
    }
    assert(_body is Widget || _body is List<Widget>,
        "Body must produce a widget or list of widgets but was ${_body?.runtimeType ?? 'null'}");

    return _body;
  }
}

abstract class SunnyPageLayout {
  SunnyPageState get state;

  SunnyPage get widget => state.widget;

  const SunnyPageLayout();

  @mustCallSuper
  void dispose() {}

  Widget build(BuildContext context, PlatformLayoutInfo layoutInfo);

  static SliverAppBar buildAppBar(
    BuildContext context, {
    double? headerHeight,
    bool? centerTitle,
    Widget? pageTitle,
    Widget? leading,
    bool pinned = true,
    bool floating = false,
    List<Widget>? actions,
    Color? appBarColor,
    Color? pageBackground,
    AsyncCallback? onStretch,
    bool? showAppBarDivider,
    HeroBar? expanded,
    bool? isImpliedLeading,
  }) {
    return SliverAppBar(
      toolbarHeight: headerHeight ?? sunnySpacing.appBarHeight,
      centerTitle: centerTitle,
      pinned: pinned,
      title: pageTitle,
      floating: floating,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading:
          !context.isInModal && isImpliedLeading != false,
      backgroundColor:
          appBarColor ?? pageBackground ?? sunnyColors.appBarBackground,
      elevation: 0,
      stretch: onStretch != null,
      onStretchTrigger: onStretch,
      expandedHeight: expanded?.expandedSize?.height,
      bottom: showAppBarDivider == true ? DividingLine.preferredSize() : null,
      flexibleSpace: expanded == null
          ? null
          : FlexibleSpaceBar(
              background: expanded,
              stretchModes:
                  onStretch == null ? [] : [StretchMode.zoomBackground],
            ),
    );
  }
}

Widget sameWidget(Widget input) => input;
