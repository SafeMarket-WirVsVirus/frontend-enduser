import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:reservation_system_customer/repository/data/data.dart';

import 'location.dart';

class Capacity_utilization {
  /// the location
  final Location location;

  /// list of daily utilizations
  final List<Daily_Utilization> daily_utilization = new List();

  /// general utilization
  final Float utilization = 0.0 as Float;

  Capacity_utilization({@required this.location});

  void fetch_detailed_utilization() {
    //TODO: implement
  }

  void fetch_general_utilization() {
    // TODO: implement
  }
}

class Daily_Utilization {
  /// Date of utilization data
  final DateTime date;

  /// List with Timeslot data
  final List<Timeslot_Data> timeslots = new List();

  Daily_Utilization({@required this.date});
}

class Timeslot_Data {
  /// Timeslot
  final TimeSlot timeslot;

  /// Number Of booked slots
  final int bookings;

  /// Capacity utilization [0,1]
  final Float utilization;

  Timeslot_Data({
    @required this.timeslot,
    @required this.bookings,
    @required this.utilization,
  });
}
