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
            _NavigationButton(
              navigationDirection: _NavigationDirection.backwards,
              onPressed: _navigate,
            ),
            _BarChartContainer(
              child: BarChart(widget.capacity_utilization
                  .get_utilization_by_date(widget.barplotDate)
                  .get_bar_data(
                      scrollIndexOffset, //startpoint
                      barsShown, // datacount
                      BarChartGroupData(
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
                    ),
                  )),
            ),
            _NavigationButton(
              navigationDirection: _NavigationDirection.forwards,
              onPressed: _navigate,
            ),
          ],
        ),
      ],
    );
  }

  _navigate(_NavigationDirection direction) {
    var newIndex = scrollIndexOffset;
    switch (direction) {
      case _NavigationDirection.backwards:
        if (scrollIndexOffset > 0) {
          newIndex -= 1;
        }
        break;
      case _NavigationDirection.forwards:
        final dataPoints = widget.capacity_utilization
            .get_utilization_by_date(widget.barplotDate)
            .timeslot_data
            .length;
        if (dataPoints - scrollIndexOffset > barsShown) {
          newIndex += 1;
        }
        break;
    }

    if (newIndex != scrollIndexOffset) {
      setState(() {
        scrollIndexOffset = newIndex;
      });
    }
  }
}

class _BarChartContainer extends StatelessWidget {
  final Widget child;

  const _BarChartContainer({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.grey[2000],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: child,
        ),
      ),
    );
  }
}

enum _NavigationDirection { forwards, backwards }

class _NavigationButton extends StatelessWidget {
  final _NavigationDirection navigationDirection;
  final ValueChanged<_NavigationDirection> onPressed;

  const _NavigationButton({
    Key key,
    @required this.navigationDirection,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 0.25,
      child: FlatButton(
          onPressed: () {
            onPressed(navigationDirection);
          },
          splashColor: Theme.of(context).accentColor,
          child: Icon(
            navigationDirection == _NavigationDirection.backwards
                ? Icons.arrow_back_ios
                : Icons.arrow_forward_ios,
          )),
    );
  }
}

// unused at the moment
class _ToolTipData extends BarTouchTooltipData {
  _ToolTipData(BuildContext context, DateTime startTime, double percent)
      : super(
            tooltipBgColor: Colors.greenAccent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String text = _formattedText(startTime, percent);
              return BarTooltipItem(
                  text, TextStyle(color: Theme.of(context).primaryColor));
            },
            fitInsideVertically: true,
            fitInsideHorizontally: true);

  static String _formattedText(DateTime startTime, double percent) {
    String time = (DateFormat.Hm()).format(startTime) + " Uhr";
    int utilPercent = (percent * 100).round();
    String utilization = "Auslastung: " + utilPercent.toString() + "%";
    return time + '\n' + utilization;
  }
}
