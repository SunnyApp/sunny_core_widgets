import 'package:flutter/cupertino.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

typedef KeyboardVisibilityBuilder = Widget Function(
    BuildContext context, Widget child, bool isKeyboardVisible);

/// Calls `builder` on keyboard close/open.
/// https://stackoverflow.com/a/63241409/1321917
class KeyboardVisibility extends StatefulWidget {
  final Widget child;
  final KeyboardVisibilityBuilder builder;

  const KeyboardVisibility.builder({
    Key key,
    this.child,
    @required this.builder,
  }) : super(key: key);

  KeyboardVisibility({Key key, Widget onKeyboardShow, Widget onKeyboardHide})
      : child = null,
        builder = ((_, __, bool isShown) => isShown
            ? (onKeyboardShow ?? emptyBox)
            : (onKeyboardHide ?? emptyBox)),
        super(key: key);

  @override
  _KeyboardVisibilityState createState() => _KeyboardVisibilityState();
}

class _KeyboardVisibilityState extends State<KeyboardVisibility>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        widget.child,
        _isKeyboardVisible,
      );
}
