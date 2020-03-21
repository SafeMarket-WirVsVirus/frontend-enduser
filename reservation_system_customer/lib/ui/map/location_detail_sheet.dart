import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/repository/repository.dart';

class LocationDetailSheet extends StatefulWidget {
  final Location location;
  DateTime barplotStartTime = DateTime.now();

  LocationDetailSheet({
    Key key,
    @required this.location,
  }) : super(key: key);

  @override
  _LocationDetailSheetState createState() => _LocationDetailSheetState();
}

class _LocationDetailSheetState extends State<LocationDetailSheet> {
  DateTime barplotStartTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 400,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                        (new DateFormat("dd'.' MMM yyyy"))
                            .format(barplotStartTime) +
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
                            if (barplotStartTime.isAfter(DateTime.now())) {
                              barplotStartTime = barplotStartTime
                                  .subtract(widget.location.slot_duration);
                            } else {
                              barplotStartTime = DateTime.now();
                            }
                          });
                        },
                        splashColor: Theme.of(context).accentColor,
                        child: Icon(Icons.arrow_back_ios)),
                  ),
                  BarChart(widget
                      .location.capacity_utilization.daily_utilization[0]
                      .get_bar_data(
                      barplotStartTime, //starttime
                      7, // datacount
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
                          barsSpace: 3))
                      .copyWith(
                      alignment: BarChartAlignment.spaceEvenly,
                      titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                              showTitles: true,
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                              getTitles: (double value) {
                                return widget.location.capacity_utilization
                                    .daily_utilization[0]
                                    .get_bar_titles(
                                    value, barplotStartTime);
                              }),
                          leftTitles: SideTitles(showTitles: false)),
                      borderData: FlBorderData(show: false))),
                  Center(
                    widthFactor: 0.25,
                    child: FlatButton(
                      splashColor: Theme.of(context).accentColor,
                      child: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        setState(() {
                          barplotStartTime = barplotStartTime
                              .add(widget.location.slot_duration);
                        });
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
                  textColor: Theme
                      .of(context)
                      .accentColor,
                  onPressed: () async {
                    Future<DateTime> selectedDate = showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child,
                        );
                      },
                    );
                    DateTime timepoint = await selectedDate;
                    setState(() {
                      barplotStartTime = timepoint;
                    });
                  },
                  child: Text("Anderes Datum auswählen",
                      style: Theme
                          .of(context)
                          .textTheme
                          .caption),
                )
              ],
            ),
            Center(
              child: RaisedButton(
                child: Text("Slot reservieren"),
                onPressed: () {
                  // todo: reservierung implementieren
                },
              ),
            )
          ]),
    );
  }
}
