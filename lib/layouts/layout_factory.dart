import 'package:flutter/widgets.dart';
import 'package:sunny_core_widgets/layouts.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

/// Factory pattern that takes in a page state, and resolves the default layout
/// to be used.
abstract class LayoutFactory {
  SunnyPageLayout calculateLayout(SunnyPageState page);

  static LayoutFactory of(BuildContext context, {bool useDefaults = true}) {
    return Provided.find(context) ??
        LayoutFactory.from((s) => ResponsivePageLayout(s));
  }

  const factory LayoutFactory.from(SunnyPageLayoutFactory fn) =
      _DefaultLayoutFactory;
}

class _DefaultLayoutFactory implements LayoutFactory {
  final SunnyPageLayoutFactory fn;

  const _DefaultLayoutFactory(this.fn);

  @override
  SunnyPageLayout calculateLayout(SunnyPageState page) => fn(page);
}
