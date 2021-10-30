import 'package:flutter/cupertino.dart';
import 'package:sunny_essentials/logging/logging_mixin.dart';

class ScrollPadding extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final PaddingBuilder builder;
  final ShouldRebuild shouldRebuild;

  const ScrollPadding({
    Key? key,
    required this.controller,
    required this.child,
    required this.builder,
    required this.shouldRebuild,
  }) : super(key: key);

  @override
  _ScrollPaddingState createState() => _ScrollPaddingState();
}

typedef PaddingBuilder = EdgeInsets Function();
typedef ShouldRebuild = bool Function();

class _ScrollPaddingState extends State<ScrollPadding> with LoggingMixin {
  double startPadding = 0;

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
    if (widget.shouldRebuild()) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final newPadding = widget.builder();
    return Padding(padding: newPadding, child: widget.child);
  }
}
