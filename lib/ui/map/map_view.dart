import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMaps
    show LatLng;
import 'package:latlong/latlong.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui/map/filter_dialog.dart';

class MapView extends StatefulWidget {
  final List<Marker> markers;

  const MapView({
    Key key,
    this.markers,
  }) : super(key: key);

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  MapController mapController;
  final positionTimeout = Duration(seconds: 3);
  final defaultPosition = LatLng(48.160490, 11.555184);
  LatLng userPosition;
  CameraPosition lastFetchCameraPosition;
  CameraPosition currentCameraPosition;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    Future.delayed(Duration(seconds: 1)).then((_) => _fetchLocations(context));
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    userPosition =
        Provider.of<UserRepository>(context, listen: false).userPosition ??
            defaultPosition;
    print('Build with marker ${widget.markers.length}');
    return Scaffold(
        body: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            FlutterMap(
              options: MapOptions(
                center: userPosition,
                zoom: 15.0,
              ),
              mapController: mapController,
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: widget.markers),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Container(
                padding: EdgeInsets.all(2),
                color: Colors.white,
                child: Text(
                  '© OpenStreetMap contributors',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            )
          ],
        ),

//        GoogleMap(
//          myLocationButtonEnabled: false,
//          myLocationEnabled: true,
//          mapType: MapType.normal,
//          initialCameraPosition: CameraPosition(
//            target: LatLng(
//              userPosition.latitude,
//              userPosition.longitude,
//            ),
//            zoom: 15,
//          ),
//          onMapCreated: (GoogleMapController controller) {
//            _controller.complete(controller);
//            _fetchLocations(context, controller);
//          },
//          onCameraMove: (position) {
//            currentCameraPosition = position;
//          },
//          onCameraIdle: () async {
//            if (currentCameraPosition == null ||
//                currentCameraPosition.target == null ||
//                BlocProvider.of<MapBloc>(context).state is MapLoading) {
//              return;
//            }
//
//            _fetchLocationsIfNeeded(currentCameraPosition);
//          },
//          markers: Set<Marker>.of(widget.markers.values),
//        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton(
              mini: true,
              onPressed: _setFilters,
              child: Icon(Icons.filter_list),
              backgroundColor: Theme.of(context).accentColor,
            ),
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
    mapController.move(position, zoom);
//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(
//        CameraPosition(target: position, zoom: zoom)));
  }

  _fetchLocations(BuildContext context) async {
    if (BlocProvider.of<MapBloc>(context).state is MapLocationsLoaded) {
      return;
    }

    LatLng location = await _getUserPosition();
    if (!mounted) {
      return;
    }
    if (location != null) {
      userPosition = location;
//      Provider.of<UserRepository>(context, listen: false)
//          .setUserPosition(userPosition);
      _moveCameraToNewPosition(userPosition);
    }

    final position = CameraPosition(
        target: location ?? defaultPosition, zoom: mapController.zoom);
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

//      final distance =
//          await _getDistance(newPos.target, lastFetchCameraPosition.target);
//      print('Distance: $distance, radius: $radius, zoomLevel: $zoomLevel');
//
//      if (distance < radius * 1) {
//        print('Not updating locations, distance < radius');
//        return;
//      }
    }

    if (!mounted) {
      return;
    }
    print('Fetching Updates for $newPos and $radius');
    lastFetchCameraPosition = newPos;
    BlocProvider.of<MapBloc>(context).add(MapLoadLocations(
      position: GoogleMapsLatLng(lastFetchCameraPosition.target),
      radius: radius,
    ));
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
//    final GoogleMapController controller = await _controller.future;
//    final region = await controller.getVisibleRegion();
//    final distance = await _getDistance(region.northeast, region.southwest);
//    return (distance / 2.0).floor();
  }
}

class CameraPosition {
  LatLng target;
  double zoom;

  CameraPosition({
    @required this.target,
    @required this.zoom,
  });
}

class GoogleMapsLatLng extends googleMaps.LatLng {
  GoogleMapsLatLng(LatLng latLng) : super(latLng.latitude, latLng.longitude);
}
