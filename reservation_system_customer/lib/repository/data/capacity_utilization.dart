import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:reservation_system_customer/repository/data/data.dart';

import 'location.dart';

class Capacity_utilization {
  /// list of daily utilizations
  final List<Daily_Utilization> daily_utilization = new List();

  /// general utilization
  final Float utilization = 0.0 as Float;

  Capacity_utilization();
}

class Daily_Utilization {
  /// Date of utilization data
  final DateTime date;

  /// List with Timeslot data
  final List<Timeslot_Data> timeslot_data = new List();

  Daily_Utilization({@required this.date});

  BarChartData get_bar_data(DateTime startTime, int datacount) {
    for (var slot in timeslot_data) {
      List<BarChartGroupData> data = new List();
      if (slot.timeslot.startTime.isBefore(startTime)) {
        data.add(BarChartGroupData(
            x: data.length, barRods: [BarChartRodData(y: slot.utilization)]));
        if (data.length > datacount) {
          return BarChartData(barGroups: data);
        }
      }
    }
  }
}

class Timeslot_Data {
  /// Timeslot
  final TimeSlot timeslot;

  /// Number Of booked slots
  final int bookings;

  /// Capacity utilization [0,1]
  final double utilization;

  Timeslot_Data({
    @required this.timeslot,
    @required this.bookings,
    @required this.utilization,
  });
}
