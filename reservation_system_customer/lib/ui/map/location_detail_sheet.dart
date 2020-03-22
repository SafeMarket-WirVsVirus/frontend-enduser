import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'reservation_confirmation_dialog.dart';

class LocationDetailSheet extends StatefulWidget {
  final Location location;
  DateTime barplotDate = DateTime.now();

  LocationDetailSheet({
    Key key,
    @required this.location,
  }) : super(key: key);

  @override
  _LocationDetailSheetState createState() => _LocationDetailSheetState();
}

class _LocationDetailSheetState extends State<LocationDetailSheet> {
  DateTime barplotDate = DateTime.now();
  int selectedBarIndex = -1;
  int scrollIndexOffset = 0;
  int barsShown = 7;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.location.name,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text("Optionen auswählen (" +
                        (new DateFormat("dd'.' MMM yyyy")).format(barplotDate) +
                        ")"),
                  ),
                )
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    widthFactor: 0.25,
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            if (scrollIndexOffset > 0) {
                              scrollIndexOffset -= 1;
                            }
                          });
                        },
                        splashColor: Theme.of(context).accentColor,
                        child: Icon(Icons.arrow_back_ios)),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    color: Colors.grey[2000],
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: BarChart(widget.location.capacity_utilization
                          .get_utilization_by_date(barplotDate)
                          .get_bar_data(
                          scrollIndexOffset, //startpoint
                          barsShown, // datacount
                          BarChartGroupData(
                            // Config
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                    y: 0,
                                    width: 25,
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0)))
                              ],
                              barsSpace: 3),
                          selectedBarIndex)
                          .copyWith(
                        maxY: 100,
                        alignment: BarChartAlignment.spaceEvenly,
                        titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: SideTitles(
                                showTitles: true,
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                                getTitles: (double value) {
                                  return widget
                                      .location.capacity_utilization
                                      .get_utilization_by_date(barplotDate)
                                      .get_bar_titles(
                                      value, scrollIndexOffset);
                                }),
                            leftTitles: SideTitles(showTitles: false)),
                        borderData: FlBorderData(show: false),
                        barTouchData: BarTouchData(
                            touchCallback:
                                (BarTouchResponse touchResponse) {
                              setState(() {
                                if (touchResponse.spot != null) {
                                  selectedBarIndex = touchResponse
                                      .spot.touchedBarGroupIndex +
                                      scrollIndexOffset;
                                  print(selectedBarIndex);
                                }
                              });
                            },
                            touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Colors.greenAccent,
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  String text = widget
                                      .location.capacity_utilization
                                      .get_utilization_by_date(barplotDate)
                                      .get_tooltip_text(selectedBarIndex);
                                  return BarTooltipItem(
                                      text,
                                      TextStyle(
                                          color: Theme
                                              .of(context)
                                              .primaryColor));
                                })),
                      )),
                    ),
                  ),
                  Center(
                    widthFactor: 0.25,
                    child: FlatButton(
                      splashColor: Theme.of(context).accentColor,
                      child: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        int datapoints = widget.location.capacity_utilization
                            .get_utilization_by_date(barplotDate)
                            .timeslot_data
                            .length;
                        if (datapoints - scrollIndexOffset > barsShown) {
                          setState(() {
                            scrollIndexOffset += 1;
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
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
                      startTime: widget.location.capacity_utilization
                          .get_utilization_by_date(barplotDate)
                          .timeslot_data[selectedBarIndex]
                          .startTime,
                    ));
                    return showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return ReservationConfirmationDialog(
                            widget.location.name,
                            widget.location.capacity_utilization
                                .get_utilization_by_date(barplotDate)
                                .timeslot_data[selectedBarIndex]
                                .startTime);
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
