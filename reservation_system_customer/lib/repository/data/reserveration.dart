import 'package:flutter/foundation.dart';
import 'location.dart';

class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;

  TimeSlot({
    this.startTime,
    this.endTime,
  });
}

class Reservation {
  /// The reservation id
  final String id;

  /// The location for which the reservation was made
  final Location location;

  /// The reserved time slot
  final TimeSlot timeSlot;

  Reservation({
    @required this.id,
    @required this.location,
    @required this.timeSlot,
  });
}
