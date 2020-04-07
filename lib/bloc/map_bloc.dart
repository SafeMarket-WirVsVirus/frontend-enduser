import 'dart:typed_data';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/data/data.dart';

/// EVENTS

abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MapLoadLocations extends MapEvent {
  final LatLng position;
  final int radius;

  MapLoadLocations({
    @required this.position,
    @required this.radius,
  });

  @override
  List<Object> get props => [position];
}

class MapSettingsChanged extends MapEvent {
  final int fillStatusPreference;
  final LocationType filterSelection;

  MapSettingsChanged(this.fillStatusPreference, this.filterSelection);

  @override
  List<Object> get props => [fillStatusPreference, filterSelection];
}

/// STATES

abstract class MapState extends Equatable {
  final List<Location> locations;
  final Map<FillStatus, BitmapDescriptor> markerIcons;

  MapState({
    @required this.locations,
    @required this.markerIcons,
  });

  @override
  List<Object> get props => locations.map((l) => l.id).toList();
}

class MapInitial extends MapState {
  MapInitial()
      : super(
          locations: [],
          markerIcons: {},
        );
}

class MapLoading extends MapState {
  MapLoading({
    @required List<Location> locations,
    @required Map<FillStatus, BitmapDescriptor> markerIcons,
  }) : super(
          locations: locations,
          markerIcons: markerIcons,
        );
}

class MapLocationsLoaded extends MapState {
  MapLocationsLoaded({
    @required List<Location> locations,
    @required Map<FillStatus, BitmapDescriptor> markerIcons,
  }) : super(
          locations: locations,
          markerIcons: markerIcons,
        );
}

/// BLOC

class MapBloc extends Bloc<MapEvent, MapState> {
  LocationType get filterSelection => _filterSelection;
  int get fillStatusPreference => _fillStatusPreference;

  final LocationsRepository _locationsRepository;
  int _fillStatusPreference = 3;
  LocationType _filterSelection = LocationType.supermarket;
  List<Location> locations = [];
  Map<FillStatus, BitmapDescriptor> markerIcons;

  MapBloc({
    @required LocationsRepository locationsRepository,
  }) : _locationsRepository = locationsRepository {
    //get the saved filter selection
    SharedPreferences.getInstance().then((pref) {
      _filterSelection = _getLocationTypeFromQueryParameter(
              pref.getString("filter_selection")) ??
          _filterSelection;
      _fillStatusPreference =
          pref.getInt("fill_status_preference") ?? _fillStatusPreference;
    });
  }

  @override
  MapState get initialState => MapInitial();

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (markerIcons == null) {
      markerIcons = await _markerIcons();
    }
    if (event is MapLoadLocations) {
      yield MapLoading(
        locations: locations,
        markerIcons: markerIcons,
      );
      final newLocations = await _locationsRepository.getStores(
        position: event.position,
        radius: event.radius,
        type: _filterSelection,
      );
      locations.addAll(newLocations);
      if (locations.length > 300) {
        locations.removeRange(0, locations.length - 300);
      }

      yield MapLocationsLoaded(
        locations: _filteredLocations(locations),
        markerIcons: markerIcons,
      );
    } else if (event is MapSettingsChanged) {
      //save the new filter selection
      SharedPreferences.getInstance().then((pref) {
        pref.setString("filter_selection", _filterSelection.asQueryParameter);
        pref.setInt("fill_status_preference", _fillStatusPreference);
      });

      _fillStatusPreference = event.fillStatusPreference;
      _filterSelection = event.filterSelection;
      yield MapLocationsLoaded(
        locations: _filteredLocations(locations),
        markerIcons: markerIcons,
      );
    }
  }

  LocationType _getLocationTypeFromQueryParameter(String parameter) {
    switch (parameter) {
      case 'bakery':
        return LocationType.bakery;
      case 'supermarket':
        return LocationType.supermarket;
      case 'pharmacy':
        return LocationType.pharmacy;
    }
    return null;
  }

  List<Location> _filteredLocations(List<Location> locations) {
    return locations
        .where((l) =>
            l != null &&
            l.fillStatus.index < _fillStatusPreference &&
            l.locationType == _filterSelection)
        .toList();
  }

  Future<Map<FillStatus, BitmapDescriptor>> _markerIcons() async {
    final Map<FillStatus, BitmapDescriptor> markerIcons = {};
    markerIcons[FillStatus.green] = await _icon(FillStatus.green);
    markerIcons[FillStatus.yellow] = await _icon(FillStatus.yellow);
    markerIcons[FillStatus.red] = await _icon(FillStatus.red);
    return markerIcons;
  }

  Future<BitmapDescriptor> _icon(FillStatus color) async {
    final size = 90;
    switch (color) {
      case FillStatus.green:
        return _getBytesFromAsset('assets/icon_green.png', size);
      case FillStatus.red:
        return _getBytesFromAsset('assets/icon_red.png', size);
      case FillStatus.yellow:
        return _getBytesFromAsset('assets/icon_yellow.png', size);
    }
    return null;
  }

  Future<BitmapDescriptor> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    final codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    final bytes = (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }
}
