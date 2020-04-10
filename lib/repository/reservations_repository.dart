import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/repository/data/data.dart';
import 'package:reservation_system_customer/repository/data/http_responses/http_responses.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/repository/notification_handler.dart';
import 'package:http/http.dart' as http;
import 'package:reservation_system_customer/repository/storage.dart';
import 'data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_repository.dart';

class ReservationsRepository {
  final String _baseUrl;
  final UserRepository _userRepository;
  final Storage _storage;
  final NotificationHandler _notificationHandler;

  ReservationsRepository({
    @required String baseUrl,
    @required UserRepository userRepository,
    @required Storage storage,
    @required NotificationHandler notificationHandler,
  })  : _baseUrl = baseUrl,
        _userRepository = userRepository,
        _storage = storage,
        _notificationHandler = notificationHandler;

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

  /// Returns the list of loaded reservations or null if no reservations could be restored.
  Future<List<Reservation>> loadReservations() async {
    try {
      final loadedReservations =
          await _storage.getString(StorageKey.reservations);
      if (loadedReservations != null) {
        final Iterable list = jsonDecode(loadedReservations);
        return list?.map((s) => Reservation.fromJson(s))?.toList();
      }
    } on Object catch (error) {
      print('loading reservations failed with $error');
    }
    return null;
  }

  Future<void> saveReservations(List<Reservation> reservations) async {
    await _storage.setString(StorageKey.reservations, jsonEncode(reservations));
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
      var result = ReservationsResponse.fromJson(json.decode(response.body))
              ?.reservations ??
          [];

      final reservations =
          result.map((item) => Reservation.fromRawReservation(item)).toList();
      return reservations;
    }
    print('getReservations: error ${response.statusCode}');
    return [];
  }

  Future<void> scheduleReservationReminder(
    Reservation reservation,
    BuildContext context,
  ) async {
    final notificationId =
        await _notificationHandler.scheduleReservationReminder(
      reservation: reservation,
      context: context,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${reservation.id}', notificationId);
  }

  Future<void> cancelReservationReminder(Reservation reservation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final notificationId = prefs.getInt('${reservation.id}');
    if (notificationId != null) {
      _notificationHandler.cancelNotification(notificationId);
    }
    // remove the savedId
    await prefs.remove('${reservation.id}');
  }
}
