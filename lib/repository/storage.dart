import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey {
  userFinishedTutorial,
  mapFilterSettings,
  lastUserPositionLat,
  lastUserPositionLon,
  reservations,
}

extension _StorageKeyIds on StorageKey {
  String get id {
    switch (this) {
      case StorageKey.userFinishedTutorial:
        return 'userFinishedTutorial';
      case StorageKey.mapFilterSettings:
        return 'mapFilterSettings';
      case StorageKey.lastUserPositionLat:
        return 'lastUserPositionLat';
      case StorageKey.lastUserPositionLon:
        return 'lastUserPositionLon';
      case StorageKey.reservations:
        return 'reservations';
    }
    return '';
  }
}

class Storage {
  SharedPreferences _prefsInstance;

  Future<SharedPreferences> get _prefs async {
    if (_prefsInstance == null) {
      _prefsInstance = await SharedPreferences.getInstance();
    }
    return _prefsInstance;
  }

  Future<String> getString(StorageKey key) async {
    return (await _prefs).getString(key.id);
  }

  Future<bool> setString(StorageKey key, String value) async {
    return (await _prefs).setString(key.id, value);
  }

  Future<double> getDouble(StorageKey key) async {
    return (await _prefs).getDouble(key.id);
  }

  Future<bool> setDouble(StorageKey key, double value) async {
    return (await _prefs).setDouble(key.id, value);
  }

  Future<bool> getBool(StorageKey key) async {
    return (await _prefs).getBool(key.id);
  }

  Future<bool> setBool(StorageKey key, bool value) async {
    return (await _prefs).setBool(key.id, value);
  }
}
