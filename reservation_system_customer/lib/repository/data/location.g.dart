// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) {
  return OpeningHours(
    openingDays: json['openingDays'] as String,
    openingTime: json['openingTime'] == null
        ? null
        : DateTime.parse(json['openingTime'] as String),
    closingTime: json['closingTime'] == null
        ? null
        : DateTime.parse(json['closingTime'] as String),
  );
}

Location _$LocationFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['longitude', 'latitude'],
      disallowNullValues: const ['longitude', 'latitude']);
  return Location(
    id: json['id'] as int,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    name: json['name'] as String,
    fillStatus: _fillStatusFromInt(json['fillStatus'] as int),
    slotDuration: json['slotDuration'] == null
        ? null
        : Duration(microseconds: json['slotDuration'] as int),
    address: json['address'] as String,
    openingHours: (json['openings'] as List)
        ?.map((e) =>
            e == null ? null : OpeningHours.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}
