import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/cupertino/text_theme.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';
import 'package:sunny_core_widgets/text/text_widgets.dart';
import 'package:sunny_dart/helpers.dart';
import 'package:sunny_dart/is_x.dart';
import 'package:sunny_dart/sunny_dart.dart';

import 'sunny_colors.dart';

const defaultFontFamily = 'Roboto';
const mediumWeight = FontWeight.w500;

const input0Size = 18.0;
const input0Height = 24.0 / 18.0;
const input0Spacing = 0.0;

const body1Size = 16.0;
const body1Height = 22.0 / 16.0;
const body1Spacing = 0.5;

const body2Size = 14.0;
const body2Height = 19.0 / 14.0;
const body2Spacing = 0.44;

const body3Size = 13.0;
const body3Height = 15.0 / 13.0;
const body3Spacing = 0.41;

SunnyTextTheme get sunnyText =>
    _sunnyText ?? illegalState("No theme initialized");

SunnyTextTheme _sunnyText;

/// List of font styles based on reliveit naming conventions.  This can be easily applied to a material
/// or cupertino theme.
class SunnyTextTheme {
  // 800

  final double fontScale;
  final TextStyle body1Normal;
  final TextStyle body1Medium;

  final TextStyle input0;
  final TextStyle placeholder0;
  final TextStyle body1Bold;
  final TextStyle body1Light;
  final TextStyle body1Link;
  final TextStyle body2Normal;
  final TextStyle body2Medium;
  final TextStyle body2Bold;
  final TextStyle body2Link;
  final TextStyle body2Light;
  final TextStyle header4;
  final TextStyle header3;
  final TextStyle header2;
  final TextStyle header1;
  final TextStyle body3Light;
  final TextStyle body3Link;
  final TextStyle input1;
  final TextStyle input2;

  final TextStyle hero;
  final TextStyle heroMedium;
  final TextStyle heroBold;

  TextStyle get tabBarInactive => body3Light;

  TextStyle get tabBarActive => body3Link;

  TextStyle get placeholder1 => body1Light;

  TextStyle get placeholder2 => body2Light;

  static void setFontScale(double scale) {
    assert(scale != null);

    _sunnyTextTheme = SunnyTextTheme.defaults;
    _sunnyTextTheme = _sunnyTextTheme.applyEach((style) {
      return style.apply(fontSizeFactor: scale);
    }).copyWith(fontScale: scale);
  }

  static void setBrightness(BuildContext context) {
    _sunnyTextTheme ??= SunnyTextTheme.defaults;
    _sunnyTextTheme = _sunnyTextTheme.applyEach((style) {
      final resolved = style.color;
      return style.copyWith(color: resolved);
    });
  }

  static void init([SunnyTextTheme theme]) {
    _sunnyText = theme ?? SunnyTextTheme.defaults;
  }

  factory SunnyTextTheme() => _sunnyTextTheme ??= SunnyTextTheme.defaults;

  /// The internal constructor
  SunnyTextTheme._({
    @required this.fontScale,
    @required this.body1Normal,
    @required this.body1Medium,
    @required this.body1Bold,
    @required this.body1Light,
    @required this.body2Normal,
    @required this.body2Medium,
    @required this.body2Bold,
    @required this.body2Light,
    @required this.header4,
    @required this.header3,
    @required this.header2,
    @required this.header1,
    @required this.body3Light,
    @required this.body3Link,
    @required this.input1,
    @required this.input2,
    @required this.hero,
    @required this.heroBold,
    @required this.heroMedium,
    @required this.input0,
    @required this.placeholder0,
  })  : body1Link = body1Medium.copyWith(color: sunnyColors.linkColor),
        body2Link = body2Medium.copyWith(color: sunnyColors.linkColor);

