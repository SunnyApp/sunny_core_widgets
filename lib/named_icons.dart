import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sunny_dart/sunny_dart.dart';

import 'container/spaced.dart';

NamedIconContainer _NamedIcons;

NamedIconContainer get NamedIcons {
  return _NamedIcons ?? GlobalIconResolver.icons;
}

set NamedIcons(NamedIconContainer _) {
  _NamedIcons = _;
}

extension NamedIconContainerExt on NamedIconContainer {
  NamedIcon operator [](String name) => iconResolver.getIcon(name);
  NamedIcon getIconOrNull(name) => this[name?.toString()];
}

/// Allows for simple lookup of icons by name.  Implement this container and add
/// fields for a more performant solution
class NamedIconContainer {
  Color defaultColor;
  Color defaultTextColor;
  Color disabledColor;
  double defaultIconSize;

  final Getter<IconResolver> _iconResolver;

  NamedIconContainer(this._iconResolver,
      {this.defaultColor, this.defaultIconSize = 40});

  IconResolver get iconResolver => _iconResolver();

  NamedIcon get add => iconResolver.getIcon("add");

  NamedIcon get alarm => iconResolver.getIcon("alarm");

  NamedIcon get attendee => iconResolver.getIcon("attendee");

  NamedIcon get anniversary => iconResolver.getIcon("anniversary");

  NamedIcon get birthday => iconResolver.getIcon("birthday");

  NamedIcon get builder => iconResolver.getIcon("builder");

  NamedIcon get calendar => iconResolver.getIcon("calendar");

  NamedIcon get camera => iconResolver.getIcon("camera");

  NamedIcon get cancel => iconResolver.getIcon("cancel");

  NamedIcon get celebrate => iconResolver.getIcon("celebrate");

  NamedIcon get check => iconResolver.getIcon("check");

  NamedIcon get chevronLeft => iconResolver.getIcon("chevronLeft");

  NamedIcon get chevronRight => iconResolver.getIcon("chevronRight");

  NamedIcon get child => iconResolver.getIcon("child");

  NamedIcon get christmas => iconResolver.getIcon("christmas");

  NamedIcon get church => iconResolver.getIcon("church");

  NamedIcon get clear => iconResolver.getIcon("clear");

  NamedIcon get clock => iconResolver.getIcon("clock");

  NamedIcon get contact => iconResolver.getIcon("contact");

  NamedIcon get contactAdd => iconResolver.getIcon("contactAdd");

  NamedIcon get contactImport => iconResolver.getIcon("contactImport");

  NamedIcon get contacts => iconResolver.getIcon("contacts");

  NamedIcon get contactsNav => iconResolver.getIcon("contactsNav");

  NamedIcon get date => iconResolver.getIcon("date");

  NamedIcon get delete => iconResolver.getIcon("delete");

  NamedIcon get diamond => iconResolver.getIcon("diamond");

  NamedIcon get drop => iconResolver.getIcon("drop");

  NamedIcon get edit => iconResolver.getIcon("edit");

  NamedIcon get education => iconResolver.getIcon("education");

  NamedIcon get elevatorPitch => iconResolver.getIcon("elevatorPitch");

  NamedIcon get ellipsesHorizontal =>
      iconResolver.getIcon("ellipsesHorizontal");

  NamedIcon get ellipsesVertical => iconResolver.getIcon("ellipsesVertical");

  NamedIcon get email => iconResolver.getIcon("email");

  NamedIcon get employment => iconResolver.getIcon("employment");

  NamedIcon get expand => iconResolver.getIcon("expand");

  NamedIcon get family => iconResolver.getIcon("family");

  NamedIcon get female => iconResolver.getIcon("female");

  NamedIcon get followUp => iconResolver.getIcon("followUp");

  NamedIcon get friend => iconResolver.getIcon("friend");

  NamedIcon get gift => iconResolver.getIcon("gift");

  NamedIcon get getPaid => iconResolver.getIcon("getPaid");

  NamedIcon get globalLocation => iconResolver.getIcon("globalLocation");

  NamedIcon get group => iconResolver.getIcon("group");

  NamedIcon get health => iconResolver.getIcon("health");

  NamedIcon get heart => iconResolver.getIcon("heart");

  NamedIcon get hometown => iconResolver.getIcon("hometown");

  NamedIcon get houses => iconResolver.getIcon("houses");

  NamedIcon get import => iconResolver.getIcon("import");

  NamedIcon get install => iconResolver.getIcon("install");

  NamedIcon get interaction => iconResolver.getIcon("interaction");

  NamedIcon get interests => iconResolver.getIcon("interests");

  NamedIcon get interest => iconResolver.getIcon("interest");

  NamedIcon get invite => iconResolver.getIcon("invite");

  NamedIcon get leader => iconResolver.getIcon("leader");

  NamedIcon get lightningBolt => iconResolver.getIcon("lightningBolt");

  NamedIcon get location => iconResolver.getIcon("location");

  NamedIcon get lock => iconResolver.getIcon("lock");

