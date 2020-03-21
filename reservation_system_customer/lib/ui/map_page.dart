import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/repository/repository.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapView();
  }
}

class MapView extends StatefulWidget {
  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  Position position;
  Map<MarkerId, Marker> markers;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _getMarkers();
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (markers == null || position == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
      );
    }
  }

  _getMarkers() async {
    final List<Reservation> reservations =
        await ReservationsRepository().getReservations();
    Map<MarkerId, Marker> tmpMap = {};

    reservations.forEach((reservation) {
      tmpMap[MarkerId(reservation.id)] = Marker(
        markerId: MarkerId(reservation.id),
        position: reservation.location,
        infoWindow: InfoWindow(
            title: reservation.locationName, snippet: "A Short description"),
        onTap: () {},
      );
    });

    setState(() {
      markers = tmpMap;
    });
  }

  void _getCurrentLocation() async {
    Position ref = await Geolocator().getCurrentPosition();

    setState(() {
      position = ref;
    });
  }

  void _moveCameraToNewPosition(LatLng position, {double zoom = 14.0}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom)));
  }
}
