import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/repository/data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_localizations.dart';
import '../../notifications.dart';

class ReservationListEntry extends StatelessWidget {
  final Reservation reservation;

  const ReservationListEntry({
    Key key,
    this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image(
            width: 30,
            image: AssetImage('assets/002-shop.png'),
            fit: BoxFit.fitWidth,
          ),
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DateFormat.yMd(
                            AppLocalizations.of(context).locale.languageCode)
                        .add_jm()
                        .format(reservation.startTime),
                    style: Theme.of(context).textTheme.subtitle,
                    softWrap: true,
                  ),
                  SizedBox(height: 10),
                  Text(
                    reservation.location?.name ?? '---',
                    style: Theme.of(context).textTheme.subhead,
                    softWrap: true,
                  ),
                  SizedBox(height: 5),
                  Text(
                    reservation.location?.address ?? '---',
                    style: Theme.of(context).textTheme.caption,
                    maxLines: 2,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 0,
            fit: FlexFit.loose,
            child: _NotificationButton(
              reservation: reservation,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatefulWidget {
  final Reservation reservation;

  const _NotificationButton({
    Key key,
    @required this.reservation,
  }) : super(key: key);

  @override
  __NotificationButtonState createState() => __NotificationButtonState();
}

class __NotificationButtonState extends State<_NotificationButton> {
  bool isNotificationSet = false;
  NotificationHandler notificationHandler;

  @override
  void initState() {
    super.initState();
    notificationHandler =
        NotificationHandler(null, widget.reservation, context);
    _updateNotificationState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(4),
      child: Column(
        children: <Widget>[
          Image(
            width: 20,
            image: isNotificationSet
                ? AssetImage('assets/004-bell.png')
                : AssetImage('assets/004-bell-mute.png'),
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 5),
          Text(AppLocalizations.of(context).translate("notification")),
        ],
      ),
      onPressed: () {
        setState(() {
          isNotificationSet = !isNotificationSet;
        });

        if (isNotificationSet) {
          notificationHandler.setReminder();
        } else {
          notificationHandler.cancelReminder();
        }
      },
    );
  }

  void _updateNotificationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool set = prefs.get('${widget.reservation.id}') == null ? false : true;

    if (mounted) {
      setState(() {
        isNotificationSet = set;
      });
    }
  }
}
