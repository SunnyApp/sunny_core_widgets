import 'package:flutter/widgets.dart';

extension WidgetMaybeWrap on Widget {
  Widget maybeWrap(bool wrapIf, Widget wrap(Widget child)) {
    return wrapIf ? wrap(this) : this;
  }
}
