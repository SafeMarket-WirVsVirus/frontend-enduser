import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/repository/data/time_slot_data.dart';

import 'data/data.dart';

class LocationsRepository {
  final String baseUrl;

  var locations = [
    Location(
        id: 2434234,
        latitude: 48.135124,
        longitude: 11.581981,
        name: 'REWE',
        fillStatus: FillStatus.green,
        slotDuration: Duration(minutes: 30),
        slotSize: 20,
        address: "Neustädter Straße 1"),
    Location(
      id: 2434234,
      latitude: 48.131184,
      longitude: 11.590613,
      name: 'EDEKA',
      fillStatus: FillStatus.red,
      slotSize: 20,
      slotDuration: Duration(minutes: 30),
      address: "Neustädter Straße 1",
    ),
    Location(
      id: 2434236,
      latitude: 48.138574,
      longitude: 11.588811,
      name: 'ALDI',
      fillStatus: FillStatus.green,
      slotSize: 20,
      slotDuration: Duration(minutes: 30),
      address: "Neustädter Straße 1",
    ),
    Location(
      id: 2434237,
      latitude: 48.125513,
      longitude: 11.583406,
      name: 'LIDL',
      fillStatus: FillStatus.red,
      slotSize: 20,
      slotDuration: Duration(minutes: 30),
      address: "Neustädter Straße 1",
    ),
    Location(
      id: 2434238,
      latitude: 48.128091,
      longitude: 11.592672,
      name: 'Kaufland',
      fillStatus: FillStatus.yellow,
      slotSize: 20,
      slotDuration: Duration(minutes: 30),
      address: "Neustädter Straße 1",
    ),
  ];

  LocationsRepository({@required this.baseUrl});

  Future<Location> getStore(int id) async {
    final uri = Uri.https(baseUrl, '/api/Location/$id');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print('getStore succeeded');
      return Location.fromJson(json.decode(response.body));
    } else {
      print('getStore failed with ${response.statusCode}');
    }
    return null;
  }

  Future<List<TimeSlotData>> getLocationReservations({
    @required int id,
    @required DateTime startTime,
  }) async {
    var queryParameters = {
      'locationId': id.toString(),
      'startTime': startTime.toIso8601String(),
      'slotSizeInMinutes': Constants.slotSizeInMinutes.toString(),
    };
    final uri = Uri.https(
        baseUrl, '/api/Location/GetReservationPerSlot', queryParameters);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print('getLocationReservations succeeded');
      var locationReservations =
          TimeSlotDataResult.fromJson(json.decode(response.body));
      return locationReservations.timeSlotData;
    } else {
      print('getLocationReservations failed with ${response.statusCode}');
    }
    return [];
  }

  Future<List<Location>> getStores({
    @required LatLng position,
    @required int radius,
    @required LocationType type,
  }) async {
    var queryParameters = {
      'type': type.asQueryParameter,
      'longitude': position.longitude.toString(),
      'latitude': position.latitude.toString(),
      'radiusInMeters': radius.toString(),
    };
    final uri =
        Uri.https(baseUrl, '/api/Location/SearchRegistered', queryParameters);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print('getStore succeeded');
      var result = Locations.fromJson(json.decode(response.body));
      print('getStore locations: ${result.locations.length}');
      return locations + result.locations;
    } else {
      print('getStore failed with ${response.statusCode}');
    }
    return [];
  }
}

extension JsonLocationType on LocationType {
  String get asQueryParameter {
    switch (this) {
      case LocationType.bakery:
        return 'bakery';
      case LocationType.supermarket:
        return 'supermarket';
      case LocationType.pharmacy:
        return 'pharmacy';
      case LocationType.store:
        return 'store';
    }
    return '';
  }
}
