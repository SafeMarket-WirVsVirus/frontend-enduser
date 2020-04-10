// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationLocation _$ReservationLocationFromJson(Map<String, dynamic> json) {
  return ReservationLocation(
    id: json['id'] as int,
    name: json['name'] as String,
    address: json['address'] as String,
  );
}

Map<String, dynamic> _$ReservationLocationToJson(
        ReservationLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
    };

Reservation _$ReservationFromJson(Map<String, dynamic> json) {
  return Reservation(
    id: json['id'] as int,
    location: json['location'] == null
        ? null
        : ReservationLocation.fromJson(
            json['location'] as Map<String, dynamic>),
    startTime: json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String),
    codeWords: (json['codeWords'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'startTime': instance.startTime?.toIso8601String(),
      'codeWords': instance.codeWords,
    };
