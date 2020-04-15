import 'package:provider/provider.dart';
import 'package:reservation_system_customer/ui/map/reservation_slot_selection.dart';
import 'package:reservation_system_customer/ui_imports.dart';

class LocationDetailSheet extends StatefulWidget {
  final Location location;
  final BuildContext scaffoldContext;

  LocationDetailSheet({
    Key key,
    @required this.location,
    @required this.scaffoldContext,
  }) : super(key: key);

  @override
  _LocationDetailSheetState createState() => _LocationDetailSheetState();
}

class _LocationDetailSheetState extends State<LocationDetailSheet> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedTime;
  List<TimeSlotData> data;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0)).then((_) => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: BlocListener<ModifyReservationBloc, ModifyReservationState>(
        condition: (_, newState) => newState is! ModifyReservationIdle,
        listener: (context, state) {
          if (state is CreateReservationFailure) {
            setState(() {
              loading = false;
            });
            showDialog<void>(
              context: context,
              builder: (BuildContext context) =>
                  _CreateReservationFailedDialog(),
            );
          } else if (state is CreateReservationSuccess) {
            // nothing to do, the modal is dismissed in the [_HomePage].
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              _LocationInformation(
                name: widget.location?.name ?? "",
                address: widget.location?.address ?? "",
              ),
              SizedBox(height: 20),
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
                title: (DateFormat.yMMMMd(
                        AppLocalizations.of(context).locale.languageCode))
                    .format(selectedDate),
                dateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                    data = null;
                  });
                  _fetchData();
                },
                selectedDate: selectedDate,
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
                      child: SizedBox(
                          width: 140,
                          height: 50,
                          child: AnimatedCrossFade(
                            crossFadeState: loading
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: 300),
                            firstChild: Center(
                              child: RaisedButton(
                                child: Text(AppLocalizations.of(context)
                                    .reserveSlotButtonTitle),
                                color: Color(0xFF00F2A9),
                                textColor: Color(0xFF322153),
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20),
                                    side: BorderSide(color: Color(0xFF00F2A9))),
                                onPressed: selectedTime == null
                                    ? null
                                    : () {
                                        if (!loading) {
                                          setState(() {
                                            loading = true;
                                          });

                                          BlocProvider.of<
                                                      ModifyReservationBloc>(
                                                  context)
                                              .add(
                                            CreateReservation(
                                              location: widget.location,
                                              startTime: selectedTime,
                                            ),
                                          );
                                        }
                                      },
                              ),
                            ),
                            secondChild: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ))))
            ],
          ),
        ),
      ),
    );
  }

  _fetchData() async {
    final timeSlotData =
        await Provider.of<LocationsRepository>(context, listen: false)
            .getLocationReservations(
      id: widget.location.id,
      startTime: selectedDate.isToday ? _minDateForToday : selectedDate,
    );
    if (mounted) {
      setState(() {
        data = timeSlotData;
      });
    }
  }

  /// Rounds to the next 10 minute step which is at least 1 minute in the future.
  DateTime get _minDateForToday {
    var minTime = DateTime.now().add(Duration(minutes: 2));
    minTime = minTime.add(Duration(minutes: 10 - minTime.minute));
    final millis =
        (minTime.millisecondsSinceEpoch / 1000 / 60).floor() * 1000 * 60;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }
}

class _ChangeDateButton extends StatelessWidget {
  final String title;
  final DateTime selectedDate;
  final ValueChanged<DateTime> dateChanged;

  const _ChangeDateButton({
    Key key,
    @required this.selectedDate,
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
          initialDate: this.selectedDate,
          firstDate: _DateTimeHelper.today,
          lastDate: _DateTimeHelper.today.add(Duration(days: 2)),
          builder: (BuildContext context, Widget child) => child,
        );
        DateTime date = await selectedDate;

        if (date != null) {
          dateChanged(date);
        }
      },
    );
  }
}

extension _DateTimeHelper on DateTime {
  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }
}

class _ReservationSlotsWithLoading extends StatelessWidget {
  final int slotSize;
  final List<TimeSlotData> data;
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
    } else if (data.isEmpty || slotSize == 0) {
      return Container(
        height: 200,
        child: Center(
          child: Text(
            AppLocalizations.of(context).locationSlotDateNotAvailable,
          ),
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
            height: 50,
            child: Image(
              image: AssetImage('assets/002-shop.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
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
                softWrap: true,
                maxLines: 3,
              ),
              Text(
                address ?? '',
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.left,
                softWrap: true,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CreateReservationFailedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).createReservationFailedDialogTitle,
      ),
      content: Text(
        AppLocalizations.of(context).createReservationFailedDialogDescription,
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context).commonOk),
        )
      ],
    );
  }
}
