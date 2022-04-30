import 'package:flutter/material.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

class HandleSheet extends StatelessWidget {
  final Widget? child;

  const HandleSheet({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 12),
          SafeArea(
            bottom: false,
            child: const DragHandle(),
          ),
          SizedBox(height: 8),
          child!,
        ]);
    // return AnnotatedRegion<SystemUiOverlayStyle>(
    //   value: SystemUiOverlayStyle.light,
    //   child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         SizedBox(height: 12),
    //         SafeArea(
    //           bottom: false,
    //           child: const DragHandle(),
    //         ),
    //         SizedBox(height: 8),
    //         child!,
    //       ]),
    // );
  }
}

class DragHandle extends StatelessWidget {
  final double? width;

  const DragHandle({Key? key, this.width}) : super(key: key);

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

extension WidgetDragHandleExt on Widget {
  Widget withDragHandle() {
    return widgetWithDragHandle(child: this);
  }
}

Widget widgetWithDragHandle({Widget? child}) {
  return Stack(
    alignment: Alignment.topCenter,
    fit: StackFit.loose,
    children: [
      child!,
      SizedBox(
        height: 18,
        child: const Center(child: const DragHandle()),
      ),
    ],
  );
}
