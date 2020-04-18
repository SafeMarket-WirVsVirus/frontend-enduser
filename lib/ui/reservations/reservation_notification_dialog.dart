import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/ui_imports.dart';

class ReservationNotificationDialog extends StatefulWidget {
  final ReservationsBloc reservationsBloc;
  final Reservation reservation;

  const ReservationNotificationDialog(
      {Key key, @required this.reservationsBloc, @required this.reservation})
      : super(key: key);

  @override
  _ReservationNotificationDialogState createState() =>
      _ReservationNotificationDialogState();
}

class _ReservationNotificationDialogState
    extends State<ReservationNotificationDialog> {
  Duration reminderTime;

  @override
  void initState() {
    if (_canScheduleNotification(Constants.possibleNotificationTimes[1])) {
      reminderTime = Constants.possibleNotificationTimes[1];
    } else if (_canScheduleNotification(
        Constants.possibleNotificationTimes[0])) {
      reminderTime = Constants.possibleNotificationTimes[0];
    } else {
      reminderTime = null;
    }
  }

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
                AppLocalizations.of(context).reminderDialogTitle,
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
            SingleChildScrollView(
                child: ListView.builder(
              itemBuilder: (context, index) => Opacity(
                opacity: _canScheduleNotification(
                        Constants.possibleNotificationTimes[index])
                    ? 1
                    : 0.4,
                child: RadioListTile(
                  title: Text(_formatDuration(
                          Constants.possibleNotificationTimes[index]) + ' ' +
                      AppLocalizations.of(context).reminderDialogBeforeText),
                  value: Constants.possibleNotificationTimes[index],
                  groupValue: reminderTime,
                  onChanged: (duration) {
                    setState(() {
                      if (_canScheduleNotification(duration)) {
                        reminderTime =
                            Constants.possibleNotificationTimes[index];
                      }
                    });
                  },
                  activeColor: Theme.of(context).accentColor,
                ),
              ),
              itemCount: Constants.possibleNotificationTimes.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            )),
            FlatButton(
              child: Text(AppLocalizations.of(context).commonOk),
              onPressed: () {
                widget.reservationsBloc.add(ChangeReminderForReservation(
                  reservationId: widget.reservation.id,
                  reminderTime: reminderTime,
                  context: context,
                ));
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  _formatDuration(Duration duration) {
    if (duration.inHours == 0) {
      return duration.inMinutes.toString() + ' min';
    } else if (duration.inMinutes % 60 == 0) {
      return duration.inHours.toString() + ' h';
    } else {
      return duration.inHours.toString() +
          ':' +
          NumberFormat('00').format(duration.inMinutes % 60) +
          ' h';
    }
  }

  bool _canScheduleNotification(Duration duration) {
    return widget.reservation.startTime.difference(DateTime.now()) > duration;
  }
}
