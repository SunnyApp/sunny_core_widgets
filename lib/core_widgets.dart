import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OpenSettings = Future<bool?> Function(BuildContext context);
typedef TypeaheadOptionBuilder = Widget Function(
    {Widget? title,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    Widget? subtitle});

InputWidgetsProvider InputWidgets = const InputWidgetsProvider();

Widget defaultClearIcon() {
  return Icon(Icons.close);
}

class InputWidgetsProvider {
  final TypeaheadOptionBuilder buildTypeaheadOption;

  const InputWidgetsProvider({
    this.buildTypeaheadOption = defaultTypeaheadOptionBuilder,
  });
}

Widget defaultTypeaheadOptionBuilder(
    {Widget? title,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    Widget? subtitle}) {
  return ListTile(
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      subtitle: subtitle,
      title: title,
      dense: true);
}

CoreWidgetsProvider CoreWidgets = const CoreWidgetsProvider();

class CoreWidgetsProvider {
  Widget get divider => Divider(
        height: dividerThickness,
        thickness: dividerThickness,
        color: dividerColor,
      );

  BoxDecoration withDivider([BoxDecoration? decoration]) {
    decoration ??= const BoxDecoration();
    return decoration.copyWith(border: dividerBorder());
  }

  Border dividerBorder() {
    return Border(
      bottom: dividerBorderSide(),
    );
  }

  BorderSide dividerBorderSide() {
    return BorderSide(
      color: dividerColor,
      width: dividerThickness,
    );
  }

  final Color dividerColor;
  final double dividerThickness;

  const CoreWidgetsProvider({
    this.dividerColor = CupertinoColors.opaqueSeparator,
    this.dividerThickness = 0.5,
  });
}
