import 'package:flutter/cupertino.dart';
import 'package:sunny_dart/sunny_dart.dart';

export 'package:flutter_screen_scaling/size_extension.dart';

SunnySpacing get sunnySpacing {
  return SunnySpacing();
}

/// cached stack widgets

SizedBox _v1;
SizedBox _v2;
SizedBox _v3;
SizedBox _v4;

/// List of font styles based on reliveit naming conventions.  This can be easily applied to a material
/// or cupertino theme.
class SunnySpacing {
  final double scaleFactor;
  final double _spaceUnit;
  final double _pageSideMargin;
  final double _pageTopMargin;
  final double _cardSpacing;
  final double _cardImageHeight;
  final double _cardImageExpandedHeight;

  final double spaceUnit;
  final double pageSideMargin;
  final double pageTopMargin;
  final double cardSpacing;

  final double cardImageHeight;
  final double cardImageExpandedHeight;

  static const BorderRadius twelvePxRadiusAll =
      BorderRadius.all(twelvePxRadius);

  static const BorderRadius sixteenPxRadiusAll =
      BorderRadius.all(sixteenPxRadius);

  static const twelvePxRadius = Radius.circular(12);
  static const sixteenPxRadius = Radius.circular(16);

  static const twelvePxRadiusTop = BorderRadius.only(
    topLeft: twelvePxRadius,
    topRight: twelvePxRadius,
  );

  static const twelvePxRadiusBottom = BorderRadius.only(
    bottomLeft: twelvePxRadius,
    bottomRight: twelvePxRadius,
  );

  static const sixteenPxRadiusLeft = BorderRadius.only(
    bottomLeft: sixteenPxRadius,
    topLeft: sixteenPxRadius,
  );

  static const sixteenPxRadiusRight = BorderRadius.only(
    bottomRight: sixteenPxRadius,
    topRight: sixteenPxRadius,
  );

  EdgeInsets get cardMargin =>
      EdgeInsets.all(cardSpacing);

  EdgeInsets get hPaddingPage =>
      EdgeInsets.symmetric(horizontal: pageSideMargin);
  
  final double _appBarHeight;
  final double appBarHeight;


  SizedBox get cardSpacingBox => SizedBox(height: cardSpacing);

  double operator *(num _) {
    return spaceUnit * _;
  }

  double operator /(num _) {
    return spaceUnit / _;
  }

  SizedBox get vertSpace => vspace(1);
  SizedBox vspace([int x = 1]) {
    switch (x) {
      case 0:
        return const SizedBox(height: 0);
      case 1:
        return _v1 ??= SizedBox(height: spaceUnit);
      case 2:
        return _v2 ??= SizedBox(height: spaceUnit * 2);
      case 3:
        return _v3 ??= SizedBox(height: spaceUnit * 3);
      case 4:
        return _v4 ??= SizedBox(height: spaceUnit * 4);
      default:
        return SizedBox(height: spaceUnit * x);
    }
  }

  SizedBox get horizSpace => SizedBox(width: spaceUnit);

  SizedBox get space => SizedBox(height: spaceUnit, width: spaceUnit);

  static void setScaleFactor(double scale) {
    assert(scale != null);
    _trippiSpacing ??= SunnySpacing();
    _trippiSpacing = _trippiSpacing.copyWith(scaleFactor: scale);
  }

  factory SunnySpacing() => _trippiSpacing ??= defaults;

  static const defaults = SunnySpacing.of(
    scaleFactor: 1.0,
    spaceUnit: 8,
    cardImageHeight: 155,
    cardImageExpandedHeight: 328,
    appBarHeight: 55,
  );

  const SunnySpacing.of({
    @required this.scaleFactor,
    @required double spaceUnit,
    @required double appBarHeight,
    @required double cardImageHeight,
    @required double cardImageExpandedHeight,
  })  : assert(scaleFactor != null),
        assert(spaceUnit != null),
        assert(cardImageHeight != null),
        _pageSideMargin = spaceUnit * 2,
        _pageTopMargin = spaceUnit * 3,
        _cardSpacing = spaceUnit * 3,
        _spaceUnit = spaceUnit,
        _appBarHeight = appBarHeight,
        pageSideMargin = spaceUnit * 2 * scaleFactor,
        pageTopMargin = spaceUnit * 3 * scaleFactor,
        cardSpacing = spaceUnit * 3 * scaleFactor,
        spaceUnit = spaceUnit * scaleFactor,
        appBarHeight = appBarHeight * scaleFactor,
        _cardImageHeight = cardImageHeight,
        _cardImageExpandedHeight = cardImageExpandedHeight,
        cardImageHeight = cardImageHeight * scaleFactor,
        cardImageExpandedHeight = cardImageExpandedHeight * scaleFactor;

