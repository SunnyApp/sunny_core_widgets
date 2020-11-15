import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sunny_core_widgets/taps.dart';
import 'package:sunny_core_widgets/theme/sunny_colors.dart';
import 'package:sunny_core_widgets/theme/sunny_text_theme.dart';
import 'package:sunny_core_widgets/theme/sunny_theme_ext.dart';
import 'package:sunny_core_widgets/typedefs.dart';
import 'package:sunny_dart/sunny_dart.dart';
import 'package:sunny_sdk_core/sunny_sdk_core.dart';

class TextWidgets {
  static set lightColor(Color updateLightColor) {
    _lightColor = updateLightColor;
  }
}

Color _lightColor = Colors.black26;

class TileTitle extends StatelessWidget {
  final title;

  const TileTitle._(this.title, {Key key}) : super(key: key);

  factory TileTitle(title) {
    if (title == null) return null;
    return TileTitle._(title);
  }

  @override
  Widget build(BuildContext context) {
    return title is Widget
        ? (title as Widget)
        : Text(title.toString(),
            maxLines: 3, softWrap: true, overflow: TextOverflow.ellipsis);
  }
}

class TileSubtitle extends StatelessWidget {
  final title;

  const TileSubtitle._(this.title, {Key key}) : super(key: key);

  factory TileSubtitle(title) {
    if (title == null) return null;
    return TileSubtitle._(title);
  }

  @override
  Widget build(BuildContext context) {
    return title is Widget
        ? (title as Widget)
        : Text(title.toString(),
            maxLines: 3, softWrap: true, overflow: TextOverflow.ellipsis);
  }
}

Widget textOrNull(final txt,
    {TextAlign alignment,
    TextStyle style,
    Color color,
    bool wrap = true,
    int maxLines}) {
  if (txt is Widget) return txt;
  if (txt == null) return null;
  final text = "$txt";
  var _style = style ?? TextStyle();
  _style = _style.copyWith(color: color);

  return text.isNullOrBlank
      ? null
      : wrap == false
          ? maxLines != null && maxLines > 1
              ? Text(
                  text,
                  maxLines: maxLines,
                  style: _style,
                  textAlign: alignment,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                )
              : SingleLineText(
                  text,
                  style: _style,
                  alignment: alignment,
                )
          : Text(
              text,
              maxLines: maxLines,
              style: _style,
              textAlign: alignment,
              softWrap: true,
              overflow: TextOverflow.fade,
            );
}

class NormalText extends StatelessWidget {
  final String text;

  NormalText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.body2Normal,
    );
  }
}

// ignore: non_constant_identifier_names
Text SingleLineText(String text, {TextAlign alignment, TextStyle style}) =>
    text == null
        ? null
        : Text(
            text,
            textAlign: alignment,
            style: style,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          );

class PrimaryText extends StatelessWidget {
  final String text;
  final String label;
  final TextAlign textAlign;
  final bool nowrap;

  const PrimaryText(this.text,
      {this.label, this.textAlign, this.nowrap = false});

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return RichText(
        text: TextSpan(children: [
          TextSpan(
              text: label,
              style:
                  sunnyText.body2Normal.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(
              text: text ?? "",
              style: sunnyText.body2Normal
                  .copyWith(fontWeight: FontWeight.normal)),
        ]),
        textAlign: textAlign ?? TextAlign.start,
        maxLines: nowrap == true ? 1 : null,
        overflow: nowrap == true ? TextOverflow.ellipsis : TextOverflow.clip,
      );
    } else {
      return Text(
        text ?? "",
        style: sunnyText.body2Normal,
        maxLines: nowrap == true ? 1 : null,
        textAlign: textAlign ?? TextAlign.start,
        overflow: nowrap == true ? TextOverflow.ellipsis : TextOverflow.clip,
      );
    }
  }
}
//
// class LabelText extends StatelessWidget {
//   final String text;
//   final TextAlign textAlign;
//   final bool nowrap;
//
//   LabelText(this.text, {this.textAlign, this.nowrap = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text ?? "",
//       style: sunnyText.label,
//       maxLines: nowrap == true ? 1 : null,
//       textAlign: textAlign,
//       overflow: nowrap == true ? TextOverflow.ellipsis : null,
//     );
//   }
// }

