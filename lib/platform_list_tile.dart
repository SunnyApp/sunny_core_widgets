import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_degen/annotations.dart';
import 'package:sunny_core_widgets/platform_card_theme.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';

part 'platform_list_tile.g.dart';

class PlatformListTile extends StatelessWidget with _PlatformCardArgsMixin {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;

  @delegate(implementDelegate: true)
  final PlatformCardArgs _args;

  const PlatformListTile(
    this._args, {
    Key key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  const PlatformListTile.defaults({
    Key key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
  })  : _args = const PlatformCardArgs(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformCard(
      args: this,
      child: ListTile(
        title: title,
        leading: leading,
        trailing: trailing,
        subtitle: subtitle,
      ),
    );
  }

  PlatformListTile copyWith({
    Widget leading,
    Widget title,
    Widget subtitle,
    Widget trailing,
    PlatformCardArgs args,
  }) {
    return new PlatformListTile(
      args,
      leading: leading ?? this.leading,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      trailing: trailing ?? this.trailing,
    );
  }
}
