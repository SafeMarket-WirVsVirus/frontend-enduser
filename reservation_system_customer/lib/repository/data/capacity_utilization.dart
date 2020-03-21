import 'dart:ffi';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/repository/data/data.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'location.dart';

class Capacity_utilization {
  /// list of daily utilizations
  List<Daily_Utilization> daily_utilization = new List();

  /// general utilization
  double utilization = 0.0;

  Capacity_utilization();
}

class Daily_Utilization {
  /// Date of utilization data
  DateTime date;

  /// List with Timeslot data
  List<Timeslot_Data> timeslot_data = [];

  Daily_Utilization({@required this.date});

  BarChartData get_bar_data(DateTime startTime, int datacount,
      BarChartGroupData cfg) {
    List<BarChartGroupData> data = new List();
    for (int i = 0; i < timeslot_data.length; i++) {
      Timeslot_Data slot = timeslot_data[i];
      if (slot.startTime.isAfter(startTime)) {
        data.add(cfg.copyWith(
            x: data.length,
            barRods: [cfg.barRods[0].copyWith(y: slot.utilization * 100)]));
        if (data.length >= datacount) {
          return BarChartData(barGroups: data);
        }
      }
    }
    return BarChartData(barGroups: data);
  }

  String get_bar_titles(double value, DateTime startTime) {
    int start;
    for (int i = 0; i < timeslot_data.length; i++) {
      Timeslot_Data slot = timeslot_data[i];
      if (slot.startTime.isAfter(startTime)) {
        start = i;
        break;
      }
    }
    if (value.toInt() + start < timeslot_data.length) {
      Timeslot_Data slot = timeslot_data[value.toInt() + start];
      return (new DateFormat.Hm()).format(slot.startTime);
    }
    return "";
  }
}

class Timeslot_Data {
  /// Start Time
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