class InputText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final bool nowrap;

  InputText(this.text, {this.textAlign, this.nowrap = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: sunnyText.input1,
      maxLines: nowrap == true ? 1 : null,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class PlaceholderText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  PlaceholderText(this.text, {this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.placeholder1,
      textAlign: textAlign,
    );
  }
}

class LinkText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final bool bold;
  final double fontSize;

  LinkText(this.text, {this.textAlign, this.fontSize, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.body1Link.copyWith(
        fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
        fontSize: fontSize,
      ),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}

class LargeTitle extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  LargeTitle(this.text, {this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.header4,
      textAlign: textAlign,
    );
  }
}

class SecondaryText extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool nowrap;

  SecondaryText(this.text, {this.isBold = false, this.nowrap = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.body2Normal
          .copyWith(fontWeight: isBold == true ? FontWeight.bold : null),
      maxLines: nowrap == true ? 1 : null,
      overflow: nowrap == true ? TextOverflow.ellipsis : TextOverflow.clip,
    );
  }
}

class TertiaryText extends StatelessWidget {
  final String text;
  final Color color;
  final bool isBold;

  TertiaryText(this.text, {this.color, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.body3Light.copyWith(
          color: color,
          fontWeight: this.isBold == true ? FontWeight.bold : null),
    );
  }
}

// class FinePrintLinkText extends StatelessWidget {
//   final String text;
//   final bool isBold;
//
//   FinePrintLinkText(this.text, {this.isBold = true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: sunnyText.finePrint.copyWith(
//         fontSize: 11,
//         color: SunnyColors.tertiaryText,
//         fontWeight: this.isBold == true ? FontWeight.bold : null,
//       ),
//     );
//   }
// }

class ErrorText extends StatelessWidget {
  final String text;

  ErrorText(this.text);

  ErrorText.ofValidationError(ValidationError error) : text = error.toString();

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "Unknown",
      style: sunnyText.body3Light.copyWith(color: Colors.red),
    );
  }
}

class PageSectionHeaderText extends StatelessWidget {
  final String text;

  const PageSectionHeaderText(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text ?? '',
        style: Theme.of(context).textTheme.headline4,
        maxLines: 1,
        overflow: TextOverflow.fade);
  }
}

enum FontType { light, normal, medium, bold }

class Headline3Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color color;

  const Headline3Text.normal(this.text, {this.color, Key key})
      : fontType = FontType.normal,
        super(key: key);

  const Headline3Text.bold(this.text, {this.color, Key key})
      : fontType = FontType.bold,
        super(key: key);

  const Headline3Text.medium(this.text, {this.color, Key key})
      : fontType = FontType.medium,
        super(key: key);

  const Headline3Text.light(this.text, {this.color, Key key})
      : fontType = FontType.light,
        super(key: key);

  const factory Headline3Text(String text, {Key key}) = Headline3Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.headline3;
}

class Headline4Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color color;

  const Headline4Text.normal(this.text, {this.color, Key key})
      : fontType = FontType.normal,
        super(key: key);

  const Headline4Text.bold(this.text, {this.color, Key key})
      : fontType = FontType.bold,
        super(key: key);

  const Headline4Text.medium(this.text, {this.color, Key key})
      : fontType = FontType.medium,
        super(key: key);

  const Headline4Text.light(this.text, {this.color, Key key})
      : fontType = FontType.light,
        super(key: key);

  const factory Headline4Text(String text, {Key key}) = Headline4Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.headline4;
}

typedef StyleExtractor = TextStyle Function(TextTheme theme);
typedef StyleAdjuster = TextStyle Function(TextStyle theme);

abstract class StyledText extends StatelessWidget {
  FontType get fontType;

  StyleExtractor get styleGetter;

  String get text;

  Color get color;

  bool get softWrap => null;

  int get maxLines => null;

  TextOverflow get overflow => null;

  @override
  Widget build(BuildContext context) {
    return buildText(context);
  }

