import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'location.dart';

part 'reservation.g.dart';

@JsonSerializable(createToJson: false)
class Reservation {
  /// The reservation id
  final int id;

  /// The location for which the reservation was made
  final Location location;

  /// The reserved time slot
  final DateTime startTime;

  /// List of codewords that serve as an alternative identifier to the qr-code
  /// TODO assign actual values when api support is added
  @JsonKey(ignore: true)
  final List<String> codeWords;

  Reservation({
    @required this.id,
    @required this.location,
    @required this.startTime,
    this.codeWords,
  });

  @override
  String toString() {
    return 'Reservation $id @$startTime';
  }

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
