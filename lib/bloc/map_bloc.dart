import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/bloc/map_marker_loader.dart';
import 'package:reservation_system_customer/logger.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui_imports.dart';

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

class _MapSettingsLoaded extends MapSettingsChanged {
  _MapSettingsLoaded(FilterSettings settings) : super(settings);

  @override
  List<Object> get props => settings.props;
}

/// STATES

abstract class MapState extends Equatable {
  final List<Location> locations;
  final Map<int, BitmapDescriptor> markerIcons;
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

  @override
  String toString() => 'MapInitial with ${filterSettings.toString()}';
}

class MapLoading extends MapState {
  MapLoading({
    @required List<Location> locations,
    @required Map<int, BitmapDescriptor> markerIcons,
    @required FilterSettings filterSettings,
  }) : super(
          locations: locations,
          markerIcons: markerIcons,
          filterSettings: filterSettings,
        );

  @override
  String toString() =>
      'MapLoading with locations $locations and ${filterSettings.toString()}';
}

class MapLocationsLoaded extends MapState {
  MapLocationsLoaded({
    @required List<Location> locations,
    @required Map<int, BitmapDescriptor> markerIcons,
    @required FilterSettings filterSettings,
  }) : super(
          locations: locations,
          markerIcons: markerIcons,
          filterSettings: filterSettings,
        );

  @override
  String toString() =>
      'MapLocationsLoaded with locations $locations and ${filterSettings.toString()}';
}

/// BLOC

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationsRepository _locationsRepository;
  final MapMarkerLoader _markerLoader;
  List<Location> locations = [];
  Map<int, BitmapDescriptor> markerIcons;
  Map<FillStatus, BitmapDescriptor> clusterMarkers;

  FilterSettings get _filterSettings => state.filterSettings;

  MapBloc({
    @required LocationsRepository locationsRepository,
    @required MapMarkerLoader markerLoader,
  })  : _locationsRepository = locationsRepository,
        _markerLoader = markerLoader {
    // get the saved filter selection
    locationsRepository.loadMapFilterSettings().then((settings) {
      if (settings != null) {
        add(_MapSettingsLoaded(settings));
      }
    });
  }

  @override
  MapState get initialState => MapInitial(
        filterSettings: FilterSettings(
          locationType: LocationType.supermarket,
          minFillStatus: FillStatus.red,
        ),
      );

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is MapLoadLocations) {
      if (clusterMarkers == null) {
        clusterMarkers = await _markerLoader.loadClusterIcons();
      }

      List<Location> list = _filteredLocations(locations, _filterSettings);
      yield MapLoading(
        locations: list,
        markerIcons: markerIcons,
        filterSettings: _filterSettings,
      );
      final newLocations = await _locationsRepository.getStores(
        position: event.position,
        radius: event.radius,
        type: _filterSettings.locationType,
      );

      final cachedLocationIds = locations.map((l) => l.id).toSet();
      var newLocationsInCache =
          newLocations.where((l) => cachedLocationIds.contains(l.id));
      for (var newLocation in newLocationsInCache) {
        final index = locations.indexWhere((l) => l.id == newLocation.id);
        if (index != -1) {
          locations.removeAt(index);
        }
      }

      locations.addAll(newLocations);

      if (locations.length > 300) {
        locations.removeRange(0, locations.length - 300);
      }

      //create marker icons
      markerIcons =
          await _markerLoader.addNewMarkerIcons(locations, markerIcons);

      yield MapLocationsLoaded(
        locations: _filteredLocations(locations, _filterSettings),
        markerIcons: markerIcons,
        filterSettings: _filterSettings,
      );
    } else if (event is MapSettingsChanged) {
      if (event is! _MapSettingsLoaded) {
        // save the new filter selection
        _locationsRepository.saveMapFilterSettings(event.settings);
      }
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
            // l.fillStatus.index <= filterSettings.minFillStatus.index && // Fill Status filtering is removed for now
            l.locationType == filterSettings.locationType)
        .toList();
    debug(
        'Filtered Locations from ${locations.length} to ${filteredLocations.length}');
    return filteredLocations;
  }
}
