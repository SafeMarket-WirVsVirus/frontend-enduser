import 'package:flutter/material.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_localizations.dart';
import '../../notifications.dart';

class ReservationListEntry extends StatefulWidget {
  final item;

  const ReservationListEntry({Key key, this.item}) : super(key: key);

  @override
  _ReservationListEntryState createState() => _ReservationListEntryState();
}

class _ReservationListEntryState extends State<ReservationListEntry> {
  bool notificationSet = false;
  NotificationHandler notificationHandler;

  void getNotificationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool set = prefs.get('${widget.item.id}') == null ? false : true;

    setState(() {
      notificationSet = set;
    });
  }

  @override
  void initState() {
    notificationHandler = NotificationHandler(null, widget.item, context);
    getNotificationState();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.item.location?.name ?? '',
                          style: Theme.of(context).textTheme.headline,
                          softWrap: true,
                        ),
                        Text(
                          widget.item.location?.address ?? "",
                          style: Theme.of(context).textTheme.caption,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 60,
                      child: FlatButton(
                        child: Image(
                          image: notificationSet
                              ? AssetImage(
                                  'assets/004-bell.png',
                                )
                              : AssetImage(
                                  'assets/004-bell-mute.png',
                                ),
                          fit: BoxFit.fitWidth,
                        ),
                        onPressed: () {
                          setState(() {
                            notificationSet = !notificationSet;
                          });

                          if (notificationSet) {
                            notificationHandler.setReminder();
                          } else {
                            notificationHandler.cancelReminder();
                          }
                        },
                      ),
                    ),
                    Text(AppLocalizations.of(context).translate("notification"))
                  ],
                ),
              ],
            ),
          ),
          Text(
            DateFormat.yMd(AppLocalizations.of(context).locale.languageCode)
                .add_jm()
                .format(widget.item.startTime),
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
