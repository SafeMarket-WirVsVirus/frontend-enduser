import 'package:provider/provider.dart';
import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/ui_imports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationListHeader extends StatelessWidget {
  final Reservation reservation;

  const ReservationListHeader({
    Key key,
    this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
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

  @override
  void initState() {
    super.initState();
    _updateNotificationState();
  }

  @override
  Widget build(BuildContext context) {
    var canScheduleNotification = _canScheduleNotification();
    return FlatButton(
      padding: EdgeInsets.all(4),
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: canScheduleNotification ? 1 : 0.4,
            child: Image(
              width: 20,
              image: isNotificationSet
                  ? AssetImage('assets/004-bell.png')
                  : AssetImage('assets/004-bell-mute.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(height: 5),
          Text(AppLocalizations.of(context).addReminderButtonTitle),
        ],
      ),
      onPressed: canScheduleNotification
          ? () {
              setState(() {
                isNotificationSet = !isNotificationSet;
              });

              final reservationsRepo = Provider.of<ReservationsRepository>(context, listen: false);

              if (isNotificationSet) {
                reservationsRepo.scheduleReservationReminder(widget.reservation, context);
              } else {
                reservationsRepo.cancelReservationReminder(widget.reservation);
              }
            }
          : null,
    );
  }

  bool _canScheduleNotification() {
    return widget.reservation.startTime.difference(DateTime.now()) >
        Constants.durationForNotificationBeforeStartTime;
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
