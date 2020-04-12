import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../ui_imports.dart';

class MapMarker extends Clusterable {
  final String id;
  final LatLng position;
  final BitmapDescriptor icon;
  final bool consumeTapEvents;
  final VoidCallback onTap;

  MapMarker({
    this.consumeTapEvents,
    this.onTap,
    @required this.id,
    @required this.position,
    @required this.icon,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
          markerId: id,
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );

  Marker toMarker() => Marker(
      markerId: MarkerId(id),
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
      icon: icon,
      consumeTapEvents: consumeTapEvents,
      onTap: onTap);
}
