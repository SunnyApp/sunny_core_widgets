import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlatformCardTheme {
  // static const _gray600 = Color(0xFF868F96);
  // static const _gray500 = Color(0xFFADB6BD);
  // static const _gray400 = Color(0xFFCFD4DA);
  // static const _gray300 = Color(0xFFDEE1E6);
  // static const _gray200 = Color(0xFFE8ECEF);

  static const kDefaultMargin =
      EdgeInsets.only(left: 10, right: 10, bottom: 10);
  static const kDefaultBorderRadius = BorderRadius.all(Radius.circular(8));

  static const kDefaultPadding =
      EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0);
  static const kDefaultShadow = [
    BoxShadow(
      color: kDefaultShadowColor,
      offset: Offset(0, 8),
      spreadRadius: 0,
      blurRadius: 24, // has the effect of softening the shadow
    ),
  ];

  static const kDefaultShadowColor = Color.fromRGBO(33, 36, 41, 0.18);

  factory PlatformCardTheme.of(BuildContext context) {
    try {
      return Provider.of(context);
    } catch (e) {
      return const PlatformCardTheme();
    }
  }

  final String debugLabel;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color cardColor;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;

  const PlatformCardTheme(
      {this.boxShadow = kDefaultShadow,
      this.debugLabel,
      this.cardColor = Colors.white,
      this.padding = kDefaultPadding,
      this.margin = kDefaultMargin,
      this.borderRadius = kDefaultBorderRadius});

  PlatformCardTheme.ofRadius({
    double radiusAmount,
    this.boxShadow = kDefaultShadow,
    this.debugLabel,
    this.cardColor = Colors.white,
    this.padding = kDefaultPadding,
    this.margin = kDefaultMargin,
  }) : borderRadius = BorderRadius.all(Radius.circular(radiusAmount));

  @override
  String toString() {
    return 'PlatformCardTheme{debugLabel: $debugLabel, padding: $padding, margin: $margin, cardColor: $cardColor, borderRadius: $borderRadius, boxShadow: $boxShadow}';
  }
}