  static final defaults = SunnyTextTheme._(
    fontScale: 1.0,
    body1Normal: TextStyle(
      fontSize: body1Size,
      letterSpacing: body1Spacing,
      height: body1Height,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.normal,
      color: sunnyColors.text,
    ),
    body1Medium: TextStyle(
      fontSize: body1Size,
      letterSpacing: body1Spacing,
      height: body1Height,
      fontFamily: defaultFontFamily,
      color: sunnyColors.text,
      fontWeight: mediumWeight,
    ),
    body1Bold: TextStyle(
      fontSize: body1Size,
      letterSpacing: body1Spacing,
      height: body1Height,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.bold,
      color: sunnyColors.text,
    ),
    body1Light: TextStyle(
      fontSize: body1Size,
      letterSpacing: body1Spacing,
      height: body1Height,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.normal,
      color: sunnyColors.textLight,
    ),
    body2Normal: TextStyle(
      fontSize: body2Size,
      letterSpacing: body2Spacing,
      height: body2Height,
      fontFamily: defaultFontFamily,
      color: sunnyColors.text,
      fontWeight: FontWeight.normal,
    ),
    body2Medium: TextStyle(
      fontSize: body2Size,
      letterSpacing: body2Spacing,
      height: body2Height,
      fontFamily: defaultFontFamily,
      color: sunnyColors.text,
      fontWeight: mediumWeight,
    ),
    body2Bold: TextStyle(
      fontSize: body2Size,
      letterSpacing: body2Spacing,
      height: body2Height,
      fontFamily: defaultFontFamily,
      color: sunnyColors.text,
      fontWeight: FontWeight.bold,
    ),
    body2Light: TextStyle(
      fontSize: body2Size,
      letterSpacing: body2Spacing,
      height: body2Height,
      fontFamily: defaultFontFamily,
      color: sunnyColors.textLight,
      fontWeight: FontWeight.normal,
    ),
    header1: TextStyle(
      fontFamily: defaultFontFamily,
      fontWeight: mediumWeight,
      letterSpacing: 0.63,
      fontSize: 32,
      color: sunnyColors.text,
    ),
    header2: TextStyle(
      fontFamily: defaultFontFamily,
      fontWeight: mediumWeight,
      letterSpacing: 0.63,
      fontSize: 28,
      color: sunnyColors.text,
    ),
    header3: TextStyle(
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.bold,
      height: 32 / 24,
      letterSpacing: 0.75,
      fontSize: 24,
      color: sunnyColors.g700,
    ),
    header4: TextStyle(
      fontFamily: defaultFontFamily,
      fontWeight: mediumWeight,
      letterSpacing: 0.63,
      height: 27.0 / 20,
      fontSize: 20,
      color: sunnyColors.text,
    ),
    input1: TextStyle(
      fontSize: body1Size,
      letterSpacing: body1Spacing,
      height: body1Height,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.normal,
      color: sunnyColors.text,
    ),
    input2: TextStyle(
      fontSize: body2Size,
      letterSpacing: body2Spacing,
      height: body2Height,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.normal,
      color: sunnyColors.text,
    ),
    body3Link: TextStyle(
      fontSize: body3Size,
      letterSpacing: body3Spacing,
      height: body3Height,
      fontFamily: defaultFontFamily,
      fontWeight: mediumWeight,
      color: sunnyColors.linkColor,
    ),
    body3Light: TextStyle(
      fontSize: body3Size,
      letterSpacing: body3Spacing,
      height: body3Height,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.normal,
      color: sunnyColors.textLight,
    ),
    hero: TextStyle(
      fontSize: 20,
      letterSpacing: 0.63,
      height: 30.0 / 20.0,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.normal,
      color: sunnyColors.text,
    ),
    heroMedium: TextStyle(
      fontSize: 20,
      letterSpacing: 0.63,
      height: 30.0 / 20.0,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.w500,
      color: sunnyColors.text,
    ),
    heroBold: TextStyle(
      fontSize: 20,
      letterSpacing: 0.63,
      height: 30.0 / 20.0,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.bold,
      color: sunnyColors.text,
    ),
    input0: TextStyle(
      fontSize: input0Size,
      letterSpacing: input0Spacing,
      height: 30.0 / 20.0,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.normal,
      color: sunnyColors.text,
    ),
    placeholder0: TextStyle(
      fontSize: input0Size,
      letterSpacing: input0Spacing,
      height: 30.0 / 20.0,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.normal,
      color: sunnyColors.textLight,
    ),
  );

  TextStyle applyDefaults(TextStyle style) {
    return style.copyWith(fontFamily: defaultFontFamily);
  }

  TextTheme apply(TextTheme original, {TextStyle inputStyle}) {
    return original.copyWith(
      headline1: header1,
      headline2: header2,
      headline3: header3,
      headline4: header4,
      headline5: body1Bold,
      headline6: body2Bold,
      subtitle1: inputStyle ?? body1Medium,
      subtitle2: body2Medium,
      bodyText1: body1Normal,
      bodyText2: body2Normal,
      caption: body3Light,
      button: body1Medium,
      overline: body3Light,
    );
  }

  CupertinoTextThemeData applyCupertino(CupertinoTextThemeData original) {
    return original.copyWith(
      primaryColor: sunnyColors.g800,
      tabLabelTextStyle: body3Light,
      textStyle: body2Normal,
      navTitleTextStyle: body1Medium,
      navLargeTitleTextStyle: header4,
      navActionTextStyle: body2Medium,
      actionTextStyle: body1Medium,
    );
  }

