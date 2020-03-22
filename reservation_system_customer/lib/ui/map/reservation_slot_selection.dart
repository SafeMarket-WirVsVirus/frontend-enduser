import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/repository/data/capacity_utilization.dart';

class ReservationSlotSelection extends StatefulWidget {
  final ValueChanged<DateTime> selectedSlotChanged;
  final List<Timeslot_Data> data;
  final int slotSize;

  const ReservationSlotSelection({
    Key key,
    @required this.selectedSlotChanged,
    @required this.data,
    @required this.slotSize,
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
              child: BarChart(getBarData(
                      widget.data,
                      scrollIndexOffset,
                      widget.slotSize,
                      barsShown,
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            y: 0,
                            width: 25,
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                          )
                        ],
                        barsSpace: 3,
                      ),
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
                        return getBarTitles(
                            widget.data, value, scrollIndexOffset);
                      }),
                  leftTitles: SideTitles(showTitles: false),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchCallback: (BarTouchResponse touchResponse) {
                    setState(() {
                      if (touchResponse.spot != null) {
                        selectedBarIndex =
                            touchResponse.spot.touchedBarGroupIndex +
                                scrollIndexOffset;
                        var date = widget.data[selectedBarIndex].startTime;
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
        final dataPoints = widget.data.length;
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

  BarChartData getBarData(
      List<Timeslot_Data> timeSlotData,
      int scrollIndexOffset,
      int slotSize,
      int dataCount,
      BarChartGroupData cfg,
      int selectedIndex) {
    List<BarChartGroupData> data = new List();
    for (int i = scrollIndexOffset; i < timeSlotData.length; i++) {
      Timeslot_Data slot = timeSlotData[i];
      Color color;
      final percentageBookings = slot.bookings / (slotSize * 1);

      if (percentageBookings < 0.33) {
        color = Color(0xFF00F2A9);
      } else if (percentageBookings < 0.66) {
        color = Color(0xFFFEBE5F);
      } else {
        color = Color(0xFFFF5C66);
      }
      if (i == selectedIndex) {
        color = color.withAlpha(100);
      }

      data.add(cfg.copyWith(x: data.length, barRods: [
        cfg.barRods[0].copyWith(y: percentageBookings * 100, color: color)
      ]));
      if (data.length >= dataCount) {
        return BarChartData(barGroups: data);
      }
    }
    return BarChartData(barGroups: data);
  }

  String getBarTitles(
      List<Timeslot_Data> data, double value, int scrollIndexOffset) {
    if (value.toInt() + scrollIndexOffset < data.length) {
      Timeslot_Data slot = data[value.toInt() + scrollIndexOffset];
      return (new DateFormat.Hm()).format(slot.startTime);
    }
    return "";
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
