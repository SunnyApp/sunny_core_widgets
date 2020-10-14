part of 'sunny_intl.dart';

/// Localization codes for account login
mixin ValidationIntl {
  String validationEmail = Intl.message("This must be a valid email address.", name: "validationEmail");
//  String required = Intl.message("This field is required.", name: "required");
  String minLength(int minLength) {
    String interpolated = characters(minLength);
    return Intl.message("This value must be at least $minLength $interpolated", name: "minLength");
  }

  String characters(int count) =>
      Intl.plural(count, zero: "characters", one: "character", other: "characters", name: "validationCharacters");
}
