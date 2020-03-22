import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/notifications.dart';

import '../../app_localizations.dart';

class ReservationListEntry extends StatefulWidget {
  final item;

  const ReservationListEntry({Key key, this.item}) : super(key: key);

  @override
  _ReservationListEntryState createState() => _ReservationListEntryState();
}

class _ReservationListEntryState extends State<ReservationListEntry> {
  bool reminderSet = false;

  var flutterLocalNotificationsPlugin;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return Dismissible(
        key: Key('${widget.item.id}'),
        background: Container(
          color: Colors.red,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.delete, size: 40))
              ]),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text(
                    AppLocalizations.of(context).translate("delete_res_1") +
                        '${widget.item.location?.name ?? ''}' +
                        AppLocalizations.of(context).translate("delete_res_2"),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                          AppLocalizations.of(context).translate("cancel")),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    FlatButton(
                      child: Text(AppLocalizations.of(context).translate("ok")),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
          );
        },
        onDismissed: (direction) async {
          BlocProvider.of<ReservationsBloc>(context).add(CancelReservation(
            reservationId: widget.item.id,
            locationId: widget.item.location.id,
          ));
        },
        child: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 50,
                    child: Image(
                      image: AssetImage('assets/002-shop.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.item.location?.name ?? '',
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline,
                            softWrap: true,
                          ),
                          Text(
                            widget.item.location?.address ?? "",
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle,
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 70,
                    child: FlatButton(
                      child: Image(
                          fit: BoxFit.fitWidth,
                          image: reminderSet ?AssetImage(
                          'assets/004-bell.png',
                        ):
                        AssetImage(
                        'assets/004-bell-mute.png',
                      ),),
                      onPressed: () {
                        setState(() {
                          reminderSet = !reminderSet;
                        });

                        NotificationHandler notification = NotificationHandler(null,widget.item,context);
                      },
                    ),
                  ),
                  Container(
                    width: 70,
                    child: FlatButton(
                      child: Image(
                          image: AssetImage('assets/school-material.png'),
                          fit: BoxFit.fitWidth),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
              Text(DateFormat.yMMMMd("de_DE").add_jm().format(widget.item.startTime))
            ],
          ),
        ));
  }

  void _setUpNotificationPlugin(){
    void _setUpLocalNotificationsPlugin() async {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      var initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
      var initializationSettingsIOS = IOSInitializationSettings(
          onDidReceiveLocalNotification: (int id, String title, String body, String payload){return null;});
      var initializationSettings = InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String payload){return null;});
    }
  }
}