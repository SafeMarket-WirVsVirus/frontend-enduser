import 'dart:async';

import 'package:fluster/fluster.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui/map/map_chips.dart';
import 'package:reservation_system_customer/ui/map/map_cluster.dart';
import 'package:reservation_system_customer/ui_imports.dart';

import 'map_marker.dart';

class MapView extends StatefulWidget {
  final List<MapMarker> markers;

  const MapView({
    Key key,
    this.markers,
  }) : super(key: key);

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  final positionTimeout = Duration(seconds: 3);
  final defaultPosition = LatLng(48.160490, 11.555184);
  LatLng userPosition;
  CameraPosition lastFetchCameraPosition;
  CameraPosition currentCameraPosition;
  StreamSubscription<Position> positionStream;
  double currentZoom = 15;

  //cluster variables
  MapCluster<MapMarker> clusterController;
  final int minZoom = 0;
  final int maxZoom = 18;

  LocationType selectedType = LocationType.supermarket;

  @override
  void dispose() {
    super.dispose();
    positionStream?.cancel();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    positionStream = Geolocator()
        .getPositionStream(locationOptions)
        .listen((Position position) {
      debug("user moved to new location ${position.toString()}");
      userPosition = LatLng(position.latitude, position.longitude);
      Provider.of<UserRepository>(context, listen: false)
          .setUserPosition(userPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    userPosition =
        Provider.of<UserRepository>(context, listen: false).userPosition ??
            defaultPosition;
    debug('Building map with ${widget.markers.length} marker(s)');

    clusterController = MapCluster<MapMarker>(
      clusterMarkers: BlocProvider.of<MapBloc>(context).clusterMarkers,

      // Any zoom value below minZoom will not generate clusters.
      minZoom: minZoom,
      // Any zoom value above maxZoom will not generate clusters.
      maxZoom: maxZoom,
      // Cluster radius in pixels.
      radius: 200,
      // Adjust the extent by powers of 2 (e.g. 512. 1024, ... max 8192) to get the
      // desired distance between markers where they start to cluster.
      extent: 2048,
      // The size of the KD-tree leaf node, which affects performance.
      nodeSize: 64,
      // The List to be clustered.
      points: widget.markers,
      // A callback to generate clusters of the given input type.
      createCluster: (
        // Create cluster marker
        BaseCluster cluster,
        double lng,
        double lat,
      ) =>
          MapMarker(
              id: cluster.id.toString(),
              position: LatLng(lat, lng),
              icon: clusterController.getClusterMarker(cluster.id),
              isCluster: cluster.isCluster,
              clusterId: cluster.id,
              pointsSize: cluster.pointsSize,
              childMarkerId: cluster.childMarkerId,
              onTap: () {
                double zoom = currentZoom + 2;
                if (zoom <= 20) {
                  _moveCameraToNewPosition(LatLng(lat, lng), zoom: zoom);
                }
              }),
    );

    final List<Marker> clusteredMarkers = clusterController
        .clusters([-180, -85, 180, 85], currentZoom.toInt())
        .map((cluster) => (cluster as MapMarker).toMarker())
        .toList();

    return Scaffold(
        body: Stack(
          children: <Widget>[
              GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  userPosition.latitude,
                  userPosition.longitude,
                ),
                zoom: currentZoom,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                rootBundle.loadString('assets/map_style.json').then((style) {
                  controller.setMapStyle(style);
                });

                _fetchLocations(context, controller);
              },
              onCameraMove: (position) {
                currentCameraPosition = position;

                if ((currentZoom - position.zoom).abs() > 0.5) {
                  setState(() {
                    currentZoom = position.zoom;
                  });
                }
              },
              onCameraIdle: () async {
                if (!mounted) {
                  return;
                }
                if (currentCameraPosition == null ||
                    currentCameraPosition.target == null ||
                    BlocProvider.of<MapBloc>(context).state is MapLoading) {
                  return;
                }

                _fetchLocationsIfNeeded(currentCameraPosition);
              },
              markers: Set<Marker>.of(clusteredMarkers),
            ),


//            Try out chips
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: MapChips(mapBloc: BlocProvider.of<MapBloc>(context),)
              ),
            )
          ]
        ),


        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "locationFab",
              onPressed: () => _moveCameraToNewPosition(userPosition),
              child: Icon(Icons.gps_fixed),
              backgroundColor: Theme.of(context).accentColor,
            ),
          ],
        ));
  }

  void _moveCameraToNewPosition(LatLng position, {double zoom = 15.0}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom)));
  }

  _fetchLocations(BuildContext context, GoogleMapController controller) async {
    if (BlocProvider.of<MapBloc>(context).state is MapLocationsLoaded) {
      return;
    }

    LatLng location = await _getUserPosition();
    if (!mounted) {
      return;
    }
    if (location != null) {
      userPosition = location;
      Provider.of<UserRepository>(context, listen: false)
          .setUserPosition(userPosition);
      _moveCameraToNewPosition(userPosition);
    }

    final zoomLevel = await controller.getZoomLevel();
    final position =
        CameraPosition(target: location ?? defaultPosition, zoom: zoomLevel);
    _fetchLocationsIfNeeded(position);
  }

  Future<void> _fetchLocationsIfNeeded(CameraPosition newPos) async {
    final radius = await _getRadius();

    if (lastFetchCameraPosition != null) {
      double zoomLevel = newPos.zoom;
      if (zoomLevel <= 12) {
        debug('Not updating locations, zoomLevel <= 12: $zoomLevel');
        return;
      }

      final distance =
          await _getDistance(newPos.target, lastFetchCameraPosition.target);
      debug('Distance: $distance, radius: $radius, zoomLevel: $zoomLevel');

      if (distance < radius * 1) {
        debug('Not updating locations, distance < radius');
        return;
      }
    }

    if (!mounted) {
      return;
    }
    debug('Fetching Updates for $newPos and $radius');
    lastFetchCameraPosition = newPos;
    BlocProvider.of<MapBloc>(context).add(MapLoadLocations(
        position: lastFetchCameraPosition.target, radius: radius));
  }

  Future<LatLng> _getUserPosition() async {
    LatLng location;

    try {
      Position position =
          await Geolocator().getCurrentPosition().timeout(positionTimeout);
      if (position != null) {
        return LatLng(position.latitude, position.longitude);
      }
    } catch (_) {
      try {
        Position position =
            await Geolocator().getLastKnownPosition().timeout(positionTimeout);
        if (position != null) {
          return LatLng(position.latitude, position.longitude);
        }
      } catch (_) {}
    }
    return location;
  }

  Future<double> _getDistance(LatLng pos1, LatLng pos2) async {
    final distance = await Geolocator().distanceBetween(
      pos1.latitude,
      pos1.longitude,
      pos2.latitude,
      pos2.longitude,
    );
    return distance;
  }

  Future<int> _getRadius() async {
    final GoogleMapController controller = await _controller.future;
    final region = await controller.getVisibleRegion();
    final distance = await _getDistance(region.northeast, region.southwest);
    return (distance / 2.0).floor();
  }
}

