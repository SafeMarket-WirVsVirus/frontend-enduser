import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/repository/data/data.dart';
import 'package:reservation_system_customer/ui/map/map_marker.dart';

import '../../ui_imports.dart';

class MapCluster<T extends Clusterable> extends Fluster {
  final Map<FillStatus, BitmapDescriptor> clusterMarkers;
  var minZoom;
  var maxZoom;
  var radius;
  var extent;
  var nodeSize;

  MapCluster(
      {this.clusterMarkers,
      this.minZoom,
      this.maxZoom,
      this.radius,
      this.extent,
      this.nodeSize,
      points,
      createCluster})
      : super(
            minZoom: maxZoom,
            maxZoom: maxZoom,
            radius: radius,
            extent: extent,
            nodeSize: nodeSize,
            points: points,
            createCluster: createCluster);

  BitmapDescriptor getClusterMarker(int clusterId) {
    FillStatus fillStatus = FillStatus.green;

    for (MapMarker mapMarker in points(clusterId)) {
      if (mapMarker.fillStatus == FillStatus.yellow) {
        fillStatus = FillStatus.yellow;
      } else if (mapMarker.fillStatus == FillStatus.red) {
        fillStatus = FillStatus.red;
        break;
      }
    }

    return clusterMarkers[fillStatus];
  }
}
