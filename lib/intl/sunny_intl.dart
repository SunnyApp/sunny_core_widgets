import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sunny_core_widgets/intl/intl_core.dart';
import 'package:sunny_core_widgets/provided.dart';
import 'package:sunny_sdk_core/model/flexi_date.dart';

import 'messages_all.dart';

part 'intl_validation.p.dart';

class SunnyIntl with ValidationIntl {
  static SunnyIntl load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    initializeMessages(localeName);
    Intl.defaultLocale = localeName;
    return SunnyIntl();
  }

  static SunnyIntl of(BuildContext context) {
    return consume<SunnyIntl>(context);
//    return Localizations.of<SunnyIntl>(context, SunnyIntl);
  }

  final required = Intl.message("This value is required",
      name: "required", args: [], desc: "Required error");
  final help = Intl.message("Help", name: "help");
  final cancelLabel = Intl.message("Cancel", name: "cancelLabel");
  final saveLabel = Intl.message("Save", name: "saveLabel");
  final editLabel = Intl.message("Edit", name: "editLabel");
  final deleteLabel = Intl.message("Delete", name: "deleteLabel");
  final doneLabel = Intl.message("Done", name: "doneLabel");
  final okayLabel = Intl.message("OK", name: "okayLabel");
  final loadingLabel = Intl.message("Loading", name: "loadingLabel");
  final searchLabel = Intl.message("Search", name: "searchLabel");
  final goal = Intl.message("Goal", name: "goal");
  final comingSoon = Intl.message("Coming Soon", name: "comingSoon");
  final addressSearch = Intl.message("Type an address", name: "addressSearch");
  final clickToSet = Intl.message("Click To Set", name: "clickToSet");

  final reachOutNoTemplateSets = Intl.message(
      "There aren't any templates that can be sent to this contact. Try adding a "
      "phone number or email address to the contact record",
      name: "reachOutNoTemplateSets");

  final defaultEmptyStateMessage = Intl.message(
      "There doesn't seem to be anything here.",
      name: "defaultEmptyStateMessage");

  String deleteConfirmTitle(String item) => Intl.message(
        "Are you sure you want to delete ${item ?? 'this item'} from Trippi?",
        name: "deleteConfirmTitle",
      );

  final permissionRequestPhotos = Intl.message(
      "Can Trippi use your photos to find profile pictures?",
      name: "permissionRequestPhotos");

  String message(final String msg) => IntlCore.message(msg);

  final done = Intl.message("Done", name: "done");
  final add = Intl.message("Add", name: "add");
  final newLabel = Intl.message("New", name: "new");
  final yes = Intl.message("Yes", name: "yes");
  final no = Intl.message("No", name: "no");
  final skipLabel = Intl.message("Dismiss", name: "skipLabel");
  final areYouSure = Intl.message("Are you sure?", name: "areYouSure");

  String date(DateTime date) => DateFormat.yMMMd().format(date);

  String reachOutTo(String label) {
    return Intl.message("Reach out to ${label ?? "Unknown"}",
        name: "reachOutTo");
  }

  String month(int month) {
    return DateFormat.MMMM().format(DateTime(2000, month, 1));
  }

  String flexiDate(
    input, {
    bool withYear = true,
    bool withMonth = true,
    bool withDay = true,
  }) {
    final flexi =
        input is FlexiDate ? input : FlexiDate.tryFrom(input?.toString());
    if (flexi == null) {
      return null;
    }
    String result = "";
    final date = flexi.toDateTime();
    if (flexi.hasMonth && withMonth != false) {
      result += "${DateFormat.MMM().format(date)} ";
      if (flexi.hasDay && withDay != false) {
        result += "${DateFormat.d().format(date)}";
      }
    }
    result = result.trim();
    if (flexi.hasYear && withYear != false) {
      if (flexi.hasMonth && flexi.hasDay) result += ",";
      if (result.isNotEmpty) result += " ";
      result += "${DateFormat.y().format(date)}";
    }
    return result;
  }

// Registration page
}

class SunnyIntlDelegate extends LocalizationsDelegate<SunnyIntl> {
  const SunnyIntlDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'pt'].contains(locale.languageCode);
  }

  @override
  Future<SunnyIntl> load(Locale locale) {
    return Future.value(SunnyIntl.load(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<SunnyIntl> old) {
    return false;
  }
}
