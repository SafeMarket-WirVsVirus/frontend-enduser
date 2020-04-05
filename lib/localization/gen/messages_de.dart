// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static m0(locationName) => "Willst du deine Reservierung für ${locationName} wirklich löschen?";

  static m1(locationName, formattedTime) => "Deine Reservierung für ${locationName} startet um ${formattedTime}.";

  static m2(formattedTime) => "Deine Reservierung startet um ${formattedTime}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "addReminderButtonTitle" : MessageLookupByLibrary.simpleMessage("Erinnern"),
    "commonCancel" : MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "commonOk" : MessageLookupByLibrary.simpleMessage("OK"),
    "createReservationFailedDialogDescription" : MessageLookupByLibrary.simpleMessage("Deine Reservierung konnte leider nicht erstellt werden."),
    "createReservationFailedDialogTitle" : MessageLookupByLibrary.simpleMessage("Achtung"),
    "createReservationSuccessSnackbar" : MessageLookupByLibrary.simpleMessage("Slot reserviert"),
    "deleteReservationDialogTitle" : m0,
    "deleteReservationDialogTitleWithoutLocation" : MessageLookupByLibrary.simpleMessage("Willst du deine Reservierung wirklich löschen?"),
    "locationFilterBakeriesLabel" : MessageLookupByLibrary.simpleMessage("Bäckereien"),
    "locationFilterPharmaciesLabel" : MessageLookupByLibrary.simpleMessage("Apotheken"),
    "locationFilterSupermarketsLabel" : MessageLookupByLibrary.simpleMessage("Supermärkte"),
    "locationSlotDateNotAvailable" : MessageLookupByLibrary.simpleMessage("Daten konnten nicht geladen werden"),
    "locationUtilizationSliderTip1" : MessageLookupByLibrary.simpleMessage("Nur die Läden mit sehr geringer Auslastung werden angezeigt (optimal für besonders gefährdete Personen)"),
    "locationUtilizationSliderTip2" : MessageLookupByLibrary.simpleMessage("Die Läden mit sehr hoher Auslastung werden nicht angezeigt"),
    "locationUtilizationSliderTip3" : MessageLookupByLibrary.simpleMessage("Alle Läden werden angezeigt, auch wenn gerade viel los ist"),
    "locationUtilizationSliderTitle" : MessageLookupByLibrary.simpleMessage("Auslastungsniveau"),
    "mapBottomBarTitle" : MessageLookupByLibrary.simpleMessage("Suche"),
    "reservationReminderNotificationDescription" : m1,
    "reservationReminderNotificationDescriptionWithoutLocation" : m2,
    "reservationReminderNotificationTitle" : MessageLookupByLibrary.simpleMessage("Bevorstehende Reservierung"),
    "reservationsBottomBarTitle" : MessageLookupByLibrary.simpleMessage("Meine Slots"),
    "reservationsListEmpty" : MessageLookupByLibrary.simpleMessage("Du hast aktuell keine offenen Reservierungen."),
    "reservationsNavBarTitle" : MessageLookupByLibrary.simpleMessage("Meine\nReservierungen"),
    "reservationsNotAvailableOffline" : MessageLookupByLibrary.simpleMessage("Tut uns leid, im Moment unterstützen wir den Offline-Modus noch nicht."),
    "reserveSlotButtonTitle" : MessageLookupByLibrary.simpleMessage("Slot reservieren")
  };
}
