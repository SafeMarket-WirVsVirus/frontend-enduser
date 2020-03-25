import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/repository/data/time_slot_data.dart';

import 'data/data.dart';

class LocationsRepository {
  final String baseUrl;

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
    print('getStores for $position, $radius, $type');
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
      print('getStores succeeded');
      var result = Locations.fromJson(json.decode(response.body));
      print('getStores locations: ${result.locations.length}');
      return result.locations;
    } else {
      print('getStores failed with ${response.statusCode}');
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
    }
    return '';
  }
}
