import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

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
class OpeningHours {
  final String openingDays;

  final DateTime openingTime;

  final DateTime closingTime;

  OpeningHours({
    @required this.openingDays,
    @required this.openingTime,
    @required this.closingTime,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);
}

@JsonSerializable(createToJson: false)
class Location {
  /// The location id
  final int id;

  /// The GPS location
  LatLng get position => LatLng(latitude, longitude);

  @JsonKey(required: true, disallowNullValue: true)
  final double longitude;
  @JsonKey(required: true, disallowNullValue: true)
  final double latitude;

  /// The user friendly location name
  final String name;

  @JsonKey(name: 'openings')
  final List<OpeningHours> openingHours;

  final String address;

  /// Amount of persons who are allowed to enter the location per slot
  final int slotSize;

  final Duration slotDuration;

  /// The fill status of a location
  @JsonKey(fromJson: _fillStatusFromInt)
  final FillStatus fillStatus;

  @JsonKey(ignore: true)
  LocationType locationType;

  Location({
    @required this.id,
    @required this.latitude,
    @required this.longitude,
    @required this.name,
    @required this.fillStatus,
    @required this.slotSize,
    @required this.slotDuration,
    @required this.address,
    @required this.openingHours,
    this.locationType,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  @override
  String toString() {
    return 'Location $id';
  }
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
