import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:info_x/info_x.dart';

typedef ScreenInit = void Function(BuildContext context, LayoutInfo layoutInfo);
typedef PlatformScreenInit = void Function(
    PlatformLayoutInfo platformLayoutInfo);

class LayoutInfo extends Equatable {
  final DeviceScreenType screenType;
  final Size screenSize;
  final PlatformStyle platformStyle;
  final TargetPlatform targetPlatform;

  LayoutInfo.ofSize(
    this.screenSize,
    this.screenType,
    this.platformStyle,
    this.targetPlatform,
  );

  @override
  List<Object> get props => [screenSize];
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
