import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui/map/filter_dialog.dart';

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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0)).then((_) => _fetchLocations(context));
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

    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            userPosition.latitude,
            userPosition.longitude,
          ),
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(widget.markers.values),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            mini: true,
            onPressed: _setfilters,
            child: Icon(Icons.filter_list),
            backgroundColor: Theme
                .of(context)
                .accentColor,
          ),

          SizedBox(
            height: 10,
          ),

          FloatingActionButton(
            onPressed: _goToLocation,
            child: Icon(Icons.gps_fixed),
            backgroundColor: Theme
                .of(context)
                .accentColor,
          ),
        ],
      )
    );
  }

  Future<void> _goToLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              userPosition.latitude,
              userPosition.longitude,
            ),
            zoom: 15),
      ),
    );
  }

  void _setfilters() {
    showDialog(context: context,
    builder: (newContext) => FilterDialog(
      mapBloc: BlocProvider.of<MapBloc>(context),
    ));
  }


  void _moveCameraToNewPosition(LatLng position, {double zoom = 14.0}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom)));
  }

  _fetchLocations(context) async {
    await Future.delayed(Duration.zero);
    if (BlocProvider.of<MapBloc>(context).state is MapLocationsLoaded) {
      return;
    }

    LatLng location = await _getUserPosition();
    if (location != null) {
      userPosition = location;
      Provider.of<UserRepository>(context, listen: false)
          .setUserPosition(userPosition);
      _moveCameraToNewPosition(userPosition);
    }
    BlocProvider.of<MapBloc>(context).add(MapLoadLocations(location));
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
}