  SunnySpacing copyWith({
    double scaleFactor,
    double spaceUnit,
    double cardImageHeight,
    double cardImageExpandedHeight,
    double appBarHeight,
  }) {
    return new SunnySpacing.of(
      scaleFactor: scaleFactor ?? this.scaleFactor,
      cardImageHeight: cardImageHeight ?? this._cardImageHeight,
      cardImageExpandedHeight:
          cardImageExpandedHeight ?? this._cardImageExpandedHeight,
      spaceUnit: spaceUnit ?? this._spaceUnit,
      appBarHeight: appBarHeight ?? this._appBarHeight,
    );
  }
}

SunnySpacing _trippiSpacing;

extension SizedBoxExt on SizedBox {
  SizedBox operator *(num value) {
    return SizedBox(
        key: this.key,
        width: this.width.times(value),
        height: this.height.times(value));
  }
}

extension WidgetSpacingExt on Widget {
  Widget sliverFill() {
    return SliverFillRemaining(
      child: this,
    );
  }

  Widget sliverBox() {
    return SliverToBoxAdapter(child: this);
  }

  Widget headerPad() {
    return Padding(
      padding: EdgeInsets.only(
          left: SunnySpacing().spaceUnit * 2,
          top: SunnySpacing().spaceUnit,
          bottom: SunnySpacing().spaceUnit * 2),
      child: this,
    );
  }

  Widget sectionPad() {
    return Padding(
      padding: EdgeInsets.only(
          left: SunnySpacing().spaceUnit * 2,
          top: SunnySpacing().spaceUnit * 3,
          bottom: SunnySpacing().spaceUnit * 2),
      child: this,
    );
  }

  Widget hpad([int units = 2]) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SunnySpacing().spaceUnit * units),
      child: this,
    );
  }

  Widget lpad([int units = 2]) {
    return Padding(
      padding: EdgeInsets.only(left: SunnySpacing().spaceUnit * units),
      child: this,
    );
  }

  Widget rpad([int units = 2]) {
    return Padding(
      padding: EdgeInsets.only(right: SunnySpacing().spaceUnit * units),
      child: this,
    );
  }

  Widget listItemPad() {
    final x2 = SunnySpacing().spaceUnit * 2;
    return Padding(
      padding: EdgeInsets.only(left: x2, right: x2, bottom: x2),
      child: this,
    );
  }

  Widget color(Color color) {
    return Container(color: color, child: this);
  }

  Widget listItemCard() {
    final x2 = SunnySpacing().spaceUnit * 2;
    return Padding(
      padding: EdgeInsets.only(
          left: x2, right: x2, bottom: SunnySpacing().spaceUnit * 3),
      child: this,
    );
  }

  Widget listItemTallPad({Key key}) {
    final x2 = SunnySpacing().spaceUnit * 2;
    return Padding(
      key: key,
      padding: EdgeInsets.only(
          left: x2, right: x2, bottom: SunnySpacing().spaceUnit * 5),
      child: this,
    );
  }

  Widget vpad([int units = 2]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SunnySpacing().spaceUnit * units),
      child: this,
    );
  }

  Widget bpad([int units = 2]) {
    return Padding(
      padding: EdgeInsets.only(bottom: SunnySpacing().spaceUnit * units),
      child: this,
    );
  }

  Widget tpad([int units = 2]) {
    return Padding(
      padding: EdgeInsets.only(top: SunnySpacing().spaceUnit * units),
      child: this,
    );
  }

  Widget pad({int h = 2, int v = 1}) {
    final u = SunnySpacing().spaceUnit;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: u * h, vertical: u * v),
      child: this,
    );
  }
}

extension SunnySpacingToEdgeInsets on SunnySpacing {
  EdgeInsets get all => EdgeInsets.all(spaceUnit);
  EdgeInsets get half => EdgeInsets.all(spaceUnit * 0.5);
  EdgeInsets get shim => EdgeInsets.all(spaceUnit * 0.5);
  EdgeInsets get vert => EdgeInsets.symmetric(vertical: spaceUnit);
  EdgeInsets get horiz => EdgeInsets.symmetric(horizontal: spaceUnit);
}
