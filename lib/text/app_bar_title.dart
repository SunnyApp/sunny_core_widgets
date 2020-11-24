import 'package:flutter/cupertino.dart';
import 'package:sunny_core_widgets/theme/sunny_text_theme.dart';
import 'package:sunny_dart/typedefs.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  final Getter<TextStyle> style;

  const AppBarTitle.large(this.title) : style = _largeTitle;

  const AppBarTitle(this.title, {Key key})
      : style = _smallTitle,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: style());
  }
}

TextStyle _smallTitle() {
  return sunnyText.body1Medium;
}

TextStyle _largeTitle() {
  return sunnyText.input0;
}