  NamedIcon get meeting => iconResolver.getIcon("meeting");

  NamedIcon get male => iconResolver.getIcon("male");

  NamedIcon get meditation => iconResolver.getIcon("meditation");

  NamedIcon get memory => iconResolver.getIcon("memory");

  NamedIcon get milestone => iconResolver.getIcon("milestone");

  NamedIcon get member => iconResolver.getIcon("member");

  NamedIcon get money => iconResolver.getIcon("money");

  NamedIcon get note => iconResolver.getIcon("note");

  NamedIcon get otherGender => iconResolver.getIcon("otherGender");

  NamedIcon get pay => iconResolver.getIcon("pay");

  NamedIcon get pet => iconResolver.getIcon("pet");

  NamedIcon get personAdd => iconResolver.getIcon("personAdd");

  NamedIcon get phone => iconResolver.getIcon("phone");

  NamedIcon get project => iconResolver.getIcon("project");

  NamedIcon get reading => iconResolver.getIcon("reading");

  NamedIcon get reachOut => iconResolver.getIcon("reachOut");

  NamedIcon get remind => iconResolver.getIcon("remind");

  NamedIcon get ring => iconResolver.getIcon("ring");

  NamedIcon get save => iconResolver.getIcon("save");

  NamedIcon get search => iconResolver.getIcon("search");

  NamedIcon get settings => iconResolver.getIcon("settings");

  NamedIcon get sms => iconResolver.getIcon("sms");

  NamedIcon get sprout => iconResolver.getIcon("sprout");

  NamedIcon get sports => iconResolver.getIcon("sports");

  NamedIcon get star => iconResolver.getIcon("star");

  NamedIcon get stopwatch => iconResolver.getIcon("stopwatch");

  NamedIcon get team => iconResolver.getIcon("team");

  NamedIcon get text => iconResolver.getIcon("text");

  NamedIcon get task => iconResolver.getIcon("task");

  NamedIcon get tasks => iconResolver.getIcon("tasks");

  NamedIcon get trekking => iconResolver.getIcon("trekking");

  NamedIcon get trust => iconResolver.getIcon("trust");

  NamedIcon get upload => iconResolver.getIcon("upload");

  NamedIcon get university => iconResolver.getIcon("university");

  NamedIcon get welcome => iconResolver.getIcon("welcome");

  NamedIcon get tomorrow => iconResolver.getIcon("tomorrow");

  NamedIcon get nextWeek => iconResolver.getIcon("nextWeek");

  NamedIcon get inTwoWeeks => iconResolver.getIcon("inTwoWeeks");

  NamedIcon get nextMonth => iconResolver.getIcon("nextMonth");

  NamedIcon get inThreeMonths => iconResolver.getIcon("inThreeMonths");

  NamedIcon get inSixMonths => iconResolver.getIcon("inSixMonths");

  NamedIcon get inOneYear => iconResolver.getIcon("inOneYear");

  NamedIcon get addOns => iconResolver.getIcon("addOns");

  NamedIcon get questionMark => iconResolver.getIcon("questionMark");

  NamedIcon get forgotPassword => iconResolver.getIcon("forgotPassword");

  NamedIcon get handshake => iconResolver.getIcon("handshake");

  NamedIcon get login => iconResolver.getIcon("login");

  NamedIcon get logout => iconResolver.getIcon("logout");
}

abstract class IconResolver {
  NamedIcon getIcon(String name, {NamedIcon fallback});

  NamedIcon getIconOrNull(String name);

  NamedIcon getSolidIconOrNull(String key);

  bool hasSolidIcon(String key);

  bool hasIcon(String key);

  bool supportsRegistration();

  void registerIcon(NamedIcon icon, {bool isSolid});
}

class GlobalIconResolver implements IconResolver {
  final _iconMapping = <String, NamedIcon>{};
  @override
  NamedIcon getIcon(String name, {NamedIcon fallback}) {
    return _iconMapping[name] ??
        fallback ??
        NamedIcon(
            name, Icons.check_box_outline_blank, Icons.check_box_outline_blank);
  }

  @override
  NamedIcon getIconOrNull(String name) {
    return _iconMapping[name];
  }

  @override
  NamedIcon getSolidIconOrNull(String key) {
    return _iconMapping["${key}_solid"];
  }

  @override
  bool hasSolidIcon(String key) {
    return _iconMapping["${key}_solid"] != null;
  }

  @override
  bool hasIcon(String key) {
    return _iconMapping[key] != null;
  }

  static IconResolver instance = GlobalIconResolver._();
  static NamedIconContainer icons = NamedIconContainer(() => instance);

  GlobalIconResolver._();

  @override
  void registerIcon(NamedIcon icon, {bool isSolid}) {
    if (icon != null) {
      _iconMapping[icon.name] = icon;
      if (isSolid != true) {
        registerIcon(
            icon.copyWith(
                name: "${icon.name}_solid",
                isSolid: true,
                iconData: icon.solidData,
                solidData: icon.solidData,
                color: Colors.white),
            isSolid: true);
      }
    }
  }

