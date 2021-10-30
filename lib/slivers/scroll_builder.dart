import 'package:flutter/cupertino.dart';
import 'package:sunny_core_widgets/slivers/scroll_padding.dart';
import 'package:sunny_essentials/logging/logging_mixin.dart';

typedef ScrollWithChildBuilder = Widget Function(BuildContext context, Widget? child);

class ScrollBuilder extends StatefulWidget {
  final ScrollWithChildBuilder builder;
  final ScrollController controller;
  final ShouldRebuild? shouldRebuild;
  final Widget? child;
  const ScrollBuilder({Key? key, required this.builder, required this.controller, this.child, this.shouldRebuild})
      : super(key: key);

  factory ScrollBuilder.threshold({
    Key? key,
    required ScrollController controller,
    required double threshold,
    required Widget child,
    Widget? before,
    Duration duration = const Duration(milliseconds: 150),
    bool showAfter = true,
  }) {
    double lastOffset = 0;
    return ScrollBuilder(
        controller: controller,
        child: child,
        key: key,
        builder: (context, child) {
          final isShown = showAfter ? controller.offset > threshold : controller.offset < threshold;
          return AnimatedSwitcher(
            duration: duration,
            child: isShown ? child : (before ?? SizedBox(height: 0)),
          );
        },
        shouldRebuild: () {
          final newOffset = controller.offset;
          final isSwitched =
              (lastOffset < threshold && newOffset > threshold) || (lastOffset > threshold && newOffset < threshold);
          lastOffset = newOffset;
          return isSwitched;
        });
  }

  @override
  _ScrollBuilderState createState() => _ScrollBuilderState();
}

class _ScrollBuilderState extends State<ScrollBuilder> with LoggingMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scrollChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scrollChanged);
    super.dispose();
  }

  void _scrollChanged() {
    final shouldBuild = widget.shouldRebuild?.call() ?? true;
    if (shouldBuild) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child);
  }
}