  Widget buildText(BuildContext context, {TextAlign alignment}) {
    TextStyle style = styleGetter(Theme.of(context).textTheme);
    style = style.copyWith(color: color);
    switch (fontType) {
      case FontType.light:
        // Is there ever a bold or medium in the light color?
        style = style.copyWith(
            fontWeight: FontWeight.normal,
            color: _lightColor ?? style.color.withOpacity(0.7));
        break;
      case FontType.normal:
        style = style.copyWith(fontWeight: FontWeight.w400);
        break;
      case FontType.medium:
        style = style.copyWith(fontWeight: FontWeight.w500);
        break;
      case FontType.bold:
        style = style.copyWith(fontWeight: FontWeight.w900);
        break;
    }

    return Text(
      text ?? '',
      style: style,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textAlign: alignment,
    );
  }

  const StyledText({Key key}) : super(key: key);
}

class Body3Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color color;

  const Body3Text.normal(this.text, {this.color, Key key})
      : fontType = FontType.normal,
        super(key: key);

  const Body3Text.bold(this.text, {this.color, Key key})
      : fontType = FontType.bold,
        super(key: key);

  const Body3Text.medium(this.text, {this.color, Key key})
      : fontType = FontType.medium,
        super(key: key);

  const Body3Text.light(this.text, {this.color, Key key})
      : fontType = FontType.light,
        super(key: key);

  const factory Body3Text(String text, {Key key}) = Body3Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.caption;
}

class Body1Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color color;

  const Body1Text.normal(this.text, {this.color, Key key})
      : fontType = FontType.normal,
        super(key: key);

  const Body1Text.bold(this.text, {this.color, Key key})
      : fontType = FontType.bold,
        super(key: key);

  const Body1Text.medium(this.text, {this.color, Key key})
      : fontType = FontType.medium,
        super(key: key);

  const Body1Text.light(this.text, {this.color, Key key})
      : fontType = FontType.light,
        super(key: key);

  const factory Body1Text(String text, {Color color, Key key}) =
      Body1Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.bodyText1;
}

class Body0Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color color;

  const Body0Text.normal(this.text, {this.color, Key key})
      : fontType = FontType.normal,
        super(key: key);

  const Body0Text.bold(this.text, {this.color, Key key})
      : fontType = FontType.bold,
        super(key: key);

  const Body0Text.medium(this.text, {this.color, Key key})
      : fontType = FontType.medium,
        super(key: key);

  const Body0Text.light(this.text, {this.color, Key key})
      : fontType = FontType.light,
        super(key: key);

  const factory Body0Text(String text, {Color color, Key key}) =
      Body0Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.subtitle1;
}

class Body2Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color color;
  final bool softWrap;
  final int maxLines;
  final TextOverflow overflow;

  const Body2Text.normal(this.text,
      {this.softWrap, this.maxLines, this.overflow, this.color, Key key})
      : fontType = FontType.normal,
        super(key: key);

  const Body2Text.bold(this.text,
      {this.softWrap, this.maxLines, this.overflow, this.color, Key key})
      : fontType = FontType.bold,
        super(key: key);

  const Body2Text.medium(this.text,
      {this.softWrap, this.maxLines, this.overflow, this.color, Key key})
      : fontType = FontType.medium,
        super(key: key);

  const Body2Text.light(this.text,
      {this.softWrap, this.maxLines, this.overflow, this.color, Key key})
      : fontType = FontType.light,
        super(key: key);

  const factory Body2Text(String text,
      {bool softWrap,
      int maxLines,
      TextOverflow overflow,
      Color color,
      Key key}) = Body2Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.bodyText2;
}

typedef RichTextBuild = void Function(RichTextBuilder builder);

Widget richTextBuilder(BuildContext context, RichTextBuild build) {
  final b = RichTextBuilder(context);
  build(b);
  return b.build();
}

Widget richTextInvertedBuilder(
    BuildContext context, void build(RichTextBuilder builder)) {
  final b = RichTextBuilder.inverted(context);
  build(b);
  return b.build();
}

/**
 * Allows for building rich text using the known styles
 */
