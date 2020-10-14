import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sunny_core_widgets/container/spaced.dart';
import 'package:sunny_core_widgets/platform_card.dart';
import 'package:sunny_core_widgets/platform_list_tile.dart';

enum DeniedBehavior { openSettings, hideWidget }

class PermissionSuggestCard extends StatefulWidget {
  final Permission permission;
  final DeniedBehavior deniedBehavior;

  const PermissionSuggestCard(
      {Key key,
      @required this.permission,
      this.deniedBehavior = DeniedBehavior.openSettings})
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
        return emptyBox;
      case PermissionStatus.restricted:
        return emptyBox;
      default:
        return emptyBox;
    }
  }

  Widget _requestPermissionWidget() {
    return PlatformListTile(PlatformCardArgs(),
        title: Text("Request Permission"));
  }

  Widget _openAppSettingsWidget() {
    return PlatformListTile(PlatformCardArgs(),
        title: Text("Open App Settings"));
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
