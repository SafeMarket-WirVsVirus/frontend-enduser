import 'package:intl/intl.dart';

import 'app_localizations.dart';

extension SafeMarketStrings on AppLocalizations {
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
}
