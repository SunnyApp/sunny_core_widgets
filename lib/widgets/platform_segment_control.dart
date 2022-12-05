import 'package:flutter/cupertino.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sunny_essentials/container.dart';
import 'package:sunny_essentials/theme.dart';

import 'ext/sliding_segmented_control.dart';

typedef TabChanged = void Function(BuildContext context, int change);

const kSegmentControlHeight = 64.0;
const kSegmentControlHeightMaterial = 74.0;

abstract class PlatformSegmentControl implements Widget, PreferredSizeWidget {

  int? get currentTab;

  Map<int, SlidingTab> get tabs;

  TabChanged? get onTabChange;

  String? get name;
  Color? get tabBackgroundColor;
  Color? get tabForegroundColor;



  factory PlatformSegmentControl.stateless(
          {Key? key,
          required String name,
          int currentTab = 0,
            Color? tabBackgroundColor,
            Color? tabForegroundColor,
          required Map<int, SlidingTab> tabs,
          Color? backgroundColor,
          TabChanged? onTabChange}) =>
      _StatelessPlatformSegmentControl(
          name: name,
          currentTab: currentTab,
          tabs: tabs,
          tabForegroundColor: tabForegroundColor,
          tabBackgroundColor: tabBackgroundColor,
          backgroundColor: backgroundColor,
          onTabChange: onTabChange);

  factory PlatformSegmentControl.stateful(
          {Key? key,
          required String name,
            Color? tabBackgroundColor,
            Color? tabForegroundColor,
          int currentTab = 0,
          Color? backgroundColor,
          required Map<int, SlidingTab> tabs,
          TabChanged? onTabChange}) =>
      _StatefulPlatformSegmentControl(
          name: name,
          currentTab: currentTab,
          tabForegroundColor: tabForegroundColor,
          tabBackgroundColor: tabBackgroundColor,
          tabs: tabs,
          backgroundColor: backgroundColor,
          onTabChange: onTabChange);
}

mixin PlatformSegmentControlMixin on Widget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kSegmentControlHeight.px);
  Color? get backgroundColor;

  Widget withPadding(BuildContext context) {
    return Container(
        color: backgroundColor ?? context.sunnyColors.appBarBackground,
        child: this,
        padding: EdgeInsets.only(
          top: 8.px,
          bottom: 16.px,
          left: 16.px,
          right: 16.px,
        ));
  }
}

class _StatelessPlatformSegmentControl extends StatelessWidget
    with PlatformSegmentControlMixin
    implements PlatformSegmentControl {
  final Color? tabBackgroundColor;
  final Color? tabForegroundColor;

  final int? currentTab;
  final Map<int, SlidingTab> tabs;
  final TabChanged? onTabChange;
  final String name;
  final Color? backgroundColor;

  _StatelessPlatformSegmentControl(
      {Key? key,
      required this.name,
      this.tabBackgroundColor,
      this.tabForegroundColor,
      this.currentTab,
      required this.tabs,
      this.onTabChange,
      required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) => _buildSegment(
        context,
        this,
        currentTab,
        backgroundColor: backgroundColor,
      );
}

class _StatefulPlatformSegmentControl extends StatefulWidget
    with PlatformSegmentControlMixin
    implements PlatformSegmentControl {
  final int? currentTab;
  final Map<int, SlidingTab> tabs;
  final TabChanged? onTabChange;
  final String? name;
  final Color? backgroundColor;
  final Color? tabBackgroundColor;
  final Color? tabForegroundColor;

  _StatefulPlatformSegmentControl(
      {Key? key,
      this.currentTab,
      required this.tabs,
      this.onTabChange,
        this.tabBackgroundColor,
        this.tabForegroundColor,
      this.name,
      required this.backgroundColor})
      : super(key: key);

  @override
  State createState() {
    return _PlatformSegmentControlState();
  }
}

class _PlatformSegmentControlState
    extends State<_StatefulPlatformSegmentControl> {
  int? _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.currentTab ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return _buildSegment(
      context,
      widget,
      _currentTab,
      backgroundColor: widget.backgroundColor,
      extraTabChange: (context, newTab) => setState(() {
        _currentTab = newTab;
      }),
    );
  }
}

extension PlatformSegmentControlExt on PlatformSegmentControl {
  Widget withPadding() {
    return Padding(
        child: this,
        padding: EdgeInsets.only(
          top: 8.px,
          bottom: 16.px,
          left: 16.px,
          right: 16.px,
        ));
  }
}

//const tabStyle = TextStyle(
//    color: sunnyColors.g800, fontSize: 13, fontWeight: FontWeight.normal);
//final selectedTabStyle =
//    tabStyle.copyWith(color: sunnyColors.g800, fontWeight: FontWeight.w600);

const CupertinoDynamicColor _kThumbColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFFFFFFF),
  darkColor: Color(0xFF636366),
);


class SlidingTab extends StatelessWidget {
  final bool isSelected;
  final String label;
  final IconData? icon;

  const SlidingTab(
      {Key? key, required this.label, this.icon, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.px,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (icon != null) Icon(icon, size: 18.px, color: context.sunnyColors.text),
        if (icon != null) horizontalSpace,
        AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: sunnyText.body2Medium.withBrightness(context),
            child: Text(
              label,
              style: (isSelected ? sunnyText.body2Medium.selected : null)?.withBrightness(context),
            )),
      ]),
    );
  }

  Widget selected() {
    return SlidingTab(isSelected: true, label: label, icon: icon);
  }

  Widget unselected() {
    return SlidingTab(isSelected: false, label: label, icon: icon);
  }
}

Widget _buildSegment(
    BuildContext context, PlatformSegmentControl widget, int? currentTab,
    {TabChanged? extraTabChange, required Color? backgroundColor}) {
  final isTrue = 1 == 1;
  return Container(
      color: backgroundColor ?? context.sunnyColors.appBarBackground,
      child: isTrue
          ? CupertinoSlidingSegmentedControl<int>(
              key: Key("${widget.name}-tabs"),
              children: widget.tabs.map((k, v) {
                return MapEntry(
                    k, k == widget.currentTab ? v.selected() : v.unselected());
              }),
              thumbColor: (widget.tabBackgroundColor ?? _kThumbColor).resolveFrom(context),
              // padding: EdgeInsets.all(2.px),
              backgroundColor: context.sunnyColors.g200,
              groupValue: currentTab,
              onValueChanged: (i) {
                widget.onTabChange?.call(context, i!);
                extraTabChange?.call(context, i!);
              },
            )
          : MaterialSegmentedControl<int>(
              key: Key("${widget.name}-tabs"),
              selectedColor: context.sunnyColors.primaryColor,
              unselectedColor: context.sunnyColors.g200,
              children: widget.tabs.map((k, v) {
                return MapEntry(
                    k, k == widget.currentTab ? v.selected() : v.unselected());
              }),
              verticalOffset: 0,
              onSegmentChosen: (i) {
                widget.onTabChange?.call(context, i);
                extraTabChange?.call(context, i);
              },
              selectionIndex: currentTab,
            ));
}
