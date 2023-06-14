import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sunny_platform_widgets/sunny_platform_widgets.dart';

extension BuildContextCoreLayoutExt on BuildContext {
  bool get isMacos {
    var thisPlatform = platform(this);
    return thisPlatform == PlatformTarget.macOS && !kIsWeb;
  }

  bool get isMacosOrWeb {
    return platform(this) == PlatformTarget.macOS;
  }
}
