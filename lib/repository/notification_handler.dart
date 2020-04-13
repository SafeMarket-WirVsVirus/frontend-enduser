import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/logger.dart';
import 'package:reservation_system_customer/localization/localization.dart';
import 'package:reservation_system_customer/repository/data/reservation.dart';

const _notificationChannelId =
    'com.safe_market.reservation_system_customer.notifications';

class NotificationHandler {
  FlutterLocalNotificationsPlugin _pluginInstance;

  Future<FlutterLocalNotificationsPlugin> get _localNotificationsPlugin async {
    if (_pluginInstance == null) {
      _pluginInstance = await _setUpLocalNotificationsPlugin();
    }
    return _pluginInstance;
  }

  void cancelNotification(int notificationId) async {
    await (await _localNotificationsPlugin).cancel(notificationId);
  }

  Future<int> scheduleReservationReminder({
    @required BuildContext context,
    @required Reservation reservation,
  }) async {
    NotificationDetails reservationReminderChannel =
        _reservationReminderChannel(context);

    final localizations = AppLocalizations.of(context);
    final formattedDate = DateFormat.jm(localizations.locale.languageCode)
        .format(reservation.startTime);

    final description = reservation.location?.name == null
        ? localizations
            .reservationReminderNotificationDescriptionWithoutLocation(
                formattedDate)
        : localizations.reservationReminderNotificationDescription(
            reservation.location?.name,
            formattedDate,
          );

    return await _scheduleNotification(
      title: localizations.reservationReminderNotificationTitle,
      description: description,
      time: reservation.startTime
          .subtract(Constants.durationForNotificationBeforeStartTime),
      channel: reservationReminderChannel,
    );
  }

  Future<int> _scheduleNotification({
    @required String title,
    @required String description,
    @required DateTime time,
    @required NotificationDetails channel,
  }) async {
    // use the current system time in seconds (cannot handle milliseconds) as a notificationId
    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await (await _localNotificationsPlugin).schedule(
      notificationId,
      title,
      description,
      time,
      channel,
    );
    return notificationId;
  }

  //android
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debug('notification payload: ' + payload);
    }

    debug("clicked push notification (Android)");
  }

  //iOS
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    debug("clicked push notification (iOS)");
  }

  Future<FlutterLocalNotificationsPlugin>
      _setUpLocalNotificationsPlugin() async {
    final localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );

    await localNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    return localNotificationsPlugin;
  }

  NotificationDetails _reservationReminderChannel(BuildContext context) {
    final androidDetails = AndroidNotificationDetails(
      _notificationChannelId,
      AppLocalizations.of(context).reservationReminderNotificationChannelName,
      AppLocalizations.of(context)
          .reservationReminderNotificationChannelDescription,
      importance: Importance.High,
      priority: Priority.High,
    );

    final iosDetails = IOSNotificationDetails(
      presentSound: true,
    );

    return NotificationDetails(
      androidDetails,
      iosDetails,
    );
  }
}
