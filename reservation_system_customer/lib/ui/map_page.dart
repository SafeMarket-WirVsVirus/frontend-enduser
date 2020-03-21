import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'dart:math';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      Map<MarkerId, Marker> markers = {};
      if (state is MapLocationsLoaded) {
        state.locations.forEach((location) {
          markers[MarkerId(location.id)] = Marker(
            markerId: MarkerId(location.id),
            position: location.position,
            infoWindow: InfoWindow(
                title: location.name, snippet: "A Short description"),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Container(
                        color: Theme.of(context).primaryColor,
                    height: 300,
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  location.name,
                                  style:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .headline,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Center(
                                  child: Icon(Icons.arrow_back_ios),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: BarChart(location
                                      .capacity_utilization
                                      .daily_utilization[0]
                                      .get_bar_data(
                                      DateTime.now(), //starttime
                                      8, // datacount
                                      BarChartGroupData(
                                        // Config
                                          x: 0,
                                          barRods: [
                                            BarChartRodData(
                                                y: 0,
                                                width: 20,
                                                color: Colors.blue,
                                                borderRadius:
                                                BorderRadius.only(
                                                    topLeft: Radius
                                                        .circular(
                                                        5.0),
                                                    topRight: Radius
                                                        .circular(
                                                        5.0)))
                                          ],
                                          barsSpace: 5))
                                      .copyWith(
                                      alignment:
                                      BarChartAlignment.spaceEvenly,
                                      titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: SideTitles(
                                              showTitles: true,
                                              textStyle: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 10),
                                              getTitles:
                                                  (double value) {
                                                return location
                                                    .capacity_utilization
                                                    .daily_utilization[
                                                0]
                                                    .get_bar_titles(
                                                    value);
                                              }),
                                          leftTitles: SideTitles(
                                              showTitles: false)),
                                      borderData:
                                      FlBorderData(show: false))),
                                ),
                                Center(
                                  child: Icon(Icons.arrow_forward_ios),
                                )
                              ],
                            ),
                          )
                        ]),
                      ));
            },
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
