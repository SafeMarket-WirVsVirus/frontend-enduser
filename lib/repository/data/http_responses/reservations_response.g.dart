// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservations_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationsResponse _$ReservationsResponseFromJson(Map<String, dynamic> json) {
  return ReservationsResponse(
    reservations: (json['reservations'] as List)
        ?.map((e) => e == null
            ? null
            : RawReservation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

RawReservation _$RawReservationFromJson(Map<String, dynamic> json) {
  return RawReservation(
    id: json['id'] as int,
    location: json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    startTime: json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String),
  );
}