class RichTextBuilder {
  final BuildContext context;
  final TextTheme textTheme;
  final TextStyle lightStyle1;
  final TextStyle lightStyle2;

  /// These are build when needed- they aren't part of the normal styles
  TextStyle _header4Bold;
  TextStyle _header4Normal;

  TextStyle _temp;
  FutureBuildCallback _gesture;
  bool _preserveGestures = false;
  bool _preserveStyles = false;

  int _maxLines;
  TextAlign _textAlign = TextAlign.start;
  TextAlignVertical _textAlignVertical = TextAlignVertical.center;
  double _height = null;
  bool _softWrap = true;
  TextOverflow _overflow = TextOverflow.clip;

  final List<InlineSpan> children = [];

  RichTextBuilder(BuildContext context, {Color lightColor})
      : this.ofTextTheme(
            context: context, textTheme: Theme.of(context).textTheme);

  RichTextBuilder.dark(BuildContext context, {Color lightColor})
      : this.ofTextTheme(
            context: context, textTheme: context.darkTheme.textTheme);

  RichTextBuilder.inverted(BuildContext context, {Color lightColor})
      : this.ofTextTheme(
            context: context, textTheme: context.invertedTheme.textTheme);

  RichTextBuilder.ofTextTheme(
      {@required this.context, this.textTheme, Color lightColor})
      : lightStyle2 = textTheme.bodyText2.copyWith(
            color: lightColor ??
                _lightColor ??
                textTheme.bodyText2.color.withOpacity(0.7)),
        lightStyle1 = textTheme.bodyText1.copyWith(
            color: lightColor ??
                _lightColor ??
                textTheme.bodyText1.color.withOpacity(0.7));

  RichTextBuilder space([int count = 1]) {
    children.add(TextSpan(text: ' '.repeat(count)));
    return this;
  }

  RichTextBuilder body2(String text) {
    return applyChild(text, baseStyle: textTheme.bodyText2);
  }

  RichTextBuilder icon(IconData data,
      {double size, Color color, double offset}) {
    if (data == null) return this;
    size ??= 20;
    offset ??= 0;
    final sizeWithOffset = size + offset;
    return widget(SizedBox(
        height: sizeWithOffset,
        width: size,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Icon(
            data,
            size: size,
            color: color ?? sunnyColors.text,
          ),
        )));

