import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sunny_core_widgets/provided.dart';
import 'package:sunny_core_widgets/theme/themes.dart';

// final x = colorExtension();
extension BuildContextThemes on BuildContext {
  Themes get themes {
    return Provided.get(this);
  }

  ThemeData get darkTheme {
    return themes.darkTheme;
  }

  ThemeData get lightTheme {
    return themes.lightTheme;
  }

  Brightness get brightness {
    return themes.brightness;
  }

  ThemeData get currentTheme {
    switch (brightness) {
      case Brightness.dark:
        return darkTheme;
      case Brightness.light:
        return lightTheme;
      default:
        return lightTheme;
    }
  }

  ThemeData get invertedTheme {
    switch (brightness) {
      case Brightness.dark:
        return lightTheme;
      case Brightness.light:
        return darkTheme;
      default:
        return darkTheme;
    }
  }
}
