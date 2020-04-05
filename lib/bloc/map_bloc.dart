import 'dart:typed_data';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:reservation_system_customer/repository/repository.dart';

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
  final FilterSettings settings;

  MapSettingsChanged(this.settings);

  @override
  List<Object> get props => settings.props;
}

/// STATES

abstract class MapState extends Equatable {
  final List<Location> locations;
  final Map<FillStatus, BitmapDescriptor> markerIcons;
  final FilterSettings filterSettings;

  MapState({
    @required this.locations,
    @required this.markerIcons,
    @required this.filterSettings,
  });

  @override
  List<Object> get props =>
      [locations.map((l) => l.id).toList(), filterSettings.props];
}

class MapInitial extends MapState {
  MapInitial({
    @required FilterSettings filterSettings,
  }) : super(
          locations: [],
          markerIcons: {},
          filterSettings: filterSettings,
        );
}

class MapLoading extends MapState {
  MapLoading({
    @required List<Location> locations,
    @required Map<FillStatus, BitmapDescriptor> markerIcons,
    @required FilterSettings filterSettings,
  }) : super(
          locations: locations,
          markerIcons: markerIcons,
          filterSettings: filterSettings,
        );
}

class MapLocationsLoaded extends MapState {
  MapLocationsLoaded({
    @required List<Location> locations,
    @required Map<FillStatus, BitmapDescriptor> markerIcons,
    @required FilterSettings filterSettings,
  }) : super(
          locations: locations,
          markerIcons: markerIcons,
          filterSettings: filterSettings,
        );
}

/// BLOC

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationsRepository _locationsRepository;
  List<Location> locations = [];
  Map<FillStatus, BitmapDescriptor> markerIcons;

  FilterSettings get _filterSettings => state.filterSettings;

  MapBloc({
    @required LocationsRepository locationsRepository,
  }) : _locationsRepository = locationsRepository {
    // get the saved filter selection
    locationsRepository.loadMapFilterSettings().then((settings) {
      if (settings != null) {
        add(MapSettingsChanged(settings));
      }
    });
  }

  @override
  MapState get initialState => MapInitial(
        filterSettings: FilterSettings(
          locationType: LocationType.supermarket,
          minFillStatus: FillStatus.green,
        ),
      );

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is MapLoadLocations) {
      if (markerIcons == null) {
        markerIcons = await _markerIcons();
      }
      yield MapLoading(
        locations: locations,
        markerIcons: markerIcons,
        filterSettings: _filterSettings,
      );
      final newLocations = await _locationsRepository.getStores(
        position: event.position,
        radius: event.radius,
        type: _filterSettings.locationType,
      );
      locations.addAll(newLocations);
      if (locations.length > 300) {
        locations.removeRange(0, locations.length - 300);
      }

      yield MapLocationsLoaded(
        locations: _filteredLocations(locations, _filterSettings),
        markerIcons: markerIcons,
        filterSettings: _filterSettings,
      );
    } else if (event is MapSettingsChanged) {
      // save the new filter selection
      _locationsRepository.saveMapFilterSettings(event.settings);
      if (state is MapInitial) {
        yield MapInitial(filterSettings: event.settings);
      } else {
        // TODO: Re-fetch locations if type changed
        // filter locations according to event
        yield MapLocationsLoaded(
          locations: _filteredLocations(locations, event.settings),
          markerIcons: markerIcons,
          filterSettings: event.settings,
        );
      }
    }
  }

  List<Location> _filteredLocations(
    List<Location> locations,
    FilterSettings filterSettings,
  ) {
    final filteredLocations = locations
        .where((l) =>
            l != null &&
            l.fillStatus.index <= filterSettings.minFillStatus.index &&
            l.locationType == filterSettings.locationType)
        .toList();
    print(
        'MapBloc: Filtered Locations from ${locations.length} to ${filteredLocations.length}');
    return filteredLocations;
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
