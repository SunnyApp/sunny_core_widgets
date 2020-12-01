import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sunny_core_widgets/container/spaced.dart';
import 'package:sunny_core_widgets/platform_card.dart';
import 'package:sunny_core_widgets/platform_list_tile.dart';

enum DeniedBehavior { openSettings, hideWidget }

class PermissionSuggestCard extends StatefulWidget {
  final PlatformListTile requestArgs;
  final PlatformListTile openSettingsArgs;
  final WidgetBuilder grantedBuilder;
  final AsyncValueSetter<PermissionStatus> onStatusChanged;
  final Permission permission;
  final DeniedBehavior deniedBehavior;

  const PermissionSuggestCard(
      {Key key,
      @required this.permission,
      this.deniedBehavior = DeniedBehavior.openSettings,
      this.requestArgs,
      this.openSettingsArgs,
      this.onStatusChanged,
      this.grantedBuilder})
      : super(key: key);

  @override
  _PermissionSuggestCardState createState() => _PermissionSuggestCardState();
}

class _PermissionSuggestCardState extends State<PermissionSuggestCard> {
  PermissionStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return emptyBox;
    }
    switch (status) {
      case PermissionStatus.undetermined:
        return _requestPermissionWidget();
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.denied:
        return _openAppSettingsWidget();
      case PermissionStatus.granted:
        return widget.grantedBuilder?.call(context) ?? emptyBox;
        return emptyBox;
      case PermissionStatus.restricted:
        return emptyBox;
      default:
        return emptyBox;
    }
  }

  Widget _requestPermissionWidget() {
    var cardArgs = PlatformCardArgs(onTap: (context) async {
      final result = await widget.permission.request();
      setState(() {
        this.status = result;
      });
      await widget.onStatusChanged?.call(result);
    });
    return widget.requestArgs?.copyWith(args: cardArgs) ??
        PlatformListTile.cardArgs(cardArgs, title: Text("Request Permission"));
  }

  Widget _openAppSettingsWidget() {
    var cardArgs = PlatformCardArgs(onTap: (context) async {
      final result = await openAppSettings();
    });
    return widget.requestArgs?.copyWith(args: cardArgs) ??
        PlatformListTile(title: Text("Open App Settings"));
  }

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  Future _refreshStatus() async {
    final status = await widget.permission.status;
    setState(() {
      this.status = status;
    });
  }
}
