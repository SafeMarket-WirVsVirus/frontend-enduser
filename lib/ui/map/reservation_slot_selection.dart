import 'package:fl_chart/fl_chart.dart';
import 'package:reservation_system_customer/ui_imports.dart';

class ReservationSlotSelection extends StatefulWidget {
  final ValueChanged<DateTime> selectedSlotChanged;
  final List<TimeSlotData> data;
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
  final int barsShown = 1000;
  int selectedBarIndex;

  @override
  Widget build(BuildContext context) {
    // TODO: this is hacky as shit. There HAS to be a better way but it works for now
    double chartWidth = widget.data.length * 35.0 + 40.0;
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 200,
          width: chartWidth,
          child: _BarChartContainer(
            child: BarChart(getBarData(
                    widget.data,
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
                            backDrawRodData: BackgroundBarChartRodData(
                                show: true, y: 100, color: Colors.grey[200]))
                      ],
                    ),
                    selectedBarIndex)
                .copyWith(
              maxY: 100,
              groupsSpace: 10,
              alignment: BarChartAlignment.center,
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
                          widget.data, value);
                    }),
                leftTitles: SideTitles(showTitles: false),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchExtraThreshold: EdgeInsets.symmetric(vertical: 20),
                allowTouchBarBackDraw: true,
                handleBuiltInTouches: false,
                touchCallback: (BarTouchResponse touchResponse) {
                  setState(() {
                    if (touchResponse.spot != null) {
                      bool slotIsFull = widget.data[touchResponse.spot.touchedBarGroupIndex].registrationCount >= widget.slotSize;
                      if (!slotIsFull) {
                        selectedBarIndex =
                            touchResponse.spot.touchedBarGroupIndex;
                        var date = widget.data[selectedBarIndex].start;
                        debug('$selectedBarIndex $date');
                        widget.selectedSlotChanged(date);
                      }
                    }
                  });
                },
              ),
            )),
          ),
        ),
      ),
    );
  }

  BarChartData getBarData(
      List<TimeSlotData> timeSlotData,
      int slotSize,
      int dataCount,
      BarChartGroupData cfg,
      int selectedIndex) {
    List<BarChartGroupData> data = new List();
    for (int i = 0; i < timeSlotData.length; i++) {
      TimeSlotData slot = timeSlotData[i];
      Color color;
      final percentageBookings = (i == selectedIndex
              ? slot.registrationCount + 1
              : slot.registrationCount) /
          (slotSize * 1);

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
        cfg.barRods[0].copyWith(y: 30 + percentageBookings * 70, color: color)
      ]));
      if (data.length >= dataCount) {
        return BarChartData(barGroups: data);
      }
    }
    return BarChartData(barGroups: data);
  }

  String getBarTitles(
      List<TimeSlotData> data, double value) {
    if (value.toInt()  < data.length) {
      TimeSlotData slot = data[value.toInt()];
      return (new DateFormat.Hm()).format(slot.start);
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
