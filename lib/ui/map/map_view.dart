import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui_imports.dart';

class MapView extends StatefulWidget {
  final Map<MarkerId, Marker> markers;

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
      print("user moved to new location ${position.toString()}");
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
    print('Building map with ${widget.markers.length} marker(s)');
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
                zoom: 15,
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
              },
              onCameraIdle: () async {
                if (currentCameraPosition == null ||
                    currentCameraPosition.target == null ||
                    BlocProvider.of<MapBloc>(context).state is MapLoading) {
                  return;
                }

                _fetchLocationsIfNeeded(currentCameraPosition);
              },
              markers: Set<Marker>.of(widget.markers.values),
            ),

//            Try out chips
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: LocationType.values.map<Widget>((LocationType l) {
                    return Padding(
                      padding: EdgeInsets.all(5),
                      child: ChoiceChip(
                        label: Text(
                            l.localized(context),
                            style: TextStyle(
                              color: selectedType == l ? Colors.white : Colors.black,
                            )
                        ),
                        selected: selectedType == l,
                        backgroundColor: Colors.white,
                        selectedColor: Theme.of(context).accentColor,
                        shadowColor: Colors.black,
                        elevation: (selectedType == l) ? 10 : 5,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedType = l;
                            }
                            BlocProvider.of<MapBloc>(context).add(
                                MapSettingsChanged(FilterSettings(
                                    locationType: l,
                                    minFillStatus: FillStatus.red))); // TODO remove minFillStatus from FilterSettings
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton(
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

extension LocationTypeDescription on LocationType {
  String localized(context) {
    switch (this) {
      case LocationType.supermarket:
        return AppLocalizations.of(context).locationFilterSupermarketsLabel;
      case LocationType.bakery:
        return AppLocalizations.of(context).locationFilterBakeriesLabel;
      case LocationType.pharmacy:
        return AppLocalizations.of(context).locationFilterPharmaciesLabel;
    }
    return '';
  }
}
