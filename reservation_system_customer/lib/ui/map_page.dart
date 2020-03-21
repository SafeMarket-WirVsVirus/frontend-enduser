import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/repository/repository.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapView();
  }
}

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Map<MarkerId, Marker> markers =
  <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  Completer<GoogleMapController> _controller = Completer();

  Future<Map<MarkerId, Marker>> _getMarkers() async {
    final List<Reservation> reservations =
    await ReservationsRepository().getReservations();
    Map<MarkerId, Marker> markers = {};

    reservations.forEach((reservation) {
      markers[MarkerId(reservation.id)] = Marker(
      markerId: MarkerId(reservation.id),
      position: reservation.location,
      infoWindow:
      InfoWindow(title: reservation.locationName, snippet: "A Short description"),
      onTap: () {},
      );
    });

    return markers;
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(48.160490, 11.555184),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMarkers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return new Scaffold(
            body: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(snapshot.data.values),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: _goToTheLake,
              label: Text('To the lake!'),
              icon: Icon(Icons.directions_boat),
            ),
          );
        }
      },
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
