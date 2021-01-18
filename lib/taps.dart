import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Enforces HitTest.opaque and removes parameters
Widget tappable<R>(Widget child,
    {FutureOrTappableCallback onTap,
    Key key,
    double pressOpacity = 1.0,
    BuildContext context,
    String routeName,
    arguments,
    void callback(R result)}) {
  if (onTap == null && routeName == null) return child;

  return GestureDetector(
      child: child,
      onTap: () async {
        onTap?.call();
        assert(routeName == null || context != null,
            "If you provide a route, you must also provide a buildContext");
        if (routeName != null) {
          final R result = await Navigator.pushNamed(context, routeName,
              arguments: arguments);
          callback(result);
        }
      },
      behavior: HitTestBehavior.opaque);
}

typedef FutureOrTappableCallback<T> = FutureOr<T> Function();
typedef FutureTappableCallback<T> = FutureOr<T> Function(BuildContext context);

enum TapTransform {
  opacity,
  scale,
}

class Tappable extends StatefulWidget {
  static const defaultScale = 0.98;

  final double pressOpacity;
  final double pressScale;
  final FutureTappableCallback onTap;
  final FutureTappableCallback onLongPress;
  final HitTestBehavior behavior;
  final Widget child;
  final Duration duration;

  Tappable.link(
    String s, {
    this.onTap,
    this.behavior = HitTestBehavior.opaque,
    this.onLongPress,
    TextStyle style,
  })  : duration = const Duration(milliseconds: 300),
        pressOpacity = null,
        pressScale = null,
        child = Text(s, style: style);

  const Tappable(
      {Key key,
      this.pressOpacity = 0.7,
      this.pressScale,
      this.behavior = HitTestBehavior.opaque,
      this.onLongPress,
      this.duration = const Duration(milliseconds: 300),
      this.onTap,
      this.child})
      : super(key: key);

  @override
  _TappableState createState() => _TappableState();
}

class _TappableState extends State<Tappable>
    with SingleTickerProviderStateMixin {
  AnimationController _ac;
  Animation<double> _scaleAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _ac = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 300),
      value: 0,
      reverseDuration: widget.duration ?? const Duration(milliseconds: 300),
    );
    _opacityAnimation =
        _ac.drive(Tween(begin: 1, end: widget.pressOpacity ?? 1));
    _scaleAnimation = _ac.drive(Tween(begin: 1, end: widget.pressScale ?? 1));
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  var elevation = 4.0;
  var scale = 1.0;
  var translate = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: widget.behavior ?? HitTestBehavior.opaque,
        onSecondaryTap: widget.onLongPress == null
            ? null
            : () {
                widget.onLongPress(context);
              },
        onTap: () async {
          try {
            await widget.onTap?.call(context);
          } finally {
            if (mounted) {
              _ac.reverse();
            }
          }
        },
        onLongPress: widget.onLongPress == null
            ? null
            : () {
                HapticFeedback.heavyImpact();
                widget.onLongPress(context);
              },
        onTapDown: (tap) {
          setState(() {
            _ac.forward();
          });
        },
        onTapUp: (_) {
//        _ac.reverse();
//        print("Tap up!");
        },
        onTapCancel: () {
          setState(() {
            _ac.reverse();
          });
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

typedef HoverBuilder = Widget Function(bool isHover);

class HoverEffect extends StatefulWidget {
  final HoverBuilder builder;

  const HoverEffect({Key key, @required this.builder}) : super(key: key);

  @override
  _HoverEffectState createState() => _HoverEffectState();
}

class _HoverEffectState extends State<HoverEffect> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (isHover != true) {
          setState(() {
            isHover = true;
          });
        }
      },
      onExit: (_) {
        if (isHover == true) {
          setState(() {
            isHover = false;
          });
        }
      },
      child: widget.builder(isHover),
    );
  }
}
