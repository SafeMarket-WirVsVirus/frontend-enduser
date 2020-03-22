import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'data/data.dart';
import 'package:http/http.dart' as http;

class ReservationsRepository {
  final String baseUrl;

  List<Reservation> reservations = [
    Reservation(
      id: 30,
      location: Location(
          id: 3,
          name: 'REWE',
          address_street: "Neustädter Straße 1",
          address_city: "80331 München"),
        latitude: 48.135124,
        longitude: 11.581981,
      ),
      startTime: DateTime.now().add(Duration(minutes: 3)),
    ),
    Reservation(
      id: 20,
      location: Location(
          id: 10,
          name: 'LIDL',
          address_street: "Neustädter Straße 1",
          address_city: "80331 München"),

        latitude: 47.960490,
        longitude: 11.355184,
      ),
      startTime: DateTime.now().add(Duration(hours: 5)),
    ),
  ];

  ReservationsRepository({
    @required this.baseUrl,
  });

  Future<List<Reservation>> cancelReservation({
    @required int locationId,
    @required String deviceId,
    @required int reservationId,
  }) async {
    var queryParameters = {
      'deviceId': deviceId,
      'locationId': locationId,
      'reservationId': reservationId,
    };
    final uri = Uri.https(
        baseUrl, '/api/Reservation/RevokeSpecificReservation', queryParameters);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      print('cancelReservation: success');
      return getReservations(deviceId: deviceId);
    }
    print('cancelReservation: error ${response.statusCode}');
    return [];
  }

  Future<void> createReservation({
    @required String deviceId,
    @required int locationId,
    @required DateTime startTime,
  }) async {
    var queryParameters = {
      'locationId': '$locationId',
      'dateTime': startTime.toIso8601String(),
      'deviceId': deviceId,
    };
    final uri = Uri.https(baseUrl, '/api/Reservation/Reserve', queryParameters);
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('createReservation: success');
    } else {
      print('createReservation: error ${response.statusCode}');
    }
  }

  Future<List<Reservation>> getReservations({
    @required String deviceId,
  }) async {
    var queryParameters = {
      'deviceId': deviceId,
    };
    final uri = Uri.https(
        baseUrl, '/api/Reservation/ReservationsByDevice', queryParameters);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print('getReservations: success');
      //TODO: Remove mocked reservations
      var result = Reservations.fromJson(json.decode(response.body)).reservations;
      return result + reservations;
    }
    print('getReservations: error ${response.statusCode}');
    return [];
  }
}
