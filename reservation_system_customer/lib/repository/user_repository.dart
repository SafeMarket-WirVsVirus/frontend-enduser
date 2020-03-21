import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _PersistenceKeys {
  static const userPositionLatKey = 'positionLat';
  static const userPositionLngKey = 'positionLng';
}

class UserRepository {
  LatLng _userPosition;

  LatLng get userPosition => _userPosition;

  UserRepository() {}

  Future<void> setUserPosition(LatLng position) async {
    _userPosition = position;
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(
        _PersistenceKeys.userPositionLatKey, userPosition?.latitude);
    prefs.setDouble(
        _PersistenceKeys.userPositionLngKey, userPosition?.longitude);
  }

  void loadUserPosition() async {
    final prefs = await SharedPreferences.getInstance();
    double lat = prefs.get(_PersistenceKeys.userPositionLatKey) ?? null;
    double lng = prefs.get(_PersistenceKeys.userPositionLngKey) ?? null;
    if (lat != null && lng != null) {
      _userPosition = LatLng(lat, lng);
    }
  }
}
