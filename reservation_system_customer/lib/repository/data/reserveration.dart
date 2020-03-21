import 'package:google_maps_flutter/google_maps_flutter.dart';

class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;

  TimeSlot({
    this.startTime,
    this.endTime,
  });
}

class Reservation {
  /// The GPS location of the reservation
  final LatLng location;

  /// The user friendly location name
  final String locationName;

  /// The reserved time slot
  final TimeSlot timeSlot;

  Reservation({
    this.location,
    this.locationName,
    this.timeSlot,
  });
}
