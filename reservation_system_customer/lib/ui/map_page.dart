import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'dart:math';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      if (state is ReservationsInitial) {
        return Container();
      } else if (state is ReservationsLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is MapLocationsLoaded) {
        Map<MarkerId, Marker> markers = {};

        state.locations.forEach((location) {
          markers[MarkerId(location.id)] = Marker(
            markerId: MarkerId(location.id),
            position: location.position,
            infoWindow: InfoWindow(
                title: location.name, snippet: "A Short description"),
            onTap: () {
              showBottomSheet(
                  context: context,
                  builder: (context) => Container(
                        color: Theme.of(context).primaryColor,
                        height: 250,
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  location.name,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: BarChart(
                              location.capacity_utilization.daily_utilization[0]
                                  .get_bar_data(
                                  DateTime.now(), //starttime
                                  8, // datacount
                                  BarChartGroupData( // Config
                                    x: 0,
                                    barRods: [BarChartRodData(y: 0)],
                                    barsSpace: 5,
                                  )
                              ),
                            ),
                          )
                        ]),
                      ));
            },
          );
        });

        return MapView(
          markers: markers,
        );
      }

      return Container();
    });
  }

  _fetchLocations() async {
    if (BlocProvider.of<MapBloc>(context).state is MapLocationsLoaded) {
      return;
    }

    Position position = await Geolocator().getCurrentPosition();
    if (position != null) {
      final location = LatLng(position.latitude, position.longitude);
      BlocProvider.of<MapBloc>(context).add(MapLoadLocations(location));
    }
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

  Future<void> _goToLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 15)));
  }

  @override
  Widget build(BuildContext context) {
    if (position == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        body: GoogleMap(
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(position.latitude, position.longitude),
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
