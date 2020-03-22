import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/app_localizations.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:reservation_system_customer/repository/data/capacity_utilization.dart';
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
  DateTime selectedDate = DateTime.now();
  DateTime selectedTime;
  List<Timeslot_Data> data;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

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
            _LocationInformation(
              name: widget.location.name,
              address: widget.location.address,
            ),
            _ReservationSlotsWithLoading(
              data: data,
              slotSize: widget.location.slotSize,
              selectedSlotChanged: (slot) {
                setState(() {
                  selectedTime = slot;
                });
              },
            ),
            _ChangeDateButton(
                title: (DateFormat.yMMMMd("en_US")).format(selectedDate),
                dateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                  _fetchData();
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
                  child: RaisedButton(
                    child: Text(
                        AppLocalizations.of(context).translate("reserve_slot")),
                    color: Color(0xFF00F2A9),
                    textColor: Color(0xFF322153),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20),
                        side: BorderSide(color: Color(0xFF00F2A9))),
                    onPressed: selectedTime == null
                        ? null
                        : () {
                            BlocProvider.of<ReservationsBloc>(context).add(
                              MakeReservation(
                                locationId: widget.location.id,
                                startTime: selectedTime,
                              ),
                            );
                            return showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return ReservationConfirmationDialog(
                                    widget.location?.name, selectedTime);
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

  _fetchData() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      if (mounted) {
        setState(() {
          data = widget.location.capacity_utilization
              .get_utilization_by_date(selectedDate)
              .timeslot_data;
        });
      }
    });
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
          builder: (BuildContext context, Widget child) => child,
        );
        DateTime date = await selectedDate;

        if (date != null && date.isAfter(DateTime.now())) {
          dateChanged(date);
        }
      },
    );
  }
}

class _ReservationSlotsWithLoading extends StatelessWidget {
  final int slotSize;
  final List<Timeslot_Data> data;
  final ValueChanged selectedSlotChanged;

  const _ReservationSlotsWithLoading({
    Key key,
    @required this.slotSize,
    @required this.data,
    @required this.selectedSlotChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Container(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return ReservationSlotSelection(
        data: data,
        slotSize: slotSize,
        selectedSlotChanged: selectedSlotChanged,
      );
    }
  }
}

class _LocationInformation extends StatelessWidget {
  final String name;
  final String address;

  const _LocationInformation({
    Key key,
    @required this.name,
    @required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                name ?? '',
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Text(
                address ?? '',
                style: Theme.of(context).textTheme.subtitle,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
