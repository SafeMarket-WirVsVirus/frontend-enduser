import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return SingleChildScrollView(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.store,
                  size: 75,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.location.name,
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.location.address_street,
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.location.address_city,
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle,
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
                selectedTime = slot;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  textColor: Theme.of(context).accentColor,
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
                    DateTime timepoint = await selectedDate;
                    setState(() {
                      if (timepoint != null &&
                          timepoint.isAfter(DateTime.now())) {
                        setState(() {
                          barplotDate = timepoint;
                        });
                      }
                    });
                  },
                  child: Text("Anderes Datum auswählen",
                      style: Theme.of(context).textTheme.caption),
                )
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: RaisedButton(
                  child: Text("Slot reservieren"),
                  onPressed: () {
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
            )
          ]),
    );
  }
}
