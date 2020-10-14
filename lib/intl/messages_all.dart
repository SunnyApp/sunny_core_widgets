// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that looks up messages for specific locales by
// delegating to the appropriate library.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart'; // ignore: implementation_imports

import 'messages_en.dart' as messages_en;
import 'messages_es.dart' as messages_es;

final Map<String, MessageLookupByLibrary> _messageByLocale = {
// ignore: unnecessary_new
  'es': messages_es.messages,
  'en': messages_en.messages,
};

MessageLookupByLibrary _findExact(String localeName) {
  return _messageByLocale[localeName] ?? messages_en.messages;
}

/// User programs should call this before using [localeName] for messages.
bool initializeMessages(String localeName) {
  var availableLocale = Intl.verifiedLocale(
    localeName,
    (locale) => _messageByLocale.containsKey(locale),
    onFailure: (_) => _,
  );
  if (availableLocale == null) {
    return false;
  }

  initializeInternalMessageLookup(() => CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  return true;
}

MessageLookupByLibrary _findGeneratedMessagesFor(String locale) {
  var actualLocale = Intl.verifiedLocale(
    locale,
    (locale) => _messageByLocale.containsKey(locale),
    onFailure: (_) => _,
  );
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
