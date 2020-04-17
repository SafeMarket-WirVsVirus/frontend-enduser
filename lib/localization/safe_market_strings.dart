import 'package:intl/intl.dart';

import 'app_localizations.dart';

extension SafeMarketStrings on AppLocalizations {
  String get appName =>
      Intl.message("SafeMarket", name: 'appName', desc: 'Name of the app');

  String get reservationsBottomBarTitle => Intl.message(
        'My slots',
        name: 'reservationsBottomBarTitle',
        desc: 'Bottom bar title for reservations tab',
      );

  String get mapBottomBarTitle => Intl.message(
        'Search',
        name: 'mapBottomBarTitle',
        desc: 'Bottom bar title for map tab',
      );

  String get reservationsNavBarTitle => Intl.message(
        'My\nreservations',
        name: 'reservationsNavBarTitle',
        desc: 'Navigation bar title for reservations tab',
      );

  String get reservationsNotAvailableOffline => Intl.message(
        'Sorry, we do not support offline mode yet.',
        name: 'reservationsNotAvailableOffline',
        desc:
            'Message which is displayed when the user enters the reservation tab without network connection',
      );

  String get reservationsListEmpty => Intl.message(
        'You do not have any open reservations at the moment.',
        name: 'reservationsListEmpty',
        desc: 'Message which is displayed when the user has no reservations.',
      );

  String get commonOk => Intl.message(
        'OK',
        name: 'commonOk',
      );

  String get commonCancel => Intl.message(
        'Cancel',
        name: 'commonCancel',
      );

  String get addReminderButtonTitle => Intl.message(
        'Notify',
        name: 'addReminderButtonTitle',
        desc: 'Button title for adding a reminder for a reservation.',
      );

  String deleteReservationDialogTitle(String locationName) => Intl.message(
        'Do you really want to delete the reservation for $locationName?',
        name: 'deleteReservationDialogTitle',
        args: [locationName],
        desc:
            'Dialog title which confirms that the user wants to delete the reservation',
      );

  String get deleteReservationDialogTitleWithoutLocation => Intl.message(
        'Do you really want to delete the reservation?',
        name: 'deleteReservationDialogTitleWithoutLocation',
        desc:
            'Dialog title which confirms that the user wants to delete the reservation',
      );

  String get reservationReminderNotificationTitle => Intl.message(
        'Upcoming reservation',
        name: 'reservationReminderNotificationTitle',
        desc:
            'Title of the notification which reminds the user of an upcoming reservation',
      );

  String reservationReminderNotificationDescriptionWithoutLocation(
          String formattedTime) =>
      Intl.message(
        'Your reservation starts at $formattedTime.',
        name: 'reservationReminderNotificationDescriptionWithoutLocation',
        args: [formattedTime],
        desc:
            'Description of the notification which reminds the user of an upcoming reservation',
      );

  String reservationReminderNotificationDescription(
          String locationName, String formattedTime) =>
      Intl.message(
        'Your reservation for $locationName starts at $formattedTime.',
        name: 'reservationReminderNotificationDescription',
        args: [locationName, formattedTime],
        desc:
            'Description of the notification which reminds the user of an upcoming reservation',
      );

  String get reservationReminderNotificationChannelName => Intl.message(
        'Upcoming Reservations',
        name: 'reservationReminderNotificationChannelName',
        desc:
            'Name of the notification channel for reservation reminders which is displayed to the user in the app settings on Android.',
      );

  String get reservationReminderNotificationChannelDescription => Intl.message(
        'Notifications for your upcoming reservations.',
        name: 'reservationReminderNotificationChannelDescription',
        desc:
            'Description of the notification channel for reservation reminders which is displayed to the user in the app settings on Android.',
      );

  String get locationUtilizationSliderTitle => Intl.message(
        'Utilization',
        name: 'locationUtilizationSliderTitle',
        desc: 'Title above the slider for the maximum utilization levels.',
      );

