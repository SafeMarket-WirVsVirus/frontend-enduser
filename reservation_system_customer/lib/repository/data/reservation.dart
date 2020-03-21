import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'location.dart';

part 'reservation.g.dart';

@JsonSerializable(createToJson: false)
class Reservation {
  /// The reservation id
  final String id;

  /// The location for which the reservation was made
  final Location location;

  /// The reserved time slot
  final DateTime startTime;

  Reservation({
    @required this.id,
    @required this.location,
    @required this.startTime,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
