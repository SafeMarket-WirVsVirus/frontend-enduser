import 'package:json_annotation/json_annotation.dart';
import 'package:reservation_system_customer/repository/data/location.dart';

part 'locations_response.g.dart';

@JsonSerializable(createToJson: false)
class LocationsResponse {
  final List<Location> locations;

  LocationsResponse(this.locations);

  factory LocationsResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationsResponseFromJson(json);
}
