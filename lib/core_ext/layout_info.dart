import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sunny_platform_widgets/sunny_platform_widgets.dart';
import 'package:sunny_essentials/sunny_essentials.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:info_x/info_x.dart';

typedef ScreenInit = void Function(BuildContext context, SunnyColors colors, LayoutInfo layoutInfo);
typedef PlatformScreenInit = void Function(
    PlatformLayoutInfo platformLayoutInfo);

class LayoutInfo extends Equatable {
  final DeviceScreenType screenType;
  final Size screenSize;
  final RefinedSize refinedSize;
  final PlatformStyle platformStyle;
  final TargetPlatform targetPlatform;

  LayoutInfo.ofSize(
    this.screenSize,
    this.screenType,
    this.platformStyle,
    this.targetPlatform,
  ) : refinedSize = getRefinedSize(screenSize);

  @override
  List<Object> get props => [screenSize];

  bool get isSmall => refinedSize.index <= RefinedSize.small.index;
  bool get isLarge => refinedSize.index >= RefinedSize.large.index;
  bool get isExtraLarge => refinedSize == RefinedSize.extraLarge;
  bool get isNormal => refinedSize == RefinedSize.normal;
}

class PlatformLayoutInfo extends Equatable {
  final TargetPlatform platform;
  final Size screenSize;
  final DeviceScreenType screenType;
  final EdgeInsets safeArea;
  final DeviceInfo deviceInfo;
  final PlatformStyle platformStyle;
  PlatformLayoutInfo(this.platform, this.screenSize, this.screenType,
      this.safeArea, this.deviceInfo, this.platformStyle);
  PlatformLayoutInfo.ofLayoutInfo(
      LayoutInfo layoutInfo, this.platform, this.safeArea, this.deviceInfo)
      : screenSize = layoutInfo.screenSize,
        platformStyle = layoutInfo.platformStyle,
        screenType = layoutInfo.screenType;

  @override
  List<Object> get props => [screenSize, platform, deviceInfo, platformStyle];

  bool get isCupertino => platformStyle == PlatformStyle.Cupertino;
}

RefinedSize getRefinedSize(
  Size size, {
  RefinedBreakpoints? refinedBreakpoint,
  bool isWebOrDesktop = kIsWeb,
}) {
  DeviceScreenType deviceScreenType = getDeviceType(size);
  double deviceWidth = size.width;

  if (isWebOrDesktop) {
    deviceWidth = size.width;
  }

  // Replaces the defaults with the user defined definitions
  if (refinedBreakpoint != null) {
    if (deviceScreenType == DeviceScreenType.desktop) {
      if (deviceWidth > refinedBreakpoint.desktopExtraLarge) {
        return RefinedSize.extraLarge;
      }

      if (deviceWidth > refinedBreakpoint.desktopLarge) {
        return RefinedSize.large;
      }

      if (deviceWidth > refinedBreakpoint.desktopNormal) {
        return RefinedSize.normal;
      }
    }

    if (deviceScreenType == DeviceScreenType.tablet) {
      if (deviceWidth > refinedBreakpoint.tabletExtraLarge) {
        return RefinedSize.extraLarge;
      }

      if (deviceWidth > refinedBreakpoint.tabletLarge) {
        return RefinedSize.large;
      }

      if (deviceWidth > refinedBreakpoint.tabletNormal) {
        return RefinedSize.normal;
      }
    }

    if (deviceScreenType == DeviceScreenType.mobile) {
      if (deviceWidth > refinedBreakpoint.mobileExtraLarge) {
        return RefinedSize.extraLarge;
      }

      if (deviceWidth > refinedBreakpoint.mobileLarge) {
        return RefinedSize.large;
      }

      if (deviceWidth > refinedBreakpoint.mobileNormal) {
        return RefinedSize.normal;
      }
    }

    if (deviceScreenType == DeviceScreenType.watch) {
      return RefinedSize.normal;
    }
  } else {
    // If no user defined definitions are passed through use the defaults

    // Desktop
    if (deviceScreenType == DeviceScreenType.desktop) {
      if (deviceWidth >=
          ResponsiveSizingConfig
              .instance.refinedBreakpoints.desktopExtraLarge) {
        return RefinedSize.extraLarge;
      }

      if (deviceWidth >=
          ResponsiveSizingConfig.instance.refinedBreakpoints.desktopLarge) {
        return RefinedSize.large;
      }

      if (deviceWidth >=
          ResponsiveSizingConfig.instance.refinedBreakpoints.desktopNormal) {
        return RefinedSize.normal;
      }
    }

    // Tablet
    if (deviceScreenType == DeviceScreenType.tablet) {
      if (deviceWidth >=
          ResponsiveSizingConfig.instance.refinedBreakpoints.tabletExtraLarge) {
        return RefinedSize.extraLarge;
      }

      if (deviceWidth >=
          ResponsiveSizingConfig.instance.refinedBreakpoints.tabletLarge) {
        return RefinedSize.large;
      }

      if (deviceWidth >=
          ResponsiveSizingConfig.instance.refinedBreakpoints.tabletNormal) {
        return RefinedSize.normal;
      }
    }

    // Mobile
    if (deviceScreenType == DeviceScreenType.mobile) {
      if (deviceWidth >=
          ResponsiveSizingConfig.instance.refinedBreakpoints.mobileExtraLarge) {
        return RefinedSize.extraLarge;
      }

      if (deviceWidth >=
          ResponsiveSizingConfig.instance.refinedBreakpoints.mobileLarge) {
        return RefinedSize.large;
      }

      if (deviceWidth >=
          ResponsiveSizingConfig.instance.refinedBreakpoints.mobileNormal) {
        return RefinedSize.normal;
      }
    }
  }

  return RefinedSize.small;
}
