import 'package:intl/intl.dart';

class IntlCore {
  IntlCore._();

  static String message(final String msg) {
    final resolved = Intl.message("", name: msg);
    return resolved;
  }
}
