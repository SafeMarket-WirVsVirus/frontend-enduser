// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationsResponse _$LocationsResponseFromJson(Map<String, dynamic> json) {
  return LocationsResponse(
    (json['locations'] as List)
        ?.map((e) =>
            e == null ? null : Location.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}
