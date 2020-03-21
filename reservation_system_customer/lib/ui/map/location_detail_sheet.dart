import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:reservation_system_customer/repository/repository.dart';

class LocationDetailSheet extends StatelessWidget {
  final Location location;

  const LocationDetailSheet({
    Key key,
    @required this.location,
  }) : super(key: key);

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    location.name,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
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
                          //TODO: Implement backwards scroll
                        },
                        splashColor: Theme.of(context).accentColor,
                        child: Icon(Icons.arrow_back_ios)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: BarChart(location
                        .capacity_utilization.daily_utilization[0]
                        .get_bar_data(
                            DateTime.now(), //starttime
                            8, // datacount
                            BarChartGroupData(
                                // Config
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                      y: 0,
                                      width: 20,
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(5.0)))
                                ],
                                barsSpace: 5))
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
                                      return location.capacity_utilization
                                          .daily_utilization[0]
                                          .get_bar_titles(value);
                                    }),
                                leftTitles: SideTitles(showTitles: false)),
                            borderData: FlBorderData(show: false))),
                  ),
                  Center(
                    widthFactor: 0.25,
                    child: FlatButton(
                      splashColor: Theme.of(context).accentColor,
                      child: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        //TODO: Implement forward scroll
                      },
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: FlatButton(
                child: Text("Zeitfenster reswervieren"),
                onPressed: () {
                  // todo: reservierung implementieren
                },
              ),
            )
          ]),
    );
  }
}
