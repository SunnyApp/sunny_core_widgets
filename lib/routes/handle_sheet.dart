import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';
import 'package:sunny_core_widgets/theme/sunny_colors.dart';

class HandleSheet extends StatelessWidget {
  final Widget child;

  const HandleSheet({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            SafeArea(
              bottom: false,
              child: const DragHandle(),
            ),
            SizedBox(height: 8),
            child,
          ]),
    );
  }
}

class DragHandle extends StatelessWidget {
  final double width;

  const DragHandle({Key key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: (width ?? 40).px,
      decoration: BoxDecoration(
        color: sunnyColors.g400,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