  String get locationUtilizationSliderTip1 => Intl.message(
        'Only stores with low utilization are shown (great for high-risk groups)',
        name: 'locationUtilizationSliderTip1',
        desc:
            'Description for the utilization slider which only shows locations with a low utilization',
      );

  String get locationUtilizationSliderTip2 => Intl.message(
        'Stores with very high utilization are not shown',
        name: 'locationUtilizationSliderTip2',
        desc:
            'Description for the utilization slider which removes locations with a high utilization level.',
      );

  String get locationUtilizationSliderTip3 => Intl.message(
        'All stores are shown, even if utilization is high at the moment',
        name: 'locationUtilizationSliderTip3',
        desc: 'Description for the utilization slider which allows all levels.',
      );

  String get locationFilterSupermarketsLabel => Intl.message(
        'Supermarkets',
        name: 'locationFilterSupermarketsLabel',
        desc: 'Label for the location filter set to supermarkets',
      );

  String get locationFilterBakeriesLabel => Intl.message(
        'Bakeries',
        name: 'locationFilterBakeriesLabel',
        desc: 'Label for the location filter set to bakeries',
      );

  String get locationFilterPharmaciesLabel => Intl.message(
        'Pharmacies',
        name: 'locationFilterPharmaciesLabel',
        desc: 'Label for the location filter set to pharmacies',
      );

  String get locationSlotDateNotAvailable => Intl.message(
        'Data could not be loaded',
        name: 'locationSlotDateNotAvailable',
        desc:
            'Message which is displayed when the slot data for a location could not be retrieved',
      );

  String get reserveSlotButtonTitle => Intl.message(
        'Reserve Slot',
        name: 'reserveSlotButtonTitle',
        desc: 'Button title for reserving a slot',
      );

  String get createReservationSuccessSnackbar => Intl.message(
        'Slot reserved',
        name: 'createReservationSuccessSnackbar',
        desc:
            'Snackbar which is displayed when the reservation was created successfully',
      );

  String get createReservationFailedDialogTitle => Intl.message(
        'Warning',
        name: 'createReservationFailedDialogTitle',
        desc: 'Dialog title when the reservation could not be created',
      );

  String get createReservationFailedDialogDescription => Intl.message(
        'Your reservation could not be created.',
        name: 'createReservationFailedDialogDescription',
        desc: 'Dialog description when the reservation could not be created',
      );

  String get aboutTheAppTitle => Intl.message('About the App',
      name: 'aboutTheAppTitle',
      desc:
          'Title shown in about the app page as well as tooltip in the reservation page');

  String get openSourceLicensesTitle => Intl.message('Open Source Licenses',
      name: 'openSourceLicensesTitle',
      desc: 'Open source list item title in the about page');

  String get aboutTheAppDescription1 =>
      Intl.message('Our project was created during the ',
          name: 'aboutTheAppDescription1',
          desc: 'About the app Description part 1');

  String get aboutTheAppDescription2 => Intl.message('#WirVsVirus hackathon',
      name: 'aboutTheAppDescription2',
      desc: 'About the app Description part 2');

  String get aboutTheAppDescription3 => Intl.message(
      '.\n\nWith SafeMarket you can reserve time slots for places with limited customer capacities such as grocery stores.',
      name: 'aboutTheAppDescription3',
      desc: 'About the app Description part 3');

  String get website =>
      Intl.message("Website", name: 'website', desc: 'Website');

  String get creditsTitle => Intl.message(
        'Credits',
        name: 'creditsTitle',
        desc: 'Credits list item title on the about page',
      );

  String get creditsDesignSectionTitle => Intl.message(
        'Design',
        name: 'creditsDesignSectionTitle',
        desc: 'Section title for design on the credits page',
      );

  String get creditsDesignSectionBody => Intl.message(
        'Logo by Chris Z.\nIcons designed by Vitaly Gorbachev from Flaticon',
        name: 'creditsDesignSectionBody',
        desc: 'Credits for the design section on the credits page',
      );

