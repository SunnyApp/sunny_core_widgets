import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sunny_core_widgets/provided.dart';
import 'package:sunny_core_widgets/theme/sunny_text_theme.dart';
import 'package:sunny_core_widgets/theme/themes.dart';

ThemeData form0Theme(Themes themes, Brightness brightness) {
  final tt = sunnyText;
  return themes.themeBuilder(
    brightness,
    tt.input0,
    tt.placeholder0,
  );
}

class Form0Theme extends StatelessWidget {
  final Widget child;

  const Form0Theme({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context);

    return Theme(data: form0Theme(context.get(), context.get()), child: child);
  }
}
