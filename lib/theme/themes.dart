import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sunny_core_widgets/platform_card_theme.dart';
import 'package:sunny_core_widgets/theme/visual_style.dart';

typedef ThemeDataBuilder = ThemeData Function(
    Brightness brightness, TextStyle inputStyle, TextStyle placeholder1);

class Themes with EquatableMixin {
  final Brightness brightness;
  final ThemeDataBuilder themeBuilder;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final CupertinoVisualStyle visualStyle;
  final CupertinoThemeData cupertinoTheme;
  final PlatformCardTheme cardTheme;

  Themes(
      {@required this.brightness,
      @required this.cardTheme,
      @required this.themeBuilder,
      @required this.lightTheme,
      @required this.visualStyle,
      @required this.cupertinoTheme,
      @required this.darkTheme});

  @override
  List<Object> get props => [brightness, lightTheme, darkTheme, cupertinoTheme];
}
