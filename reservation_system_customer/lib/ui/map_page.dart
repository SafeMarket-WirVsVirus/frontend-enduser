import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      Map<MarkerId, Marker> markers = {};
      if (state is MapLocationsLoaded) {
        state.locations.forEach((reservation) {
          markers[MarkerId(reservation.id)] = Marker(
            markerId: MarkerId(reservation.id),
            position: reservation.position,
            infoWindow: InfoWindow(
                title: reservation.name, snippet: "A Short description"),
            onTap: () {},
          );
        });
      }
      return MapView(
        markers: markers,
      );
    });
  }
}

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
  LatLng userPosition = LatLng(48.160490, 11.555184); // default position

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToLocation,
        label: Text("Go to location"),
      ),
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
