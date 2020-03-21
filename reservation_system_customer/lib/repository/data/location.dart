import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  /// The location id
  final String id;

  /// The GPS location
  final LatLng location;

  /// The user friendly location name
  final String locationName;

  Location({
    @required this.id,
    @required this.location,
    @required this.locationName,
  });
}
