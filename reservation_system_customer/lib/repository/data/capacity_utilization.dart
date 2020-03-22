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
}

class Timeslot_Data {
  /// Timeslot
  DateTime startTime;

  /// Number Of booked slots
  int bookings;

  Timeslot_Data({
    @required this.startTime,
    @required this.bookings,
  });
}
