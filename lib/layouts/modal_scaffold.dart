import 'package:flutter/material.dart';
import 'package:sunny_platform_widgets/sunny_platform_widgets.dart';
import 'package:sunny_core_widgets/sunny_core_widgets.dart';

class PlatformModalScaffold extends PlatformWidget {
  final bool dismissible;
  final Widget? title;
  final Widget? leading;
  final bool hideAppBar;
  final bool hasAppBar;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;
  final Widget body;
  final List<Widget> actions;
  final ModalConstraints? constraints;
  final List<Widget> buttons;
  final bool scrolling;

  PlatformModalScaffold({
    Key? key,
    this.dismissible = true,
    this.hideAppBar = false,
    this.actions = const [],
    this.leading,
    this.hasAppBar = true,
    this.padding,
    this.constraints,
    this.backgroundColor,
    this.title,
    this.scrolling = false,
    this.automaticallyImplyLeading = false,
    this.buttons = const [],
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
    var backgroundColor = this.backgroundColor ??
        ModalScaffoldInfo.backgroundColor(context) ??
        sunnyColors.modalBackground;

    final appBar = title == null
        ? null
        : PlatformAppBar(
            backgroundColor: backgroundColor,
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
            automaticallyImplyLeading: dismissible && automaticallyImplyLeading,
            leading: leading ?? buildNestedBackButton(context),
            trailingActions: actions,
          );

    var modalSize = ModalConstraints.of(context, [constraints]);
    return modalSize.build(context,
        child: PlatformScaffold(
          backgroundColor: backgroundColor,
          appBar: appBar,
          body: body.pad(),
        )
        // : Layout.column().reset.min.crossAxisStretch.build(
        //     [
        //       if (dismissible) verticalSpace,
        //       if (appBar != null) appBar,
        //       body,
        //       PlatformModalButtonRow(
        //         buttons: buttons,
        //       ),
        //     ],
        //   ),
        );
  }

  Widget? buildNestedBackButton(BuildContext context,
      {bool rootNavigator = true}) {
    var isNested = NestedNavigatorContainer.isNested(context);
    return isNested
        ? PlatformBackButton(
            onPressed: () {
              NestedNavigatorContainer.popSingle(
                context,
                rootNavigator: rootNavigator,
              );
            },
          )
        : null;
  }
}

class PlatformModalButtonRow extends StatelessWidget {
  final List<Widget> buttons;

  const PlatformModalButtonRow({Key? key, required this.buttons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (buttons.length == 1) {
      return buttons.first;
    } else {
      return Layout.row().spacing(8).build([
        for (var button in buttons)
          Flexible(flex: 1, child: Center(child: button)),
      ]);
    }
  }
}
