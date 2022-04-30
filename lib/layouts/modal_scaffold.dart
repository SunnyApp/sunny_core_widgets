import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';
import 'package:sunny_essentials/theme/sunny_colors.dart';

class PlatformModalScaffold extends PlatformWidget {
  final bool dismissible;
  final Widget? title;
  final bool isScrolling;
  final bool automaticallyImplyLeading;
  final Widget body;

  PlatformModalScaffold({
    Key? key,
    this.dismissible = true,
    this.isScrolling = false,
    this.title,
    this.automaticallyImplyLeading = true,
    required this.body,
  }) : super(key: key);

  @override
  Widget createCupertinoWidget(BuildContext context) {
    return createWidget(context);
  }

  @override
  Widget createMaterialWidget(BuildContext context) {
    return createWidget(context);
  }

  Widget createWidget(BuildContext context) {
    final appBar = title == null
        ? null
        : PlatformAppBar(
            backgroundColor: sunnyColors.modalBackground,
            title: title,
            cupertino: (context, platform) => CupertinoNavigationBarData(
              brightness: context.brightness,
            ),
            material: (context, platform) => MaterialAppBarData(
                brightness: context.brightness,
                centerTitle: true,
                textTheme: sunnyText
                    .apply(TextTheme())
                    .withBrightness(context.brightness),
                iconTheme: IconThemeData(
                  color: sunnyColors.primaryColor,
                )),
            automaticallyImplyLeading: automaticallyImplyLeading,
          );
    if (isScrolling) {
      return PlatformScaffold(
        backgroundColor: sunnyColors.modalBackground,
        appBar: appBar,
        body: body,
      ).tpad(dismissible ? 1 : 0);
    } else {
      return Layout.column().reset.min.build([
        if (dismissible) verticalSpace,
        if (appBar != null) appBar,
        body,
      ]);
    }
  }
}