  @override
  bool supportsRegistration() => true;
}

class NamedIcon extends IconData {
  final String name;
  final IconData iconData;
  final IconData solidData;
  final Icon icon;
  final Icon solidIcon;
  final double size;
  final bool _isSolid;
  final bool circular;

  final Color _color;
  final Color _foregroundColor;

  NamedIcon(String name, IconData iosIcon, IconData androidIcon,
      [IconData solidIosIcon, IconData solidAndroidIcon])
      : this._(
          name,
          iconData: isIOS ? iosIcon : androidIcon,
          solidData:
              isIOS ? iosIcon ?? iosIcon : solidAndroidIcon ?? androidIcon,
// We're not using solid icons
//          solidData: Platform.isIOS ? solidIosIcon ?? iosIcon : solidAndroidIcon ?? androidIcon,
          circular: false,
          isSolid: false,
          color: NamedIcons.defaultColor,
          foregroundColor: Colors.white,
          size: NamedIcons.defaultIconSize,
        );

  NamedIcon._(
    this.name, {
    @required this.iconData,
    @required this.solidData,
    @required this.circular,
    @required Color color,
    @required bool isSolid,
    @required Color foregroundColor,
    @required this.size,
  })  : assert(iconData != null),
        assert(solidData != null),
        _isSolid = isSolid ?? false,
        _color = color,
        _foregroundColor = foregroundColor,
        icon =
            Icon(iconData, size: size, color: color ?? NamedIcons.defaultColor),
        solidIcon = Icon(solidData,
            size: size, color: color ?? NamedIcons.defaultColor),
        super(iconData.codePoint,
            fontFamily: iconData.fontFamily,
            fontPackage: iconData.fontPackage,
            matchTextDirection: iconData.matchTextDirection);

  // Widget tappable(VoidCallback onTap) {
  //   return this.widget.tappable(onTap);
  // }

  /// Builds as a widget
  Widget build({
    bool circular,
    bool solid,
    Color color,
    Color foregroundColor,
    double size,
  }) {
    return copyWith(
      circular: circular,
      isSolid: solid,
      color: color,
      foregroundColor: foregroundColor,
      size: size,
    ).widget;
  }

  NamedIcon copyWith({
    String name,
    IconData iconData,
    IconData solidData,
    bool circular,
    bool isSolid,
    Color color,
    Color foregroundColor,
    double size,
  }) {
    return NamedIcon._(name ?? this.name,
        iconData: iconData ?? this.iconData,
        solidData: solidData ?? this.solidData,
        circular: circular ?? this.circular,
        isSolid: isSolid ?? this._isSolid,
        color: color ?? this._color,
        foregroundColor: foregroundColor ?? this._foregroundColor,
        size: size ?? this.size);
  }

  bool get iconExists => icon != null;

  bool get solidIconExists => solidData != null;

  @override
  bool operator ==(Object other) => other is NamedIcon && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;

  NamedIcon grayCircular() {
    return copyWith(
      circular: true,
      color: NamedIcons.defaultColor,
      foregroundColor: NamedIcons.defaultTextColor,
    );
  }

  NamedIcon solid([Color color]) {
    return copyWith(isSolid: true, color: color);
  }

  NamedIcon colored(Color color) {
    return copyWith(color: color);
  }

  NamedIcon white() {
    return copyWith(color: Colors.white);
  }

  NamedIcon sized(double size) {
    return copyWith(size: size);
  }
}

NamedIcon icon(String name, IconData ios, IconData iosSolid) {
  final ico = NamedIcon(name, ios, ios, iosSolid, iosSolid);
  GlobalIconResolver.instance.registerIcon(ico, isSolid: false);
  return ico;
}

extension NamedIconTypedExtensions on NamedIcon {
  NamedIcon get sunnyActionButtonIcon {
    return this.sized(60).solid(Colors.white);
  }

  NamedIcon get inputIcon {
    return this.sized(25);
  }

  NamedIcon tileIcon({bool dense = false}) {
    return this.sized(tileIconSize(dense: dense));
  }

  Widget get widget {
    if (this == null) return emptyBox;
    if (circular) {
      return ClipOval(
        child: Container(
          // We have to include the padding in the size, otherwise, the offsets are wrong
          height: size,
          width: size,
//          constraints: BoxConstraints(maxWidth: size, maxHeight: size),
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.all(size / 8),
          color: _color ?? NamedIcons.defaultColor,
          child: Center(
            child: Icon(
              _isSolid ? solidData : iconData,
              color: _foregroundColor ?? Colors.white,
              size: size - (size / 4) + 1,
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: size,
        width: size,
//        alignment: Alignment.center,
//        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.transparent, border: Border.all(color: color, width: 1)),
        child: Icon(
          _isSolid ? solidData : iconData,
          size: size * .55,
          color: _color,
        ),
      );
    }
  }
}

const kTileIconSize = 25.0;
const kTileIconDenseSize = 20.0;

double tileIconSize({bool dense = false}) {
  return dense == true ? kTileIconDenseSize : kTileIconSize;
}
