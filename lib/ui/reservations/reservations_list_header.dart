import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/ui_imports.dart';

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

class _NotificationButton extends StatelessWidget {
  final Reservation reservation;

  bool get isNotificationSet => reservation.reminderNotificationId != null;

  const _NotificationButton({
    Key key,
    @required this.reservation,
  }) : super(key: key);

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
              BlocProvider.of<ReservationsBloc>(context).add(
                ToggleReminderForReservation(
                  reservationId: reservation.id,
                  context: context,
                ),
              );
            }
          : null,
    );
  }

  bool _canScheduleNotification() {
    return reservation.startTime.difference(DateTime.now()) >
        Constants.durationForNotificationBeforeStartTime;
  }
}
