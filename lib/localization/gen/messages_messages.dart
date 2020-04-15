// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
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
  String get localeName => 'messages';

  static m0(locationName) => "Do you really want to delete the reservation for ${locationName}?";

  static m1(locationName, formattedTime) => "Your reservation for ${locationName} starts at ${formattedTime}.";

  static m2(formattedTime) => "Your reservation starts at ${formattedTime}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aboutTheAppDescription1" : MessageLookupByLibrary.simpleMessage("Our project was created during the "),
    "aboutTheAppDescription2" : MessageLookupByLibrary.simpleMessage("#WirVsVirus hackathon"),
    "aboutTheAppDescription3" : MessageLookupByLibrary.simpleMessage(".\n\nWith SafeMarket you can reserve time slots for places with limited customer capacities such as grocery stores."),
    "aboutTheAppTitle" : MessageLookupByLibrary.simpleMessage("About the App"),
    "addReminderButtonTitle" : MessageLookupByLibrary.simpleMessage("Notify"),
    "appName" : MessageLookupByLibrary.simpleMessage("SafeMarket"),
    "commonCancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "commonOk" : MessageLookupByLibrary.simpleMessage("OK"),
    "createReservationFailedDialogDescription" : MessageLookupByLibrary.simpleMessage("Your reservation could not be created."),
    "createReservationFailedDialogTitle" : MessageLookupByLibrary.simpleMessage("Warning"),
    "createReservationSuccessSnackbar" : MessageLookupByLibrary.simpleMessage("Slot reserved"),
    "creditsDesignSectionBody" : MessageLookupByLibrary.simpleMessage("Logo by Chris Z.\nIcons designed by Vitaly Gorbachev from Flaticon"),
    "creditsDesignSectionTitle" : MessageLookupByLibrary.simpleMessage("Design"),
    "creditsTitle" : MessageLookupByLibrary.simpleMessage("Credits"),
    "deleteReservationDialogTitle" : m0,
    "deleteReservationDialogTitleWithoutLocation" : MessageLookupByLibrary.simpleMessage("Do you really want to delete the reservation?"),
    "locationFilterBakeriesLabel" : MessageLookupByLibrary.simpleMessage("Bakeries"),
    "locationFilterPharmaciesLabel" : MessageLookupByLibrary.simpleMessage("Pharmacies"),
    "locationFilterSupermarketsLabel" : MessageLookupByLibrary.simpleMessage("Supermarkets"),
    "locationSlotDateNotAvailable" : MessageLookupByLibrary.simpleMessage("Data could not be loaded"),
    "locationUtilizationSliderTip1" : MessageLookupByLibrary.simpleMessage("Only stores with low utilization are shown (great for high-risk groups)"),
    "locationUtilizationSliderTip2" : MessageLookupByLibrary.simpleMessage("Stores with very high utilization are not shown"),
    "locationUtilizationSliderTip3" : MessageLookupByLibrary.simpleMessage("All stores are shown, even if utilization is high at the moment"),
    "locationUtilizationSliderTitle" : MessageLookupByLibrary.simpleMessage("Utilization"),
    "mapBottomBarTitle" : MessageLookupByLibrary.simpleMessage("Search"),
    "openSourceLicensesTitle" : MessageLookupByLibrary.simpleMessage("Open Source Licenses"),
    "reservationReminderNotificationChannelDescription" : MessageLookupByLibrary.simpleMessage("Notifications for your upcoming reservations."),
    "reservationReminderNotificationChannelName" : MessageLookupByLibrary.simpleMessage("Upcoming Reservations"),
    "reservationReminderNotificationDescription" : m1,
    "reservationReminderNotificationDescriptionWithoutLocation" : m2,
    "reservationReminderNotificationTitle" : MessageLookupByLibrary.simpleMessage("Upcoming reservation"),
    "reservationsBottomBarTitle" : MessageLookupByLibrary.simpleMessage("My slots"),
    "reservationsListEmpty" : MessageLookupByLibrary.simpleMessage("You do not have any open reservations at the moment."),
    "reservationsNavBarTitle" : MessageLookupByLibrary.simpleMessage("My\nreservations"),
    "reservationsNotAvailableOffline" : MessageLookupByLibrary.simpleMessage("Sorry, we do not support offline mode yet."),
    "reserveSlotButtonTitle" : MessageLookupByLibrary.simpleMessage("Reserve Slot"),
    "tutorialBookTicketDescription" : MessageLookupByLibrary.simpleMessage("1. Choose your preferred location.\n2. Select the time.\n3. Confirm your ticket."),
    "tutorialBookTicketTitle" : MessageLookupByLibrary.simpleMessage("Book Ticket"),
    "tutorialCheckInDescription" : MessageLookupByLibrary.simpleMessage("To prove that you have a valid ticket:\n• Present the QR code of your ticket in the app OR\n• Name the code words that are displayed under your ticket."),
    "tutorialCheckInTitle" : MessageLookupByLibrary.simpleMessage("On-Site Check-In"),
    "tutorialDoneButton" : MessageLookupByLibrary.simpleMessage("Done"),
    "tutorialIntroductionDescription" : MessageLookupByLibrary.simpleMessage("With SafeMarket you can book tickets for your preferred location and verify that you have a valid ticket on-site."),
    "tutorialIntroductionTitle" : MessageLookupByLibrary.simpleMessage("Overview"),
    "tutorialLastSlideDescription" : MessageLookupByLibrary.simpleMessage("We are looking forward to your feedback. Please visit our website for contact information."),
    "tutorialLastSlideTitle" : MessageLookupByLibrary.simpleMessage("All Done"),
    "tutorialLocationPermissionDeclinedDialogDescription" : MessageLookupByLibrary.simpleMessage("Please enable location permission in the app settings to continue."),
    "tutorialLocationPermissionDeclinedDialogTitle" : MessageLookupByLibrary.simpleMessage("Location Permission"),
    "tutorialLocationPermissionDeclinedGoToSettingsButton" : MessageLookupByLibrary.simpleMessage("Open App Settings"),
    "tutorialLocationPermissionDescription" : MessageLookupByLibrary.simpleMessage("The location permission is used to search for locations close-by. You can still use the app without it."),
    "tutorialLocationPermissionStatusGranted" : MessageLookupByLibrary.simpleMessage("Permission granted"),
    "tutorialLocationPermissionStatusNotGranted" : MessageLookupByLibrary.simpleMessage("Grant Location Permission"),
    "tutorialLocationPermissionStatusTesting" : MessageLookupByLibrary.simpleMessage("Checking Status"),
    "tutorialLocationPermissionTitle" : MessageLookupByLibrary.simpleMessage("Location Permission"),
    "tutorialLocationServiceDisabledDialogDescription" : MessageLookupByLibrary.simpleMessage("Please enable the system location service first to continue."),
    "tutorialLocationServiceDisabledDialogLocationServiceButton" : MessageLookupByLibrary.simpleMessage("Open Location Service"),
    "tutorialLocationServiceDisabledDialogTitle" : MessageLookupByLibrary.simpleMessage("Location Service Disabled"),
    "tutorialManageTicketsDescription" : MessageLookupByLibrary.simpleMessage("You can enable reminders for your booked tickets as well as cancel your booked tickets."),
    "tutorialManageTicketsTitle" : MessageLookupByLibrary.simpleMessage("Manage Tickets"),
    "tutorialNextButton" : MessageLookupByLibrary.simpleMessage("Next"),
    "tutorialSkipButton" : MessageLookupByLibrary.simpleMessage("Skip"),
    "tutorialTitle" : MessageLookupByLibrary.simpleMessage("Tutorial"),
    "tutorialWelcomeDescription" : MessageLookupByLibrary.simpleMessage("At the moment this app is in an early beta. For this reason there are no real locations yet. You can find test supermarkets for example in the city center of Berlin."),
    "tutorialWelcomeTitle" : MessageLookupByLibrary.simpleMessage("Welcome"),
    "usageInstructionsFirstTicketDescription" : MessageLookupByLibrary.simpleMessage("Please note the following rules of conduct when visiting a location with SafeMarket:\n\n1. Please arrive at most 5 minutes before your ticket starts.\n2. Your ticket will expire after 10 minutes when you do not enter the location.\n3. Please show your ticket without being prompted."),
    "usageInstructionsFirstTicketSubtitle" : MessageLookupByLibrary.simpleMessage("You just booked your first ticket!"),
    "usageInstructionsFirstTicketTitle" : MessageLookupByLibrary.simpleMessage("Congratulations"),
    "usageInstructionsOkButton" : MessageLookupByLibrary.simpleMessage("OK"),
    "website" : MessageLookupByLibrary.simpleMessage("Website")
  };
}
