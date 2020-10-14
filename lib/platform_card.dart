import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_degen/annotations.dart';
import 'package:sunny_core_widgets/platform_card_theme.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';
import 'package:sunny_dart/helpers/functions.dart';

part 'platform_card.g.dart';

class PlatformCardArgs {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color color;
  final BorderRadius borderRadius;
  final bool useShadow;
  final double height;
  final double width;

  final double minHeight;
  final double minWidth;
  final double pressOpacity;
  final double pressScale;
  final FutureTappableCallback onTap;
  final FutureTappableCallback onLongPress;
  final List<BoxShadow> shadow;
  final PlatformCardTheme theme;
  final bool shouldClip;

  const PlatformCardArgs({
    this.pressOpacity = 1,
    this.pressScale = Tappable.defaultScale,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color = Colors.white,
    this.height,
    this.width,
    this.useShadow = true,
    this.minWidth,
    this.theme,
    this.minHeight,
    this.onTap,
    this.shouldClip,
    this.onLongPress,
    this.shadow,
  });
}

class PlatformCard extends StatelessWidget with _PlatformCardArgsMixin {
  @delegate(implementDelegate: true)
  final PlatformCardArgs _args;
  final Widget child;

  PlatformCard({
    PlatformCardArgs args,
    this.child,
    Key key,
  })  : _args = args ?? const PlatformCardArgs(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? PlatformCardTheme.of(context);
    Widget widget;
    if (kIsWeb || isIOS == true) {
      final inner = shouldClip == true
          ? ClipRRect(
              borderRadius: borderRadius ?? theme.borderRadius, child: child)
          : child;
      widget = Container(
        margin: margin ?? theme.margin,
        padding: padding ?? theme.padding,
        alignment: AlignmentDirectional.centerStart,
        decoration: BoxDecoration(
            color: color ?? theme.cardColor,
            borderRadius: borderRadius ?? theme.borderRadius,
            boxShadow: useShadow ? shadow ?? theme.boxShadow : null),
        child: inner,
      );
    } else {
      widget = Card(
          margin: margin ?? theme.margin,
          child: Container(
            padding: padding ?? theme.padding,
            child: child,
          ));
    }

    if (onTap != null || onLongPress != null) {
      return Tappable(
        pressOpacity: pressOpacity,
        pressScale: pressScale,
        onTap: onTap,
        onLongPress: onLongPress,
        child: widget,
      );
    } else {
      return widget;
    }
  }
}