  String get tutorialTitle => Intl.message(
        'Tutorial',
        name: 'tutorialTitle',
        desc: 'Tutorial Title',
      );

  String get tutorialWelcomeTitle => Intl.message(
        'Welcome',
        name: 'tutorialWelcomeTitle',
        desc: 'Title of the welcome tutorial slide',
      );

  String get tutorialWelcomeDescription => Intl.message(
        'At the moment this app is in an early beta. For this reason there are no real locations yet. You can find test supermarkets for example in the city center of Berlin.',
        name: 'tutorialWelcomeDescription',
        desc: 'Description of the welcome tutorial slide',
      );

  String get tutorialIntroductionTitle => Intl.message(
        'Overview',
        name: 'tutorialIntroductionTitle',
        desc: 'Title of the introduction tutorial slide',
      );

  String get tutorialIntroductionDescription => Intl.message(
        'With SafeMarket you can book tickets for your preferred location and verify that you have a valid ticket on-site.',
        name: 'tutorialIntroductionDescription',
        desc: 'Description of the introduction tutorial slide',
      );

  String get tutorialBookTicketTitle => Intl.message(
        'Book Ticket',
        name: 'tutorialBookTicketTitle',
        desc: 'Title of the book ticket tutorial slide',
      );

  String get tutorialBookTicketDescription => Intl.message(
        '1. Choose your preferred location.\n2. Select the time.\n3. Confirm your ticket.',
        name: 'tutorialBookTicketDescription',
        desc: 'Description of the book ticket tutorial slide',
      );

  String get tutorialManageTicketsTitle => Intl.message(
        'Manage Tickets',
        name: 'tutorialManageTicketsTitle',
        desc: 'Title of the manage tickets tutorial slide',
      );

  String get tutorialManageTicketsDescription => Intl.message(
        'You can enable reminders for your booked tickets as well as cancel your booked tickets.',
        name: 'tutorialManageTicketsDescription',
        desc: 'Description of the manage book tickets tutorial slide',
      );

  String get tutorialCheckInTitle => Intl.message(
        'On-Site Check-In',
        name: 'tutorialCheckInTitle',
        desc: 'Title of the store checkin tutorial slide',
      );

  String get tutorialCheckInDescription => Intl.message(
        'To prove that you have a valid ticket:\n\u2022 Present the QR code of your ticket in the app OR\n\u2022 Name the code words that are displayed under your ticket.',
        name: 'tutorialCheckInDescription',
        desc: 'Description of the store checkin tutorial slide',
      );

  String get tutorialLocationPermissionTitle => Intl.message(
        'Location Permission',
        name: 'tutorialLocationPermissionTitle',
        desc: 'Title of the location permission tutorial slide',
      );

  String get tutorialLocationPermissionDescription => Intl.message(
        'The location permission is used to search for locations close-by. You can still use the app without it.',
        name: 'tutorialLocationPermissionDescription',
        desc: 'Description of the location permission tutorial slide',
      );

  String get tutorialLocationServiceDisabledDialogTitle => Intl.message(
        'Location Service Disabled',
        name: 'tutorialLocationServiceDisabledDialogTitle',
        desc:
            'Title of the dialog which notifies the user about the disabled location services on the location permission tutorial slide',
      );

  String get tutorialLocationServiceDisabledDialogDescription => Intl.message(
        'Please enable the system location service first to continue.',
        name: 'tutorialLocationServiceDisabledDialogDescription',
        desc:
            'Description of the dialog which notifies the user about the disabled location services on the location permission tutorial slide',
      );

  String get tutorialLocationServiceDisabledDialogLocationServiceButton =>
      Intl.message(
        'Open Location Service',
        name: 'tutorialLocationServiceDisabledDialogLocationServiceButton',
        desc: 'Button title which opens the location service',
      );

