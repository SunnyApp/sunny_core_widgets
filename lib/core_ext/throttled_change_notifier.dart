import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:sunny_dart/streams/throttle_debounce.dart';

final _log = Logger("throttledNotifier");
mixin ThrottledChangeNotifier on ChangeNotifier {
  bool _isActive = true;
  Limiter _limiter;

  Limiter get limiter => _limiter ??=
      Debouncer(delay: const Duration(milliseconds: 300), atBegin: true);

  bool get isActive => _isActive;

  @mustCallSuper
  @override
  void dispose() {
    if (_isActive = true) {
      _isActive = false;
      super.dispose();
    }
  }

  R ifActive<R>(R exec()) {
    if (_isActive) {
      return exec();
    } else {
      _log.warning(
          "Skipping exec for ${this.runtimeType} because we were shutting down");
      return null;
    }
  }

  void notifyWithLimit() {
    notifyIfActive();
  }

  void notifyIfActive() {
    if (this._isActive) {
      notifyListeners();
    } else {
      assert(false, "NOT ACTIVE");
      _log.warning("NOT ACTIVE!!");
    }
  }
}
