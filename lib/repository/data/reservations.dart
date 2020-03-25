import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:reservation_system_customer/repository/data/reservation.dart';

part 'reservations.g.dart';

@JsonSerializable(createToJson: false)
class Reservations {
  @JsonKey()
  final List<Reservation> reservations;

  Reservations({
    @required this.reservations,
  });

  factory Reservations.fromJson(Map<String, dynamic> json) =>
      _$ReservationsFromJson(json);
}