  SunnyTextTheme copyWith({
    double fontScale,
    TextStyle body1Normal,
    TextStyle body1Medium,
    TextStyle body1Bold,
    TextStyle body1Light,
    TextStyle body2Normal,
    TextStyle body2Medium,
    TextStyle body2Bold,
    TextStyle body2Light,
    TextStyle header4,
    TextStyle header3,
    TextStyle header2,
    TextStyle header1,
    TextStyle body3Light,
    TextStyle body3Link,
    TextStyle input1,
    TextStyle input2,
    TextStyle hero,
    TextStyle heroBold,
    TextStyle heroMedium,
    TextStyle input0,
    TextStyle placeholder0,
  }) {
    return new SunnyTextTheme._(
      fontScale: fontScale ?? this.fontScale,
      body1Normal: body1Normal ?? this.body1Normal,
      body1Medium: body1Medium ?? this.body1Medium,
      body1Bold: body1Bold ?? this.body1Bold,
      body1Light: body1Light ?? this.body1Light,
      body2Normal: body2Normal ?? this.body2Normal,
      body2Medium: body2Medium ?? this.body2Medium,
      body2Bold: body2Bold ?? this.body2Bold,
      body2Light: body2Light ?? this.body2Light,
      header4: header4 ?? this.header4,
      header3: header3 ?? this.header3,
      header2: header2 ?? this.header2,
      header1: header1 ?? this.header1,
      body3Light: body3Light ?? this.body3Light,
      body3Link: body3Link ?? this.body3Link,
      input1: input1 ?? this.input1,
      input2: input2 ?? this.input2,
      hero: hero ?? this.hero,
      heroBold: heroBold ?? this.heroBold,
      heroMedium: heroMedium ?? this.heroMedium,
      input0: input0 ?? this.input0,
      placeholder0: placeholder0 ?? this.placeholder0,
    );
  }

  SunnyTextTheme applyEach(TextStyle modification(TextStyle input)) {
    return SunnyTextTheme._(
      fontScale: fontScale,
      body1Normal: modification(this.body1Normal),
      body1Medium: modification(this.body1Medium),
      body1Bold: modification(this.body1Bold),
      body1Light: modification(this.body1Light),
      body2Normal: modification(this.body2Normal),
      body2Medium: modification(this.body2Medium),
      body2Bold: modification(this.body2Bold),
      body2Light: modification(this.body2Light),
      header4: modification(this.header4),
      header3: modification(this.header3),
      header2: modification(this.header2),
      header1: modification(this.header1),
      body3Light: modification(this.body3Light),
      input1: modification(this.input1),
      input2: modification(this.input2),
      body3Link: modification(this.body3Link),
      hero: modification(this.hero),
      heroMedium: modification(this.heroMedium),
      heroBold: modification(this.heroBold),
      input0: modification(this.input0),
      placeholder0: modification(this.placeholder0),
    );
  }
}

extension TextStylePlatformExt on TextStyle {
  TextStyle get selected {
    return infoX.isIOS ? this : this.copyWith(color: sunnyColors.white);
  }

  TextStyle get light {
    return this.copyWith(color: sunnyColors.g600);
  }
}

SunnyTextTheme _sunnyTextTheme;

class HeroText extends StyledText {
  final String text;
  final FontType fontType;
  final Color color;

  const HeroText.normal(this.text, {this.color, Key key})
      : fontType = FontType.normal,
        super(key: key);

  const HeroText.bold(this.text, {this.color, Key key})
      : fontType = FontType.bold,
        super(key: key);

  const HeroText.medium(this.text, {this.color, Key key})
      : fontType = FontType.medium,
        super(key: key);

  const HeroText.light(this.text, {this.color, Key key})
      : fontType = FontType.light,
        super(key: key);

  const factory HeroText(String text, {Key key}) = HeroText.normal;

  @override
  StyleExtractor get styleGetter => (theme) => SunnyTextTheme().hero;
}

extension RichTextBuilderTrippiExt on RichTextBuilder {
  RichTextBuilder heroBold(String text) {
    if (text.isNotNullOrBlank) {
      children.add(TextSpan(
          text: text,
          style: textTheme.headline4.copyWith(fontWeight: FontWeight.bold)));
    }
    return this;
  }

  RichTextBuilder hero(String text) {
    if (text.isNotNullOrBlank) {
      children.add(TextSpan(
          text: text,
          style: textTheme.headline4.copyWith(fontWeight: FontWeight.normal)));
    }
    return this;
  }
}

extension TextStyleWidgetBuilderExt on TextStyle {
  Widget build(String text, {TextAlign textAlign = TextAlign.left}) {
    return Text(text, style: this, textAlign: textAlign);
  }
}
