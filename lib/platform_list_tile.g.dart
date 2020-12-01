// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_list_tile.dart';

// **************************************************************************
// DelegateGenerator
// **************************************************************************

abstract class _PlatformCardArgsDelegate {
  PlatformCardArgs get _args;
}

mixin _PlatformCardArgsMixin
    implements _PlatformCardArgsDelegate, PlatformCardArgs {
  EdgeInsets get padding => _args.padding;
  EdgeInsets get margin => _args.margin;
  Color get color => _args.color;
  BorderRadius get borderRadius => _args.borderRadius;
  bool get useShadow => _args.useShadow;
  double get height => _args.height;
  double get width => _args.width;
  double get minHeight => _args.minHeight;
  double get minWidth => _args.minWidth;
  double get pressOpacity => _args.pressOpacity;
  double get pressScale => _args.pressScale;
  FutureOr<dynamic> Function(BuildContext) get onTap => _args.onTap;
  FutureOr<dynamic> Function(BuildContext) get onLongPress => _args.onLongPress;
  FutureOr<dynamic> Function(BuildContext) get onHover => _args.onHover;
  List<BoxShadow> get shadow => _args.shadow;
  PlatformCardTheme get theme => _args.theme;
  bool get shouldClip => _args.shouldClip;
}

// **************************************************************************
// DegenGenerator
// **************************************************************************


class PlatformListTile extends _PlatformListTile with _PlatformCardArgsMixin {
  PlatformListTile({
    double pressOpacity,
    FutureOr<dynamic> Function(BuildContext) onHover,
    double pressScale,
    EdgeInsets padding,
    EdgeInsets margin,
    BorderRadius borderRadius,
    Color color,
    double height,
    double width,
    bool useShadow,
    double minWidth,
    PlatformCardTheme theme,
    double minHeight,
    FutureOr<dynamic> Function(BuildContext) onTap,
    bool shouldClip,
    FutureOr<dynamic> Function(BuildContext) onLongPress,
    List<BoxShadow> shadow,
    Key key,
    Widget leading,
    Widget title,
    Widget bottom,
    Widget subtitle,
    Widget trailing,
  }) : super(
            PlatformCardArgs(
              pressOpacity: pressOpacity,
              onHover: onHover,
              pressScale: pressScale,
              padding: padding,
              margin: margin,
              borderRadius: borderRadius,
              color: color,
              height: height,
              width: width,
              useShadow: useShadow,
              minWidth: minWidth,
              theme: theme,
              minHeight: minHeight,
              onTap: onTap,
              shouldClip: shouldClip,
              onLongPress: onLongPress,
              shadow: shadow,
            ),
            key: key,
            leading: leading,
            title: title,
            bottom: bottom,
            subtitle: subtitle,
            trailing: trailing);

  PlatformListTile.cardArgs(
    PlatformCardArgs _args, {
    Key key,
    Widget leading,
    Widget title,
    Widget bottom,
    Widget subtitle,
    Widget trailing,
  }) : super.cardArgs(_args,
            key: key,
            leading: leading,
            title: title,
            bottom: bottom,
            subtitle: subtitle,
            trailing: trailing);

  PlatformListTile.nocard({
    Key key,
    Widget leading,
    Widget title,
    Widget bottom,
    Widget subtitle,
    Widget trailing,
  }) : super.nocard(
            key: key,
            leading: leading,
            title: title,
            bottom: bottom,
            subtitle: subtitle,
            trailing: trailing);
}
