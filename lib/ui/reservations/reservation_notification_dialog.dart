

import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/ui_imports.dart';

class ReservationNotificationDialog extends StatefulWidget {
  final ReservationsBloc reservationsBloc;
  final Reservation reservation;

  const ReservationNotificationDialog({
    Key key,
    @required this.reservationsBloc,
    @required this.reservation
  }) : super(key: key);

  @override
  _ReservationNotificationDialogState createState() => _ReservationNotificationDialogState();
}

class _ReservationNotificationDialogState extends State<ReservationNotificationDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
//          Text(AppLocalizations.of(context).selectReminderTime),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Set reminder",
                style: Theme.of(context).textTheme.subhead,
            ),
          ),
          SingleChildScrollView(
              child: ListView.builder(
                itemBuilder: (context, index) => Opacity(
                  opacity: _canScheduleNotification(Constants.possibleNotificationTimes[index]) ?
                    1 : 0.4,
                  child: RadioListTile(
                    title: Text(_formatDuration(Constants.possibleNotificationTimes[index]) + " before"),
                    value: Constants.possibleNotificationTimes[index],
                    groupValue: Constants.possibleNotificationTimes[0],
                    onChanged: (duration) => {
                      if (_canScheduleNotification(duration)) {
                        widget.reservationsBloc.add(ToggleReminderForReservation(
                          context: context,
                          reservationId: widget.reservation.id,
                        ))
                      }
                    },
                    activeColor: Theme.of(context).accentColor,
                  ),
                ),
                itemCount: Constants.possibleNotificationTimes.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              )
          ),
//          Text(AppLocalizations.of(context).reminderBeforeSlot),
        ],
      )
    );
  }

  _formatDuration(Duration duration) {
    if (duration.inHours == 0) {
      return duration.inMinutes.toString() + ' min';
    } else if (duration.inMinutes % 60 == 0) {
      return duration.inHours.toString() + ' h';
    } else {
      return duration.inHours.toString() + ':' + NumberFormat('00').format(duration.inMinutes % 60) + ' h';
    }
  }

  bool _canScheduleNotification(Duration duration) {
    return widget.reservation.startTime.difference(DateTime.now()) > duration;
  }

}