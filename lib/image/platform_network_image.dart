import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

ImageProvider PlatformNetworkImageProvider(dynamic url) {
  return (kIsWeb ? NetworkImage("$url") : CachedNetworkImageProvider("$url"))
      as ImageProvider<dynamic>;
}

class PlatformNetworkImage extends PlatformWidgetBase {
  final String imageUrl;
  final double height;
  final double width;
  final Widget Function(BuildContext context, String url) placeholder;
  final Map<String, String> httpHeaders;
  final Widget Function(BuildContext context, String url, Object err)
      errorWidget;
  final Alignment alignment;
  final bool useOldImageOnUrlChange;
  final BoxFit fit;
  PlatformNetworkImage(
    dynamic imageUrl, {
    Key key,
    this.height,
    this.width,
    this.httpHeaders,
    this.placeholder,
    this.errorWidget,
    this.alignment = Alignment.center,
    this.useOldImageOnUrlChange,
    this.fit,
  })  : assert(imageUrl != null),
        imageUrl = "$imageUrl",
        super(key: key);

  @override
  Widget createMaterialWidget(BuildContext context) => createNative();

  @override
  Widget createCupertinoWidget(BuildContext context) => createNative();

  Widget createNative() {
    return imageUrl == null
        ? Container(
            height: height,
            width: width,
            color: Colors.grey.withOpacity(0.5),
          )
        : kIsWeb
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                height: height,
                width: width,
                fit: fit,
                alignment: alignment ?? Alignment.center,
                placeholder: placeholder,
                httpHeaders: httpHeaders,
                errorWidget: errorWidget,
                useOldImageOnUrlChange: useOldImageOnUrlChange,
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                height: height,
                width: width,
                fit: fit,
                alignment: alignment ?? Alignment.center,
                placeholder: placeholder,
                httpHeaders: httpHeaders,
                errorWidget: errorWidget,
                useOldImageOnUrlChange: useOldImageOnUrlChange,
              );
  }
}
