// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

typedef Lookup = dynamic Function(dynamic val);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  Map<String, Function> get messages => _notInlinedMessages.cast();

  static final _notInlinedMessages = <String, dynamic>{
    "contactEditAddToAddresses": MessageLookupByLibrary.simpleMessage("add address"),
    "contactEditAddToDates": MessageLookupByLibrary.simpleMessage("add date"),
    "contactEditAddToEmails": MessageLookupByLibrary.simpleMessage("add email"),
    "contactEditAddToInterests": MessageLookupByLibrary.simpleMessage("add interest"),
    "contactEditAddToPhones": MessageLookupByLibrary.simpleMessage("add phone"),
    "contactEditAddToSocialProfiles": MessageLookupByLibrary.simpleMessage("add social account"),
    "contactEditAddToUrls": MessageLookupByLibrary.simpleMessage("add website"),
    "contactEditCompanyName": MessageLookupByLibrary.simpleMessage("company"),
    "contactEditInterests": MessageLookupByLibrary.simpleMessage("interests"),
    "contactEditTitle": MessageLookupByLibrary.simpleMessage("title"),
    "validationEmail": MessageLookupByLibrary.simpleMessage("This must be a valid email address"),
    "emailComposeButtonLabel": MessageLookupByLibrary.simpleMessage("Compose"),
    "phoneComposeButtonLabel": MessageLookupByLibrary.simpleMessage("Call"),
    "smsComposeButtonLabel": MessageLookupByLibrary.simpleMessage("Compose"),
  };
}
