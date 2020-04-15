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

  static m0(locationName) => "Willst du dein Ticket für ${locationName} wirklich löschen?";

  static m1(locationName, formattedTime) => "Dein Ticket für ${locationName} startet um ${formattedTime}.";

  static m2(formattedTime) => "Dein Ticket startet um ${formattedTime}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aboutTheAppDescription1" : MessageLookupByLibrary.simpleMessage("Unser Projekt ist im Rahmen des "),
    "aboutTheAppDescription2" : MessageLookupByLibrary.simpleMessage("#WirVsVirus hackathon"),
    "aboutTheAppDescription3" : MessageLookupByLibrary.simpleMessage(" entstanden.\n\nSafeMarket bietet die Möglichkeit, an Orten mit begrenzten Kundenkapazitäten (z.B. Supermärkte) sich ein Ticket zu buchen, um entspannt und ohne in der Schlange stehen zu müssen einkaufen gehen zu können."),
    "aboutTheAppTitle" : MessageLookupByLibrary.simpleMessage("Über die App"),
    "addReminderButtonTitle" : MessageLookupByLibrary.simpleMessage("Erinnern"),
    "appName" : MessageLookupByLibrary.simpleMessage("SafeMarket"),
    "commonCancel" : MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "commonOk" : MessageLookupByLibrary.simpleMessage("OK"),
    "createReservationFailedDialogDescription" : MessageLookupByLibrary.simpleMessage("Dein Ticket konnte leider nicht erstellt werden."),
    "createReservationFailedDialogTitle" : MessageLookupByLibrary.simpleMessage("Achtung"),
    "createReservationSuccessSnackbar" : MessageLookupByLibrary.simpleMessage("Ticket gebucht"),
    "creditsDesignSectionBody" : MessageLookupByLibrary.simpleMessage("Logo von Chris Z.\nIcons von Vitaly Gorbachev von Flaticon"),
    "creditsDesignSectionTitle" : MessageLookupByLibrary.simpleMessage("Design"),
    "creditsTitle" : MessageLookupByLibrary.simpleMessage("Credits"),
    "deleteReservationDialogTitle" : m0,
    "deleteReservationDialogTitleWithoutLocation" : MessageLookupByLibrary.simpleMessage("Willst du dein Ticket wirklich löschen?"),
    "locationFilterBakeriesLabel" : MessageLookupByLibrary.simpleMessage("Bäckereien"),
    "locationFilterPharmaciesLabel" : MessageLookupByLibrary.simpleMessage("Apotheken"),
    "locationFilterSupermarketsLabel" : MessageLookupByLibrary.simpleMessage("Supermärkte"),
    "locationSlotDateNotAvailable" : MessageLookupByLibrary.simpleMessage("Daten konnten nicht geladen werden"),
    "locationUtilizationSliderTip1" : MessageLookupByLibrary.simpleMessage("Nur die Läden mit sehr geringer Auslastung werden angezeigt (optimal für besonders gefährdete Personen)"),
    "locationUtilizationSliderTip2" : MessageLookupByLibrary.simpleMessage("Die Läden mit sehr hoher Auslastung werden nicht angezeigt"),
    "locationUtilizationSliderTip3" : MessageLookupByLibrary.simpleMessage("Alle Läden werden angezeigt, auch wenn gerade viel los ist"),
    "locationUtilizationSliderTitle" : MessageLookupByLibrary.simpleMessage("Auslastungsniveau"),
    "mapBottomBarTitle" : MessageLookupByLibrary.simpleMessage("Suche"),
    "openSourceLicensesTitle" : MessageLookupByLibrary.simpleMessage("Open Source Lizenzen"),
    "reservationReminderNotificationChannelDescription" : MessageLookupByLibrary.simpleMessage("Benachrichtigungen für deine bevorstehenden Tickets."),
    "reservationReminderNotificationChannelName" : MessageLookupByLibrary.simpleMessage("Bevorstehende Tickets"),
    "reservationReminderNotificationDescription" : m1,
    "reservationReminderNotificationDescriptionWithoutLocation" : m2,
    "reservationReminderNotificationTitle" : MessageLookupByLibrary.simpleMessage("Anstehendes Ticket"),
    "reservationsBottomBarTitle" : MessageLookupByLibrary.simpleMessage("Meine Tickets"),
    "reservationsListEmpty" : MessageLookupByLibrary.simpleMessage("Keine Tickets gebucht."),
    "reservationsNavBarTitle" : MessageLookupByLibrary.simpleMessage("Meine\nTickets"),
    "reservationsNotAvailableOffline" : MessageLookupByLibrary.simpleMessage("Tut uns leid, im Moment unterstützen wir den Offline-Modus noch nicht."),
    "reserveSlotButtonTitle" : MessageLookupByLibrary.simpleMessage("Ticket buchen"),
    "tutorialBookTicketDescription" : MessageLookupByLibrary.simpleMessage("1. Wähle Sie Ihren präferierten Ort.\n2. Wählen Sie die gewünschte Zeit.\n3. Bestätigen Sie Ihr Ticket."),
    "tutorialBookTicketTitle" : MessageLookupByLibrary.simpleMessage("Ticket buchen"),
    "tutorialCheckInDescription" : MessageLookupByLibrary.simpleMessage("Um nachzuweisen, dass Sie ein gültiges Ticket besitzen:\n• Präsentieren Sie den QR-Code Ihres Tickets in der App ODER\n• Nennen Sie die Geheimwörter, die unter Ihrem Ticket angezeigt werden."),
    "tutorialCheckInTitle" : MessageLookupByLibrary.simpleMessage("Check-In vor Ort"),
    "tutorialDoneButton" : MessageLookupByLibrary.simpleMessage("Fertig"),
    "tutorialIntroductionDescription" : MessageLookupByLibrary.simpleMessage("Mit SafeMarket können Sie Tickets für Ihren gewünschten Ort buchen und nachweisen, dass Sie ein gültiges Ticket besitzen, wenn Sie den Ort betreten."),
    "tutorialIntroductionTitle" : MessageLookupByLibrary.simpleMessage("Überblick"),
    "tutorialLastSlideDescription" : MessageLookupByLibrary.simpleMessage("Wir freuen uns auf Ihr Feedback. Bitte besuchen Sie unsere Webseite um uns zu kontaktieren."),
    "tutorialLastSlideTitle" : MessageLookupByLibrary.simpleMessage("Fertig"),
    "tutorialLocationPermissionDeclinedDialogDescription" : MessageLookupByLibrary.simpleMessage("Bitte erlauben Sie den Standort-Zugriff in den App-Einstellungen."),
    "tutorialLocationPermissionDeclinedDialogTitle" : MessageLookupByLibrary.simpleMessage("Standort-Zugriff"),
    "tutorialLocationPermissionDeclinedGoToSettingsButton" : MessageLookupByLibrary.simpleMessage("App-Einstellungen öffnen"),
    "tutorialLocationPermissionDescription" : MessageLookupByLibrary.simpleMessage("Ihr Standort wird verwendet um nach Orten in Ihrer Nähe zu suchen. Sie können die App auch ohne diese Erlaubnis nutzen."),
    "tutorialLocationPermissionStatusGranted" : MessageLookupByLibrary.simpleMessage("Zugriff erlaubt"),
    "tutorialLocationPermissionStatusNotGranted" : MessageLookupByLibrary.simpleMessage("Standort-Zugriff erteilen"),
    "tutorialLocationPermissionStatusTesting" : MessageLookupByLibrary.simpleMessage("Status wird überprüft"),
    "tutorialLocationPermissionTitle" : MessageLookupByLibrary.simpleMessage("Standort-Zugriff"),
    "tutorialLocationServiceDisabledDialogDescription" : MessageLookupByLibrary.simpleMessage("Bitte aktivieren Sie die Standortdienste auf Ihrem Gerät."),
    "tutorialLocationServiceDisabledDialogLocationServiceButton" : MessageLookupByLibrary.simpleMessage("Standortdienste öffnen"),
    "tutorialLocationServiceDisabledDialogTitle" : MessageLookupByLibrary.simpleMessage("Standortdienste deaktiviert"),
    "tutorialManageTicketsDescription" : MessageLookupByLibrary.simpleMessage("Sie können sich an Ihre gebuchten Tickets erinnern lassen als auch gebuchte Tickets stornieren."),
    "tutorialManageTicketsTitle" : MessageLookupByLibrary.simpleMessage("Tickets verwalten"),
    "tutorialNextButton" : MessageLookupByLibrary.simpleMessage("Weiter"),
    "tutorialSkipButton" : MessageLookupByLibrary.simpleMessage("Später"),
    "tutorialTitle" : MessageLookupByLibrary.simpleMessage("Tutorial"),
    "tutorialWelcomeDescription" : MessageLookupByLibrary.simpleMessage("Aktuell befindet sich diese App noch in der ersten Beta. Deshalb sind noch keine echten Orte hinterlegt. Test-Supermärkte finden Sie aber zum Beispiel in Berlin Mitte."),
    "tutorialWelcomeTitle" : MessageLookupByLibrary.simpleMessage("Willkommen"),
    "usageInstructionsFirstTicketDescription" : MessageLookupByLibrary.simpleMessage("Bitte beachten Sie die folgenden Verhaltenshinweise wenn Sie einen Ort mit SafeMarket besuchen:\n\n1. Bitte kommen Sie maximal 5 Minuten vor Ticketbeginn.\n2. Ihr Ticket verfällt nach 10 Minuten, wenn Sie den Laden nicht betreten.\n3. Bitte zeigen Sie Ihr Ticket unaufgefordert vor."),
    "usageInstructionsFirstTicketSubtitle" : MessageLookupByLibrary.simpleMessage("Sie haben Ihr erstes Ticket gebucht!"),
    "usageInstructionsFirstTicketTitle" : MessageLookupByLibrary.simpleMessage("Herzlich Glückwunsch"),
    "usageInstructionsOkButton" : MessageLookupByLibrary.simpleMessage("Verstanden"),
    "website" : MessageLookupByLibrary.simpleMessage("Webseite")
  };
}
