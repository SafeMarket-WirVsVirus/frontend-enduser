import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:reservation_system_customer/repository/data/http_responses/reservations_response.dart';
import 'location.dart';

part 'reservation.g.dart';

@JsonSerializable()
class ReservationLocation {
  /// The location id
  final int id;

  /// The user friendly location name
  final String name;

  /// The user friendly location address
  final String address;

  const ReservationLocation({
    @required this.id,
    @required this.name,
    @required this.address,
  });

  factory ReservationLocation.fromJson(Map<String, dynamic> json) =>
      _$ReservationLocationFromJson(json);

  factory ReservationLocation.fromLocation(Location location) =>
      ReservationLocation(
        id: location?.id,
        name: location?.name,
        address: location?.address,
      );

  Map<String, dynamic> toJson() => _$ReservationLocationToJson(this);
}

@JsonSerializable()
class Reservation extends Equatable {
  /// The reservation id
  final int id;

  /// The location for which the reservation was made
  final ReservationLocation location;

  /// The reserved time slot
  final DateTime startTime;

  /// List of codewords that serve as an alternative identifier to the qr-code
  final List<String> codeWords;

  /// The id of the scheduled notification or null
  final int reminderNotificationId;

  Reservation({
    @required this.id,
    @required this.location,
    @required this.startTime,
    @required this.codeWords,
    @required this.reminderNotificationId,
  });

  factory Reservation.fromRawReservation(RawReservation reservation) =>
      Reservation(
        id: reservation.id,
        location: ReservationLocation.fromLocation(reservation.location),
        startTime: reservation.startTime,
        codeWords: reservation.codeWords ?? [],
        reminderNotificationId: null,
      );

  factory Reservation.withUpdatedNotificationId(
    Reservation reservation,
    int reminderNotificationId,
  ) =>
      Reservation(
        id: reservation.id,
        location: reservation.location,
        startTime: reservation.startTime,
        codeWords: reservation.codeWords,
        reminderNotificationId: reminderNotificationId,
      );

  factory Reservation.withUpdatedLocation(
    Reservation reservation,
    ReservationLocation location,
  ) =>
      Reservation(
        id: reservation.id,
        location: location,
        startTime: reservation.startTime,
        codeWords: reservation.codeWords,
        reminderNotificationId: reservation.reminderNotificationId,
      );

  factory Reservation.withLocalData(
    Reservation reservation,
    ReservationLocation location,
    int reminderNotificationId,
  ) =>
      Reservation(
        id: reservation.id,
        location: location,
        startTime: reservation.startTime,
        codeWords: reservation.codeWords,
        reminderNotificationId: reminderNotificationId,
      );

  @override
  String toString() {
    return 'Reservation $id @$startTime, reminderId: $reminderNotificationId, location: ${location?.id}';
  }

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);

  @override
  List<Object> get props => [id, reminderNotificationId, location?.id];
}
