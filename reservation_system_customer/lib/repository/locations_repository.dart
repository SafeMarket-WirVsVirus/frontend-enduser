import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/repository/data/capacity_utilization.dart';

import 'data/data.dart';

class LocationsRepository {
  final String baseUrl;

  LocationsRepository({@required this.baseUrl});

  Future<Location> getStore(int id) async {
    var queryParameters = {
      'id': '$id',
    };
    final uri = Uri.https(baseUrl, '/api/Location/$id');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var tmpLocation = Location.fromJson(json.decode(response.body));

      //TODO: Delete dummy data
      Capacity_utilization cu1 = Capacity_utilization();
      cu1.utilization = 0.9;
      Daily_Utilization du = Daily_Utilization(date: DateTime.now());
      for (var i = 1; i < 20; i++) {
        du.timeslot_data.add(Timeslot_Data(
            startTime: DateTime.now().add(new Duration(minutes: i * 10)),
            bookings: i,
            utilization: i / 10));
      }
      cu1.daily_utilization.add(du);
      Capacity_utilization cu2 = cu1;
      cu2.utilization = 0.1;

      return Location(
        id: tmpLocation.id,
        position: id == 10
            ? LatLng(48.160490, 11.555184)
            : LatLng(47.960490, 11.355184),
        name: tmpLocation.name,
        fillStatus: tmpLocation.fillStatus,
        capacity_utilization: id == 10 ? cu1 : cu2,
        slot_duration: Duration(minutes: 10),
      );
    } else {
      print('getStore failed with ${response.statusCode}');
    }
    return null;
  }

  Future<List<Location>> getStores(LatLng position) async {
    final store1 = await getStore(10);
    final store2 = await getStore(11);
    return [store1, store2];
  }
}
