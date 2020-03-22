import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/app_localizations.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui/map/reservation_slot_selection.dart';
import 'reservation_confirmation_dialog.dart';

class LocationDetailSheet extends StatefulWidget {
  final Location location;

  LocationDetailSheet({
    Key key,
    @required this.location,
  }) : super(key: key);

  @override
  _LocationDetailSheetState createState() => _LocationDetailSheetState();
}

class _LocationDetailSheetState extends State<LocationDetailSheet> {
  DateTime barplotDate = DateTime.now();
  DateTime selectedTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 75,
                    child: Image(
                      image: AssetImage('assets/002-shop.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.location.name,
                        style: Theme.of(context)
                            .textTheme
                            .headline
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.location.address_street,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.location.address_city,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),
              ],
            ),
            ReservationSlotSelection(
              capacity_utilization: widget.location.capacity_utilization,
              barplotDate: barplotDate,
              selectedSlotChanged: (slot) {
                setState(() {
                  selectedTime = slot;
                });
              },
            ),
            _ChangeDateButton(
                title: (DateFormat.yMMMMd("en_US")).format(barplotDate),
                dateChanged: (date) {
                  setState(() {
                    barplotDate = date;
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
                  child: RaisedButton(
                    child: Text(AppLocalizations.of(context).translate("reserve_slot")),
                    color: Color(0xFF00F2A9),
                    textColor: Color(0xFF322153),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20),
                        side: BorderSide(color: Color(0xFF00F2A9))),
                    onPressed: selectedTime == null
                        ? null
                        : () {
                            BlocProvider.of<ReservationsBloc>(context)
                                .add(MakeReservation(
                              locationId: widget.location.id,
                              startTime: selectedTime,
                            ));
                            return showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return ReservationConfirmationDialog(
                                    widget.location.name, selectedTime);
                              },
                            );
                          },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ChangeDateButton extends StatelessWidget {
  final String title;
  final ValueChanged<DateTime> dateChanged;

  const _ChangeDateButton({
    Key key,
    @required this.title,
    @required this.dateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        title,
        style: TextStyle(decoration: TextDecoration.underline),
      ),
      textColor: Colors.blue,
      onPressed: () async {
        Future<DateTime> selectedDate = showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(Duration(hours: 1)),
          lastDate: DateTime.now().add(Duration(days: 2)),
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData.dark(),
              child: child,
            );
          },
        );
        DateTime date = await selectedDate;

        if (date != null && date.isAfter(DateTime.now())) {
          dateChanged(date);
        }
      },
    );
  }
}
