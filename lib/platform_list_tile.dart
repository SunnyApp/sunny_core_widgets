import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_degen/annotations.dart';
import 'package:sunny_core_widgets/platform_card_theme.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';

part 'platform_list_tile.g.dart';

@degen()
abstract class _PlatformListTile extends StatelessWidget
    with _PlatformCardArgsMixin {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final Widget bottom;

  @delegate(implementDelegate: true)
  final PlatformCardArgs _args;

  const _PlatformListTile(
    @flatten() this._args, {
    Key key,
    this.leading,
    this.title,
    this.bottom,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  const _PlatformListTile.cardArgs(
    this._args, {
    Key key,
    this.leading,
    this.title,
    this.bottom,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  const _PlatformListTile.nocard({
    Key key,
    this.leading,
    this.title,
    this.bottom,
    this.subtitle,
    this.trailing,
  })  : _args = const PlatformCardArgs(
          useShadow: false,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      onTap: () => this.onTap?.call(context),
      onLongPress: () => this.onLongPress?.call(context),
      title: title,
      leading: leading,
      trailing: trailing,
      subtitle: subtitle,
    );
    return PlatformCard(
      args: this,
      child: bottom == null
          ? tile
          : Layout.column().noFlex.crossAxisStretch.build(
                tile,
                bottom,
              ),
    );
  }

  PlatformListTile copyWith({
    Widget leading,
    Widget title,
    Widget bottom,
    Widget subtitle,
    Widget trailing,
    PlatformCardArgs args,
  }) {
    return PlatformListTile.cardArgs(
      args,
      leading: leading ?? this.leading,
      title: title ?? this.title,
      bottom: bottom ?? this.bottom,
      subtitle: subtitle ?? this.subtitle,
      trailing: trailing ?? this.trailing,
    );
  }
}
