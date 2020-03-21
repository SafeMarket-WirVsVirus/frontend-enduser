import 'package:flutter/foundation.dart';
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
  /// The reservation id
  final String id;

  /// The GPS location of the reservation
  final LatLng location;

  /// The user friendly location name
  final String locationName;

  /// The reserved time slot
  final TimeSlot timeSlot;

  Reservation({
    @required this.id,
    @required this.location,
    @required this.locationName,
    @required this.timeSlot,
  });
}
