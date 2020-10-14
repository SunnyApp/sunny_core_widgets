/*
 * flutter_platform_widgets
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/cupertino.dart' show CupertinoTabBar, CupertinoColors;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'sized_bottom_tab_bar.dart';

const Color _kDefaultTabBarBorderColor = Color(0x4C000000);
const Color _kDefaultTabBarInactiveColor = CupertinoColors.inactiveGray;

class SizedPlatformNavBar extends PlatformNavBar {
  final double height;
  SizedPlatformNavBar({
    Key key,
    this.height,
    Key widgetKey,
    Color backgroundColor,
    List<BottomNavigationBarItem> items,
    ValueChanged<int> itemChanged,
    int currentIndex,
    PlatformBuilder<MaterialNavBarData> android,
    PlatformBuilder<CupertinoTabBarData> ios,
    PlatformBuilder2<MaterialNavBarData> material,
    PlatformBuilder2<CupertinoTabBarData> cupertino,
  }) : super(
          key: key,
          widgetKey: widgetKey,
          backgroundColor: backgroundColor,
          items: items,
          itemChanged: itemChanged,
          currentIndex: currentIndex,
          material: material,
          cupertino: cupertino,
        );

  @override
  SizedCupertinoTabBar createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context, platform(context));

    return SizedCupertinoTabBar(
      height: height,
      items: data?.items ?? items,
      activeColor: data?.activeColor,
      backgroundColor: data?.backgroundColor ?? backgroundColor,
      currentIndex: data?.currentIndex ?? currentIndex ?? 0,
      iconSize: data?.iconSize ?? 30.0,
      inactiveColor: data?.inactiveColor ?? _kDefaultTabBarInactiveColor,
      key: data?.widgetKey ?? widgetKey,
      onTap: data?.itemChanged ?? itemChanged,
      border: data?.border ??
          const Border(
            top: BorderSide(
              color: _kDefaultTabBarBorderColor,
              width: 0.0, // One physical pixel.
              style: BorderStyle.solid,
            ),
          ),
    );
  }
}
