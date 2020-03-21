import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/data/data.dart';

Future<void> _ticketDialog(BuildContext context, String id) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Dein Ticket:',
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: QrImage(
                data: id,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      );
    },
  );
}


class ReservationDetailPage extends StatefulWidget {
  final Reservation reservation;

  ReservationDetailPage({this.reservation});

  @override
  _ReservationDetailPageState createState() =>
      _ReservationDetailPageState(reservation);
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  final DateFormat dateFormat = DateFormat("dd.MM.yyyy");
  final DateFormat timeFormat = DateFormat("hh:mm");
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Reservation reservation;
  bool reminder = false;
  int notificationId = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  GoogleMapController mapController;
  final Set<Marker> markers = new Set();

  @override
  void initState() {
    markers.add(Marker(
      markerId: MarkerId(reservation.location.id),
      position: reservation.location.position,
    ));
  }

  //  TODO actually remind the user
  SnackBar reminderSnackBar = SnackBar(
    content: Text("Erinnerung 30 Minuten vor deinem Termin"),
    duration: Duration(seconds: 3),
  );

  _ReservationDetailPageState(this.reservation);

  @override
  void initState() {
    _getReminderState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.reservation.location.name),
        actions: <Widget>[
          IconButton(
            icon: reminder
                ? Icon(Icons.notifications_active)
                : Icon(Icons.notifications_off),
            onPressed: () {
              _reminderSwitch();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              Navigator.pop(context); //TODO delete reservation
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                Text("Du hast einen Shopping-Slot bei"),
                Text("${reservation.location.name}",
                  style: Theme.of(context).textTheme.headline,),
                Text("am"),
                Text("${dateFormat.format(reservation.timeSlot.startTime)}",
                  style: Theme.of(context).textTheme.headline,),
                Text("um"),
                Text("${timeFormat.format(reservation.timeSlot.startTime)}",
                  style: Theme.of(context).textTheme.headline,),
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Expanded(
            child: Container(
              constraints: BoxConstraints.expand(),
              child: GoogleMap(
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                mapType: MapType.normal,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    reservation.location.position.latitude,
                    reservation.location.position.longitude,
                  ),
                  zoom: 15,
                ),
                onMapCreated: _onMapCreated,
                markers: markers,
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),

          FlatButton(
            child: Text("Ticket",
              style: Theme.of(context).textTheme.headline,),
            onPressed: () {
              _ticketDialog(context, reservation.id);
            },
          ),

          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _getReminderState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool reminderSet = prefs.getInt(reservation.id) == null ? false : true;

    print("Saved state: Remider set = $reminderSet");

    setState(() {
      reminder = reminderSet;
    });
  }

  void _reminderSwitch() {
    setState(() {
      reminder = !reminder;
      if (reminder) {
        _scaffoldKey.currentState.showSnackBar(reminderSnackBar);
        _setReminder();
      } else {
        _cancelReminder();
      }
    });
  }

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

  void _cancelReminder() async {
    if (flutterLocalNotificationsPlugin == null) {
      _setUpLocalNotificationsPlugin();
    }

    //cancel the notification
    await flutterLocalNotificationsPlugin.cancel(notificationId);

    //remove the savedId
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('${reservation.id}');
  }

  void _setReminder() async {
    if (flutterLocalNotificationsPlugin == null) {
      _setUpLocalNotificationsPlugin();
    }

    //use the current system time in seconds (cannot handle milliseconds) as a notificationId
    notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    var scheduledNotificationDateTime =
    reservation.timeSlot.startTime.subtract(Duration(minutes: 30));
    //TODO: add actual androidPlatformChannelSpecifics information here
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        notificationId,
        'Zeit einzukaufen: ${reservation.location.name} - ${timeFormat.format(reservation.timeSlot.startTime)} h',
        '- Navigation?',
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
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationsListPage()),
    );
  }

  //iOS
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservationsListPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _navigate() {
//    TODO navigate
  }
}
