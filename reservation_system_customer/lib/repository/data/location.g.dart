// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    id: json['id'] as int,
    name: json['name'] as String,
    fillStatus: _fillStatusFromInt(json['fillStatus'] as int),
    slot_duration: json['slot_duration'] == null
        ? null
        : Duration(microseconds: json['slot_duration'] as int),
  );
}
