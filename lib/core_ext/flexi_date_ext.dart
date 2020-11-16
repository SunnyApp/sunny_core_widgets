import 'package:sunny_sdk_core/model/flexi_date.dart';
import 'package:timeago/timeago.dart' as timeago;

extension FlexiDateFormatters on FlexiDate {
//  String historyString({String label = "ago", bool withYear = false, String dateLabel = ""}) {
//    final flexiDate = this;
//    final parts = <String>[];
//    if (flexiDate == null) return null;
//
//    if (flexiDate.hasYear) {
//      final dt = flexiDate.toDateTime();
//      final yearsAgo = dt.yearsAgo;
//      final monthsAgo = dt.monthsAgo;
//      if (yearsAgo > 0) {
//        parts.add("$yearsAgo years $label");
//      } else if (monthsAgo > 0) {
//        parts.add("$yearsAgo months $label");
//      }
//    }
//    if (flexiDate.hasMonth && flexiDate.hasDay) {
//      parts.add((dateLabel.isNotEmpty ? "$dateLabel " : "") + sunnyIntl.flexiDate(flexiDate, withYear: withYear));
//    }
//
//    return parts.join(" - ");
//  }

  String fullFormat({
    String futureLabel = "in",
    String historyLabel = "ago",
    bool withYear = false,
    String dateLabel = "",
  }) {
    final flexiDate = this;
    final parts = <String>[];
    if (flexiDate == null) return null;

    if (flexiDate.hasYear) {
      final dt = flexiDate.toDateTime();
      String formatted = timeago.format(dt, allowFromNow: true);
      if (historyLabel != "ago")
        formatted = formatted.replaceAll("ago", historyLabel);
      parts.add(formatted);
    }
    if (flexiDate.hasMonth && flexiDate.hasDay) {
      parts.add((dateLabel.isNotEmpty ? "$dateLabel " : "") +
          formatFlexiDate(flexiDate, withYear: withYear));
    }

    return parts.join(" - ");
  }
}
