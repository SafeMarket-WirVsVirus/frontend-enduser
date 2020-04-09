import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/repository/storage.dart';
import 'package:device_identifier/device_identifier.dart';

class UserRepository {
  final Storage storage;
  LatLng _userPosition;
  String _deviceId;

  LatLng get userPosition => _userPosition;

  UserRepository({
    @required this.storage,
  });

  Future<bool> shouldShowTutorial() async {
    final finishedTutorial =
        (await storage.getBool(StorageKey.userFinishedTutorial)) ?? false;
    return !finishedTutorial;
  }

  Future<void> saveUserFinishedTutorial() async {
    storage.setBool(StorageKey.userFinishedTutorial, true);
  }

  Future<void> setUserPosition(LatLng position) async {
    _userPosition = position;

    storage.setDouble(StorageKey.lastUserPositionLat, userPosition?.latitude);
    storage.setDouble(StorageKey.lastUserPositionLon, userPosition?.longitude);
  }

  void loadUserPosition() async {
    final lat = await storage.getDouble(StorageKey.lastUserPositionLat);
    final lng = await storage.getDouble(StorageKey.lastUserPositionLon);
    if (lat != null && lng != null) {
      _userPosition = LatLng(lat, lng);
    }
  }

  Future<String> deviceId() async {
    if (_deviceId == null) {
      _deviceId = await DeviceIdentifier.deviceId;
    }
    return _deviceId;
  }
}
