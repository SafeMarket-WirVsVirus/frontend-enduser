import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/repository/data/data.dart';

import 'location.dart';

class Capacity_utilization {
  /// list of daily utilizations
  List<Daily_Utilization> daily_utilization = new List();

  /// general utilization
  double utilization = 0.0;

  Capacity_utilization();

  Daily_Utilization get_utilization_by_date(DateTime date) {
    for (int i = 0; i < daily_utilization.length; i++) {
      // compare if its the same date (time not important)
      if (date.day == daily_utilization[i].date.day &&
          date.month == daily_utilization[i].date.month &&
          date.year == daily_utilization[i].date.year) {
        return daily_utilization[i];
      }
    }
    return daily_utilization[daily_utilization.length - 1];
  }
}

class Daily_Utilization {
  /// Date of utilization data
  DateTime date;

  /// List with Timeslot data
  List<Timeslot_Data> timeslot_data = [];

  Daily_Utilization({@required this.date});

  BarChartData get_bar_data(int scrollIndexOffset, int datacount,
      BarChartGroupData cfg, int selectedIndex) {
    List<BarChartGroupData> data = new List();
    for (int i = scrollIndexOffset; i < timeslot_data.length; i++) {
      Timeslot_Data slot = timeslot_data[i];
      Color color;

      if (slot.utilization < 0.33) {
        if (i == selectedIndex) {
          color = Colors.green[100];
        } else {
          color = Color(0xFF00F2A9);
        }
      } else if (slot.utilization < 0.66) {
        if (i == selectedIndex) {
          color = Colors.orange[100];
        } else {
          color = Color(0xFFFEBE5F);
        }
      } else {
        if (i == selectedIndex) {
          color = Colors.red[100];
        } else {
          color = Color(0xFFFF5C66);
        }
      }

      data.add(cfg.copyWith(x: data.length, barRods: [
        cfg.barRods[0].copyWith(y: slot.utilization * 100, color: color)
      ]));
      if (data.length >= datacount) {
        return BarChartData(barGroups: data);
      }
    }
    return BarChartData(barGroups: data);
  }

  String get_bar_titles(double value, int scrollIndexOffset) {
    if (value.toInt() + scrollIndexOffset < timeslot_data.length) {
      Timeslot_Data slot = timeslot_data[value.toInt() + scrollIndexOffset];
      return (new DateFormat.Hm()).format(slot.startTime);
    }
    return "";
  }

  String get_tooltip_text(int selectedIndex) {
    String time = (DateFormat.Hm()).format(
        timeslot_data[selectedIndex].startTime) + " Uhr";
    int utilPercent = (timeslot_data[selectedIndex].utilization * 100).round();
    String utilization = "Auslastung: " + utilPercent.toString() + "%";
    return time + '\n' + utilization;
  }
}

class Timeslot_Data {
  /// Timeslot
  DateTime startTime;

  /// Number Of booked slots
  int bookings;

  /// Capacity utilization [0,1]
  double utilization;

  Timeslot_Data({
    @required this.startTime,
    @required this.bookings,
    @required this.utilization,
  });
}
