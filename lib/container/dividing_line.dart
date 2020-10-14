import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auto_layout.dart';

class DividingLine extends StatelessWidget {
  final Widget divider;

  @override
  Widget build(BuildContext context) {
    return divider;
  }

  static List<Widget> divideWithLines(Iterable<Widget> widgets,
      [Widget divider]) {
    return divide(widgets, divider ?? dividingLine);
  }

  const DividingLine.indent()
      : divider = const Divider(
          indent: 20,
          height: 1,
          thickness: 0.5,
          color: CupertinoColors.separator,
        );

  const DividingLine.indent2()
      : divider = const Divider(
          indent: 20,
          endIndent: 20,
          height: 1,
          thickness: 0.5,
          color: CupertinoColors.separator,
        );

  const DividingLine()
      : divider = const Divider(
          indent: 0,
          height: 1,
          thickness: 0.5,
          color: CupertinoColors.separator,
        );

  static PreferredSizeWidget preferredSize() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(1.0),
      child: dividingLine,
    );
  }
}

const dividingLine = const DividingLine();
