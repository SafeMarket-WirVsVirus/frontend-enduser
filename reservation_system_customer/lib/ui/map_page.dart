import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationsBloc, ReservationsState>(
        builder: (context, state) {
      if (state is ReservationsInitial) {
        return Container();
      } else if (state is ReservationsLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is ReservationsLoaded) {
        Map<MarkerId, Marker> markers = {};

        state.reservations.forEach((reservation) {
          markers[MarkerId(reservation.id)] = Marker(
            markerId: MarkerId(reservation.id),
            position: reservation.location,
            infoWindow: InfoWindow(
                title: reservation.locationName,
                snippet: "A Short description"),
            onTap: () {},
          );
        });

        return MapView(
          markers: markers,
        );
      }
      return Container();
    });
  }
}

class MapView extends StatefulWidget {
  final Map<MarkerId, Marker> markers;

  const MapView({Key key, this.markers}) : super(key: key);

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  Position position;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (position == null) {
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
        markers: Set<Marker>.of(widget.markers.values),
      );
    }
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
