import 'package:sunny_fluro/sunny_fluro.dart';
import 'package:sunny_dart/helpers.dart';

FRouter _router;

class SunnyRouting {
  static FRouter get router =>
      _router ??
      illegalState(
          "No router set.  You must set it using SunnyRouting.router = myrouter");

  static set router(FRouter router) {
    assert(router != null);
    _router = router;
  }
}
