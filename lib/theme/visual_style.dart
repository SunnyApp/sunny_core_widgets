import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:meta_forms/build_context_provides.dart';
import 'package:sunny_core_widgets/provided.dart';

CupertinoVisualStyle _instance;

class CupertinoVisualStyle {
  final bool appBarHasBorder;
  final Color appBarColor;
  final Color cardColor;
  final EdgeInsets inputPadding;
  final TextStyle appBarTextStyle;
  final CupertinoTabBarData tabBarData;
  final List<BoxShadow> cardShadow;

  factory CupertinoVisualStyle() {
    return _instance ??= CupertinoVisualStyle.defaults();
  }

  static set instance(CupertinoVisualStyle style) {
    assert(style != null);
    _instance = style;
  }

  static CupertinoVisualStyle get instance {
    _instance ??= CupertinoVisualStyle.defaults();
    return _instance;
  }

  /// ctor uses positional arguments to hellp us not miss new args
  const CupertinoVisualStyle._of(
    this.appBarColor,
    this.cardShadow,
    this.tabBarData,
    this.cardColor,
    this.appBarTextStyle,
    this.inputPadding,
    this.appBarHasBorder,
  );

  const CupertinoVisualStyle.of({
    @required this.appBarHasBorder,
    @required this.appBarColor,
    @required this.cardColor,
    @required this.inputPadding,
    @required this.appBarTextStyle,
    @required this.tabBarData,
    @required this.cardShadow,
  });

  const CupertinoVisualStyle.defaults()
      : this._of(
          CupertinoColors.white,
          null,
          null,
          const CupertinoDynamicColor.withBrightness(
            color: Colors.white,
            darkColor: Colors.black,
          ),
          null,
          null,
          false,
        );

  CupertinoVisualStyle copyWith({
    bool appBarHasBorder,
    Color appBarColor,
    Color cardColor,
    EdgeInsets inputPadding,
    TextStyle appBarTextStyle,
    CupertinoTabBarData tabBarData,
    List<BoxShadow> cardShadow,
  }) {
    return new CupertinoVisualStyle._of(
      appBarColor ?? this.appBarColor,
      cardShadow ?? this.cardShadow,
      tabBarData ?? this.tabBarData,
      cardColor ?? this.cardColor,
      appBarTextStyle ?? this.appBarTextStyle,
      inputPadding ?? this.inputPadding,
      appBarHasBorder ?? this.appBarHasBorder,
    );
  }

  CupertinoVisualStyle withTextScale(double textScaleFactor) {
    return this.copyWith(
        appBarTextStyle:
            appBarTextStyle.apply(fontSizeFactor: textScaleFactor));
  }

  CupertinoVisualStyle withBrightness(BuildContext context) {
    return this.copyWith(
        cardShadow: cardShadow.map((sh) {
      return BoxShadow(
          color: sh.color,
          offset: sh.offset,
          blurRadius: sh.blurRadius,
          spreadRadius: sh.spreadRadius);
    }).toList());
  }
}

extension CupertinoVisualStyleBuildContext on BuildContext {
  CupertinoVisualStyle get cupertinoVisualStyle {
    return Provided.find(this);
  }

  CupertinoTabBarData get tabBarData {
    return cupertinoVisualStyle?.tabBarData;
  }

  TextStyle get appBarTextStyle {
    return cupertinoVisualStyle?.appBarTextStyle;
  }
}
