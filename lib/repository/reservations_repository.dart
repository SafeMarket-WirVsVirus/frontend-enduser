import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:http/http.dart' as http;
import 'data/data.dart';
import 'user_repository.dart';

class ReservationsRepository {
  final String _baseUrl;
  final UserRepository _userRepository;

  ReservationsRepository({
    @required String baseUrl,
    @required UserRepository userRepository,
  })  : _baseUrl = baseUrl,
        _userRepository = userRepository;

  Future<bool> cancelReservation({
    @required int locationId,
    @required int reservationId,
  }) async {
    final deviceId = await _userRepository.deviceId();
    var queryParameters = {
      'deviceId': deviceId,
      'locationId': locationId,
      'reservationId': reservationId,
    };
    final uri = Uri.https(
      _baseUrl,
      '/api/Reservation/RevokeSpecificReservation',
      queryParameters,
    );
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      print('cancelReservation: success');
      return true;
    }
    print('cancelReservation: error ${response.statusCode}');
    return false;
  }

  Future<bool> createReservation({
    @required int locationId,
    @required DateTime startTime,
  }) async {
    final deviceId = await _userRepository.deviceId();
    var queryParameters = {
      'locationId': '$locationId',
      'dateTime': startTime.toIso8601String(),
      'deviceId': deviceId,
    };
    final uri = Uri.https(
      _baseUrl,
      '/api/Reservation/Reserve',
      queryParameters,
    );
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('createReservation: success');
      return true;
    } else {
      print('createReservation: error ${response.statusCode}');
      return false;
    }
  }

  Future<List<Reservation>> getReservations({
    @required String deviceId,
  }) async {
    var queryParameters = {
      'deviceId': deviceId,
      'minDate': DateTime.now()
          .subtract(Duration(hours: Constants.minHoursBeforeNowForReservations))
          .toString(),
    };
    final uri = Uri.https(
      _baseUrl,
      '/api/Reservation/ReservationsByDevice',
      queryParameters,
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print('getReservations: success');
      var result =
          Reservations.fromJson(json.decode(response.body)).reservations;
      return result;
    }
    print('getReservations: error ${response.statusCode}');
    return [];
  }
}
