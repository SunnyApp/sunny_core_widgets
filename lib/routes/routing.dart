import 'package:sunny_fluro/sunny_fluro.dart';

FRouter? _router;

class SunnyRouting {
  static FRouter get router =>
      _router ??
      (throw Exception(
          "No router set.  You must set it using SunnyRouting.router = myrouter"));

  static set router(FRouter router) {
    _router = router;
  }
}
