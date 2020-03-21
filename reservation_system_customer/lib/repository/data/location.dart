import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  /// The location id
  final String id;

  /// The GPS location
  final LatLng position;

  /// The user friendly location name
  final String name;

  Location({
    @required this.id,
    @required this.position,
    @required this.name,
  });
}
