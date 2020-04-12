import 'dart:async';

import 'package:fluster/fluster.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui/map/filter_dialog.dart';
import 'package:reservation_system_customer/ui/map/filter_settings_theme.dart';
import 'package:reservation_system_customer/ui_imports.dart';

import 'map_marker.dart';

class MapView extends StatefulWidget {
  final List<MapMarker> markers;
  final int minZoom = 0;
  final int maxZoom = 20;

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

  Map<MarkerId, MapMarker> _markerMap = {};

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
      print("user moved to new location ${position.toString()}");
      userPosition = LatLng(position.latitude, position.longitude);
      Provider.of<UserRepository>(context, listen: false)
          .setUserPosition(userPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    //only add the new markers
    widget.markers.forEach((item) {
      if (!_markerMap.containsKey(MarkerId(item.id))) {
        _markerMap[MarkerId(item.id)] = item;
      }
    });

    userPosition =
        Provider.of<UserRepository>(context, listen: false).userPosition ??
            defaultPosition;
    print('Building map with ${widget.markers.length} marker(s)');

    final clusterController = Fluster<MapMarker>(
      minZoom: widget.minZoom,
      // The min zoom at clusters will show
      maxZoom: widget.maxZoom,
      // The max zoom at clusters will show
      radius: 150,
      // Cluster radius in pixels
      extent: 2048,
      // Tile extent. Radius is calculated with it.
      nodeSize: 64,
      // Size of the KD-tree leaf node.
      points: _markerMap.values.toList(),
      // The list of markers created before
      createCluster: (
        // Create cluster marker
        BaseCluster cluster,
        double lng,
        double lat,
      ) =>
          MapMarker(
        id: cluster.id.toString(),
        position: LatLng(lat, lng),
        icon: BlocProvider.of<MapBloc>(context).clusterMarkers[0],
        isCluster: true,
        clusterId: cluster.id,
        pointsSize: cluster.pointsSize,
        childMarkerId: cluster.childMarkerId,
      ),
    );

    final List<Marker> googleMarkers = clusterController
        .clusters([-180, -85, 180, 85], currentZoom.toInt())
        .map((cluster) => cluster.toMarker())
        .toList();

    return Scaffold(
        body: GoogleMap(
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
            if (currentCameraPosition == null ||
                currentCameraPosition.target == null ||
                BlocProvider.of<MapBloc>(context).state is MapLoading) {
              return;
            }

            _fetchLocationsIfNeeded(currentCameraPosition);
          },
          markers: Set<Marker>.of(googleMarkers),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BlocBuilder<MapBloc, MapState>(builder: (context, state) {
              return FloatingActionButton(
                mini: true,
                onPressed: _setFilters,
                child: Icon(state.filterSettings?.locationType?.icon(context) ??
                    Icons.filter_list),
                backgroundColor: Theme.of(context).accentColor,
              );
            }),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () => _moveCameraToNewPosition(userPosition),
              child: Icon(Icons.gps_fixed),
              backgroundColor: Theme.of(context).accentColor,
            ),
          ],
        ));
  }

  void _setFilters() {
    showDialog(
        context: context,
        builder: (newContext) => FilterDialog(
              mapBloc: BlocProvider.of<MapBloc>(context),
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
        print('Not updating locations, zoomLevel <= 12: $zoomLevel');
        return;
      }

      final distance =
          await _getDistance(newPos.target, lastFetchCameraPosition.target);
      print('Distance: $distance, radius: $radius, zoomLevel: $zoomLevel');

      if (distance < radius * 1) {
        print('Not updating locations, distance < radius');
        return;
      }
    }

    if (!mounted) {
      return;
    }
    print('Fetching Updates for $newPos and $radius');
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
