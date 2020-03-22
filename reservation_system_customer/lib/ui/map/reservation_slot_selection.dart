import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/repository/data/capacity_utilization.dart';

class ReservationSlotSelection extends StatefulWidget {
  final Capacity_utilization capacity_utilization;
  final DateTime barplotDate;
  final ValueChanged<DateTime> selectedSlotChanged;

  const ReservationSlotSelection({
    Key key,
    @required this.capacity_utilization,
    @required this.barplotDate,
    @required this.selectedSlotChanged,
  }) : super(key: key);

  @override
  _ReservationSlotSelectionState createState() =>
      _ReservationSlotSelectionState();
}

class _ReservationSlotSelectionState extends State<ReservationSlotSelection> {
  final int barsShown = 7;
  int scrollIndexOffset = 0;
  int selectedBarIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
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
            Container(
              height: 200,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Colors.grey[2000],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BarChart(widget.capacity_utilization
                      .get_utilization_by_date(widget.barplotDate)
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
                                fontSize: 10,
                                color: Colors.black),
                            getTitles: (double value) {
                              return widget.capacity_utilization
                                  .get_utilization_by_date(widget.barplotDate)
                                  .get_bar_titles(value, scrollIndexOffset);
                            }),
                        leftTitles: SideTitles(showTitles: false)),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(
                        touchCallback: (BarTouchResponse touchResponse) {
                          setState(() {
                            if (touchResponse.spot != null) {
                              selectedBarIndex =
                                  touchResponse.spot.touchedBarGroupIndex +
                                      scrollIndexOffset;
                              var date = widget.capacity_utilization
                                  .get_utilization_by_date(widget.barplotDate)
                                  .timeslot_data[selectedBarIndex]
                                  .startTime;
                              print('$selectedBarIndex $date');
                              widget.selectedSlotChanged(date);
                            }
                          });
                        },
                        touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.greenAccent,
                            getTooltipItem:
                                (group, groupIndex, rod, rodIndex) {
                              String text = widget.capacity_utilization
                                  .get_utilization_by_date(widget.barplotDate)
                                  .get_tooltip_text(selectedBarIndex);
                              return BarTooltipItem(
                                  text,
                                  TextStyle(
                                      color: Theme
                                          .of(context)
                                          .primaryColor));
                            },
                            fitInsideVertically: true,
                            fitInsideHorizontally: true)),
                  )),
                ),
              ),
            ),
            Center(
              widthFactor: 0.25,
              child: FlatButton(
                splashColor: Theme.of(context).accentColor,
                child: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  int datapoints = widget.capacity_utilization
                      .get_utilization_by_date(widget.barplotDate)
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
      ],
    );
  }
}