    // children.add(TextSpan(
    //   text: String.fromCharCode(data.codePoint),
    //   style: TextStyle(
    //       fontFamily: data.fontFamily,
    //       fontSize: size,
    //       color: color ?? sunnyColors.text),
    // ));
    // return this;
  }

  RichTextBuilder widget(Widget widget) {
    if (widget != null) {
      children.add(WidgetSpan(
        child: Semantics(enabled: true, child: widget),
        alignment: PlaceholderAlignment.middle,
        // baseline: TextBaseline.alphabetic,
      ));
    }
    return this;
  }

  RichTextBuilder preserve() {
    return this
      .._preserveStyles = true
      .._preserveGestures = true;
  }

  RichTextBuilder white() {
    return color(Colors.white);
  }

  RichTextBuilder softWrap() {
    return this.._softWrap = true;
  }

  RichTextBuilder nowrap() {
    return this.._softWrap = false;
  }

  RichTextBuilder twoLines() {
    return this.._maxLines = 2;
  }

  RichTextBuilder singleLine() {
    return this.._maxLines = 1;
  }

  RichTextBuilder maxLines(int maxLines) {
    return this.._maxLines = maxLines;
  }

  RichTextBuilder truncate([TextOverflow overflow]) {
    return this.._overflow = overflow ?? TextOverflow.ellipsis;
  }

  RichTextBuilder center() {
    return this.._textAlign = TextAlign.center;
  }

  RichTextBuilder align(TextAlign align) {
    return this.._textAlign = align;
  }

  RichTextBuilder onTap(FutureBuildCallback callback, {bool isFixed = false}) {
    _gesture = callback;
    _preserveGestures = isFixed;
    return this;
  }

  RichTextBuilder color(Color color) {
    return this.._temp = _tmpStyle.copyWith(color: color);
  }

  RichTextBuilder underline() {
    return this
      .._temp = _tmpStyle.copyWith(decoration: TextDecoration.underline);
  }

  RichTextBuilder fontSize(double size) {
    return this.._temp = _tmpStyle.copyWith(fontSize: size);
  }

  RichTextBuilder style(TextStyle style) {
    return this.._temp = _tmpStyle.mergeOrDefault(style);
  }

  RichTextBuilder height(double height) {
    return this.._height = height;
  }

  RichTextBuilder textVertAlign(TextAlignVertical vert) {
    return this.._textAlignVertical = vert;
  }

  RichTextBuilder applyChild(
    String text, {
    TextStyle baseStyle,
  }) {
    if (!text.isNullOrBlank) {
      GestureRecognizer recognizer;
      if (_gesture != null && !_preserveGestures) {
        final tapCallback = _gesture;
        recognizer = TapGestureRecognizer()
          ..onTap = () {
            tapCallback(context);
          };
        _gesture = null;
      }
      children.add(TextSpan(
        style: baseStyle.mergeOrDefault(_temp),
        text: text,
        recognizer: recognizer,
        semanticsLabel: "Tap to open record",
      ));
    }
    if (_preserveStyles != true) _temp = null;

    return this;
  }

  TextStyle get _tmpStyle {
    return _temp ??= const TextStyle();
  }

  RichTextBuilder text(String text) {
    return applyChild(text, baseStyle: textTheme.bodyText2);
  }

  RichTextBuilder bold2(String text) {
    return applyChild(text, baseStyle: textTheme.headline6);
  }

  RichTextBuilder medium2(String text) {
    return applyChild(text, baseStyle: textTheme.subtitle2);
  }

  RichTextBuilder light2(String text) {
    return applyChild(text, baseStyle: lightStyle2);
  }

  RichTextBuilder body1(String text) {
    return applyChild(text, baseStyle: textTheme.bodyText1);
  }

  RichTextBuilder medium1(String text) {
    return applyChild(text, baseStyle: textTheme.subtitle2);
  }

  RichTextBuilder bold1(String text) {
    return applyChild(text, baseStyle: textTheme.headline5);
  }

  RichTextBuilder h4bold(String text) {
    return applyChild(text,
        baseStyle: _header4Bold ??=
            textTheme.headline4.copyWith(fontWeight: FontWeight.bold));
  }

  RichTextBuilder h4normal(String text) {
    return applyChild(text,
        baseStyle: _header4Normal ??=
            textTheme.headline4.copyWith(fontWeight: FontWeight.normal));
  }

  RichTextBuilder h4(String text) {
    return applyChild(text, baseStyle: textTheme.headline4);
  }

  RichTextBuilder light1(String text) {
    return applyChild(text, baseStyle: lightStyle1);
  }

  Widget build() {
    TextStyle ts = null;
    if (_height != null) {
      ts = TextStyle(height: _height);
    }
    final richText = RichText(
      text: TextSpan(children: children, style: ts),
      softWrap: _softWrap,
      textAlign: _textAlign,
      maxLines: _maxLines,
      overflow: _overflow,
    );
    return _gesture == null
        ? richText
        : Tappable(
            onTap: _gesture,
            child: richText,
          );
  }
}

extension BuildContextRichText on BuildContext {
  Widget richText(RichTextBuild builder) {
    return richTextBuilder(this, builder);
  }

  Widget richTextInverted(RichTextBuild builder) {
    return richTextInvertedBuilder(this, builder);
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final bool nowrap;

  const TitleText(this.text, {this.textAlign, this.nowrap = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: sunnyText.header2,
      maxLines: nowrap == true ? 1 : null,
      textAlign: textAlign,
      softWrap: nowrap != false,
      overflow: TextOverflow.fade,
    );
  }
}

extension TextStyleMergeExt on TextStyle {
  TextStyle orDefault([TextStyle def]) => this ?? def ?? const TextStyle();

  TextStyle mergeOrDefault([TextStyle mergeTarget]) {
    if (this == null || mergeTarget == null) {
      return this ?? mergeTarget;
    } else {
      return this.merge(mergeTarget);
    }
  }
}
