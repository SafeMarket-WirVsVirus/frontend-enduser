import 'package:json_annotation/json_annotation.dart';

import 'location.dart';

part 'locations.g.dart';

@JsonSerializable(createToJson: false)
class Locations {
  final List<Location> locations;

  Locations(this.locations);

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
}
