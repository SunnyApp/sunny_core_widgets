import 'package:dartxx/dartxx.dart';
import 'package:flutter/cupertino.dart';

class PathRouteSettings extends RouteSettings implements RouteInformation {
  final String? label;
  final String? route;
  final String? resolvedPath;
  final Map<String, Object?>? routeParams;

  /// Creates data used to construct routes.
  PathRouteSettings({
    required dynamic route,
    required this.label,
    this.resolvedPath,
    this.routeParams,
  })  : route = calculateRoute(route),
        super(
            name: resolvedPath ?? calculateRoute(route) ?? label,
            arguments: routeParams);

  @override
  String toString() {
    String str = '${resolvedPath ?? route ?? label}: ';
    if (resolvedPath != null && route != null) {
      str += ', route=$route';
    }
    if (routeParams != null) {
      str += ', params=${routeParams.runtimeType}';
    }

    return str;
  }

  @override
  String? get location => resolvedPath ?? route;

  @override
  PathRouteSettings get state => this;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'label': this.label,
      'route': this.route,
      'resolvedPath': this.resolvedPath,
      'routeParams': this.routeParams,
    } as Map<String, dynamic>;
  }
}

String? _simpleNameOfType(Type type) {
  return "$type".replaceAll(typeParameters, '').uncapitalize();
}

String? calculateRoute(final input) {
  String? str;
  if (input is Type) {
    str = input.simpleName;
  } else {
    str = "$input";
  }
  return !str.startsWith("/") ? "/$str" : str;
}

extension RouteSettingsPathGetter on RouteSettings {
  String? get path {
    final self = this;
    if (self is PathRouteSettings) {
      return self.route;
    } else {
      return self.name;
    }
  }
}

extension RoutePathGetter on Route {
  String? get path {
    return settings.path;
  }
}
