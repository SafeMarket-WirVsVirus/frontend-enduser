import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/repository/data/data.dart';
import 'package:reservation_system_customer/ui_imports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHandler {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Reservation reservation;
  final BuildContext context;

  NotificationHandler(
      this.flutterLocalNotificationsPlugin, this.reservation, this.context);

  int notificationId = 0;

  void _setUpLocalNotificationsPlugin() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void cancelReminder() async {
    if (flutterLocalNotificationsPlugin == null) {
      _setUpLocalNotificationsPlugin();
    }

    //cancel the notification
    await flutterLocalNotificationsPlugin.cancel(notificationId);

    //remove the savedId
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('${reservation.id}');
  }

  void setReminder() async {
    if (flutterLocalNotificationsPlugin == null) {
      _setUpLocalNotificationsPlugin();
    }

    //use the current system time in seconds (cannot handle milliseconds) as a notificationId
    notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    var scheduledNotificationDateTime = reservation.startTime
        .subtract(Constants.durationForNotificationBeforeStartTime);
    //TODO: add actual androidPlatformChannelSpecifics information here
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    final localizations = AppLocalizations.of(context);
    final formattedDate = DateFormat.jm(localizations.locale.languageCode)
        .format(reservation.startTime);
    await flutterLocalNotificationsPlugin.schedule(
        notificationId,
        localizations.reservationReminderNotificationTitle,
        reservation.location?.name == null
            ? localizations
                .reservationReminderNotificationDescriptionWithoutLocation(
                    formattedDate)
            : localizations.reservationReminderNotificationDescription(
                reservation.location?.name,
                formattedDate,
              ),
        scheduledNotificationDateTime,
        platformChannelSpecifics);

    //save notificationId with sharedPreferences so we can cancel it later if needed
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${reservation.id}', notificationId);
    print(
        "Saved notificationId=$notificationId for reservationId=${reservation.id}");
  }

  //android
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    print("clicked push notification (Android)");
  }

  //iOS
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    print("clicked push notification (Android)");
  }
}
