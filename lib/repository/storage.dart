import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey {
  mapFilterSettings,
  lastUserPositionLat,
  lastUserPositionLon,
}

extension _StorageKeyIds on StorageKey {
  String get id {
    switch (this) {
      case StorageKey.mapFilterSettings:
        return 'mapFilterSettings';
      case StorageKey.lastUserPositionLat:
        return 'lastUserPositionLat';
      case StorageKey.lastUserPositionLon:
        return 'lastUserPositionLon';
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
}