  String get tutorialLocationPermissionStatusGranted => Intl.message(
        'Permission granted',
        name: 'tutorialLocationPermissionStatusGranted',
        desc: 'Description for granted location permission in the tutorial',
      );

  String get tutorialLocationPermissionStatusNotGranted => Intl.message(
        'Grant Location Permission',
        name: 'tutorialLocationPermissionStatusNotGranted',
        desc:
            'Button title for non-granted location permission in the tutorial',
      );

  String get tutorialLocationPermissionStatusTesting => Intl.message(
        'Checking Status',
        name: 'tutorialLocationPermissionStatusTesting',
        desc:
            'Description which is displayed while the location permission status is checked in the tutorial',
      );

  String get tutorialLocationPermissionDeclinedDialogTitle => Intl.message(
    'Location Permission',
    name: 'tutorialLocationPermissionDeclinedDialogTitle',
    desc:
    'Title of the dialog which notifies the user that he declined the location permission on the location permission tutorial slide',
  );

  String get tutorialLocationPermissionDeclinedDialogDescription => Intl.message(
    'Please enable location permission in the app settings to continue.',
    name: 'tutorialLocationPermissionDeclinedDialogDescription',
    desc:
    'Description of the dialog which notifies the user about the disabled location services on the location permission tutorial slide',
  );

  String get tutorialLocationPermissionDeclinedGoToSettingsButton => Intl.message(
        'Open App Settings',
        name: 'tutorialLocationPermissionDeclinedGoToSettingsButton',
        desc: 'Button title which will open the app settings in the tutorial',
      );

  String get tutorialLastSlideTitle => Intl.message(
        'All Done',
        name: 'tutorialLastSlideTitle',
        desc: 'Title of the last tutorial slide',
      );

  String get tutorialLastSlideDescription => Intl.message(
        'We are looking forward to your feedback. Please visit our website for contact information.',
        name: 'tutorialLastSlideDescription',
        desc: 'Description of the last tutorial slide',
      );

  String get tutorialSkipButton => Intl.message(
        'Skip',
        name: 'tutorialSkipButton',
        desc: 'Title of the skip button in the tutorial',
      );

  String get tutorialNextButton => Intl.message(
        'Next',
        name: 'tutorialNextButton',
        desc: 'Title of the next button in the tutorial',
      );

  String get tutorialDoneButton => Intl.message(
        'Done',
        name: 'tutorialDoneButton',
        desc: 'Title of the done button in the tutorial',
      );

  String get usageInstructionsFirstTicketTitle => Intl.message(
        'Congratulations',
        name: 'usageInstructionsFirstTicketTitle',
        desc: 'Title of the usage instructions after creating the first ticket',
      );

  String get usageInstructionsFirstTicketSubtitle => Intl.message(
        'You just booked your first ticket!',
        name: 'usageInstructionsFirstTicketSubtitle',
        desc:
            'Subtitle of the usage instructions after creating the first ticket',
      );

  String get usageInstructionsFirstTicketDescription => Intl.message(
        'Please note the following rules of conduct when visiting a location with SafeMarket:\n\n1. Please arrive at most 5 minutes before your ticket starts.\n2. Your ticket will expire after 10 minutes when you do not enter the location.\n3. Please show your ticket without being prompted.',
        name: 'usageInstructionsFirstTicketDescription',
        desc:
            'Description of the usage instructions after creating the first ticket',
      );

  String get usageInstructionsOkButton => Intl.message(
        'OK',
        name: 'usageInstructionsOkButton',
        desc:
            'Button title of the usage instructions after creating the first ticket',
      );

  String get reminderDialogTitle => Intl.message(
      'Set a reminder',
      name: 'reminderDialogTitle',
      desc:
        'Title displayed at the top of the dialog to select a reminder time'
  );


  String get reminderDialogBeforeText => Intl.message(
      'before',
      name: 'reminderDialogBeforeText',
      desc:
      'Text to indicate that the times in the reminder dialog mean time before a slot'
  );
}
