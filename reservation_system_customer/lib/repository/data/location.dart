import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'capacity_utilization.dart';

part 'location.g.dart';

enum FillStatus {
  green,
  yellow,
  red,
}

/// The order of the location type determines also the order in the filter dialog
enum LocationType {
  supermarket,
  bakery,
  pharmacy,
}

@JsonSerializable(createToJson: false)
class Location {
  /// The location id
  final int id;

  /// The GPS location
  @JsonKey(ignore: true)
  final LatLng position;

  /// The user friendly location name
  final String name;

  final String address_street;

  final String address_city;

  final Duration slot_duration;

  @JsonKey(ignore: true)
  final Capacity_utilization capacity_utilization;

  /// The fill status of a location
  @JsonKey(fromJson: _fillStatusFromInt)
  final FillStatus fillStatus;

  Location({
    @required this.id,
    @required this.position,
    @required this.name,
    @required this.fillStatus,
    @required this.slot_duration,
    @required this.capacity_utilization,
    @required this.address_street,
    @required this.address_city
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

FillStatus _fillStatusFromInt(int i) {
  switch (i) {
    case 0:
      return FillStatus.red;
    case 1:
      return FillStatus.yellow;
    case 2:
      return FillStatus.green;
  }
  return FillStatus.green;
}
