import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'capacity_utilization.dart';

class Location {
  /// The location id
  final String id;

  /// The GPS location
  final LatLng position;

  /// The user friendly location name
  final String name;

  final Capacity_utilization capacity_utilization = Capacity_utilization();

  void fetch_detailed_utilization() {
    //TODO: implement
  }

  void fetch_general_utilization() {
    // TODO: implement
  }

  Location({
    @required this.id,
    @required this.position,
    @required this.name,
  });
}
