import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/repository/data/capacity_utilization.dart';

import 'data/data.dart';

class LocationsRepository {
  final String baseUrl;

  static Capacity_utilization _cap() {
    Capacity_utilization cu1 = Capacity_utilization();
    cu1.utilization = 0.9;
    Daily_Utilization du = Daily_Utilization(date: DateTime.now());
    for (var i = 1; i < 20; i++) {
      Random random = new Random();
      du.timeslot_data.add(Timeslot_Data(
          startTime: DateTime.now().add(new Duration(minutes: i * 10)),
          bookings: i,
          utilization: random.nextInt(100) / 100));
    }
    cu1.daily_utilization.add(du);
    return cu1;
  }

  var locations = [
    Location(
        id: 2434234,
        latitude: 48.135124,
        longitude: 11.581981,
        name: 'REWE',
        fillStatus: FillStatus.green,
        slotDuration: Duration(minutes: 30),
        capacity_utilization: _cap(),
        address: "Neustädter Straße 1"
        ),
    Location(
        id: 2434234,
        latitude:48.131184,
        longitude: 11.590613,
        name: 'EDEKA',
        fillStatus: FillStatus.red,
        slotDuration: Duration(minutes: 30),
        capacity_utilization: _cap(),
        address: "Neustädter Straße 1",
    ),
    Location(
        id: 2434236,
        latitude:
  48.138574, longitude:11.588811,
        name: 'ALDI',
        fillStatus: FillStatus.green,
        slotDuration: Duration(minutes: 30),
        capacity_utilization: _cap(),
        address: "Neustädter Straße 1",
        ),
    Location(
        id: 2434237,
  latitude: 48.125513, longitude: 11.583406,
        name: 'LIDL',
        fillStatus: FillStatus.red,
        slotDuration: Duration(minutes: 30),
        capacity_utilization: _cap(),
        address: "Neustädter Straße 1",
        ),
    Location(
        id: 2434238,
        latitude: 48.128091, longitude:11.592672,
        name: 'Kaufland',
        fillStatus: FillStatus.yellow,
        slotDuration: Duration(minutes: 30),
        capacity_utilization: _cap(),
        address: "Neustädter Straße 1",
        ),
  ];

  LocationsRepository({@required this.baseUrl});

  Future<Location> getStore(int id) async {
    final uri = Uri.https(baseUrl, '/api/Location/$id');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var j = json.decode(response.body);
      var tmpLocation = Location.fromJson(json.decode(response.body));

      //TODO: Delete dummy data
      tmpLocation.capacity_utilization = _cap();
      return tmpLocation;
    } else {
      print('getStore failed with ${response.statusCode}');
    }
    return null;
  }

  Future<List<Location>> getStores({
    @required LatLng position,
    @required int radius,
    @required LocationType type,
  }) async {
    final store1 = await getStore(7);
    locations.add(store1);
    return locations;
  }
}
