import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:reservation_system_customer/repository/data/location.dart';

part 'reservations_response.g.dart';

@JsonSerializable(createToJson: false)
class ReservationsResponse {
  @JsonKey()
  final List<RawReservation> reservations;

  ReservationsResponse({
    @required this.reservations,
  });

  factory ReservationsResponse.fromJson(Map<String, dynamic> json) =>
      _$ReservationsResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class RawReservation {
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

  RawReservation({
    @required this.id,
    @required this.location,
    @required this.startTime,
    this.codeWords,
  });

  @override
  String toString() {
    return 'Reservation $id @$startTime';
  }

  factory RawReservation.fromJson(Map<String, dynamic> json) =>
      _$RawReservationFromJson(json);
}
