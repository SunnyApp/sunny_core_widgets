import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sunny_platform_widgets/sunny_platform_widgets.dart';

extension BuildContextCoreLayoutExt on BuildContext {
  bool get isMacos {
    return platform(this) == PlatformTarget.macOS && !kIsWeb;
  }

  bool get isMacosOrWeb {
    return platform(this) == PlatformTarget.macOS;
  }
}
