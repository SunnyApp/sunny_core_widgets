/*
 * flutter_platform_widgets
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/cupertino.dart' show CupertinoNavigationBar, ObstructingPreferredSizeWidget;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'sized_cupertino_nav_bar.dart';

//the default has alpha which will cause the content to slide under the header for ios
const Color _kDefaultNavBarBorderColor = const Color(0x4C000000);

const Border _kDefaultNavBarBorder = const Border(
  bottom: const BorderSide(
    color: _kDefaultNavBarBorderColor,
    width: 0.0, // One physical pixel.
    style: BorderStyle.solid,
  ),
);
const kDefaultAppBarHeight = 44.0;

class SizedPlatformAppBar extends PlatformAppBar {
  final double height;

  final PlatformAppBar _wrapped;

  SizedPlatformAppBar({
    Key key,
    Key widgetKey,
    this.height = kDefaultAppBarHeight,
    Widget title,
    Color backgroundColor,
    Widget leading,
    List<Widget> trailingActions,
    bool automaticallyImplyLeading,
    PlatformBuilder2<MaterialAppBarData> material,
    PlatformBuilder2<CupertinoNavigationBarData> cupertino,
  })  : _wrapped = PlatformAppBar(
            widgetKey: widgetKey,
            title: title,
            backgroundColor: backgroundColor,
            leading: leading,
            trailingActions: trailingActions,
            automaticallyImplyLeading: automaticallyImplyLeading,
            material: material,
            cupertino: cupertino),
        super(key: key);

  @override
  PreferredSizeWidget createMaterialWidget(BuildContext context) {
    return _wrapped.createMaterialWidget(context);
  }

  @override
  ObstructingPreferredSizeWidget createCupertinoWidget(BuildContext context) {
    final data = _wrapped.cupertino?.call(context, platform(context));

    var trailing = _wrapped.trailingActions == null || _wrapped.trailingActions.isEmpty
        ? null
        : new Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _wrapped.trailingActions,
          );

    if (data?.heroTag != null) {
      return SizedCupertinoNavigationBar(
        height: height ?? kDefaultAppBarHeight,
        key: data?.widgetKey ?? _wrapped.widgetKey,
        middle: data?.title ?? _wrapped.title,
        backgroundColor: data?.backgroundColor ?? _wrapped.backgroundColor,
        actionsForegroundColor: data?.actionsForegroundColor,
        automaticallyImplyLeading: data?.automaticallyImplyLeading ?? _wrapped.automaticallyImplyLeading ?? true,
        automaticallyImplyMiddle: data?.automaticallyImplyMiddle ?? true,
        previousPageTitle: data?.previousPageTitle,
        padding: data?.padding,
        border: data?.border ?? _kDefaultNavBarBorder,
        leading: data?.leading ?? _wrapped.leading,
        trailing: data?.trailing ?? trailing,
        transitionBetweenRoutes: data?.transitionBetweenRoutes ?? true,
        brightness: data?.brightness,
        heroTag: data.heroTag,
      );
    }

    return SizedCupertinoNavigationBar(
      height: height ?? kDefaultAppBarHeight,
      key: data?.widgetKey ?? _wrapped.widgetKey,
      middle: data?.title ?? _wrapped.title,
      backgroundColor: data?.backgroundColor ?? _wrapped.backgroundColor,
      actionsForegroundColor: data?.actionsForegroundColor,
      automaticallyImplyLeading: data?.automaticallyImplyLeading ?? _wrapped.automaticallyImplyLeading ?? true,
      automaticallyImplyMiddle: data?.automaticallyImplyMiddle ?? true,
      previousPageTitle: data?.previousPageTitle,
      padding: data?.padding,
      border: data?.border ?? _kDefaultNavBarBorder,
      leading: data?.leading ?? _wrapped.leading,
      trailing: data?.trailing ?? trailing,
      transitionBetweenRoutes: data?.transitionBetweenRoutes ?? true,
      brightness: data?.brightness,
    );
  }
}
