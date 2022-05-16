import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sunny_essentials/provided.dart';
import 'package:sunny_essentials/widget_wrapper.dart';

abstract class ScaffoldInfo extends Equatable implements WidgetDecorator {
  final Color? background;

  const ScaffoldInfo({required this.background});

  @override
  Widget build(BuildContext context, {required Widget child}) {
    if (background != null) {
      return DecoratedBox(
        decoration: BoxDecoration(color: background),
        child: child,
      );
    } else {
      return child;
    }
  }

  @override
  List<Object?> get props => [background];
}

class MainScaffoldInfo extends ScaffoldInfo {
  const MainScaffoldInfo({required Color? background})
      : super(background: background);

  static Color? backgroundColor(BuildContext context) {
    return Provided.find<MainScaffoldInfo>(context)?.background;
  }

  static MainScaffoldInfo? of(BuildContext context) {
    return Provided.find<MainScaffoldInfo>(context);
  }

  static Widget decorate(BuildContext context, {required Widget child}) {
    final info = Provided.find<MainScaffoldInfo>(context);
    return info == null ? child : info.build(context, child: child);
  }

  Widget provide({required Widget child}) {
    return Provider.value(
      value: this,
      child: child,
      updateShouldNotify: (a, b) => a != b,
    );
  }
}

class ModalScaffoldInfo extends ScaffoldInfo {
  const ModalScaffoldInfo({required Color? background})
      : super(background: background);

  static Color? backgroundColor(BuildContext context) {
    return Provided.find<ModalScaffoldInfo>(context)?.background;
  }

  static ModalScaffoldInfo? of(BuildContext context) {
    return Provided.find<ModalScaffoldInfo>(context);
  }

  Widget provide({required Widget child}) {
    return Provider.value(
      value: this,
      child: child,
      updateShouldNotify: (a, b) => a != b,
    );
  }

  static Widget decorate(BuildContext context, {required Widget child}) {
    final info = Provided.find<ModalScaffoldInfo>(context);
    return info == null ? child : info.build(context, child: child);
  }
}
