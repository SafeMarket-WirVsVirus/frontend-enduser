import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/repository/repository.dart';

/// EVENTS

abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MapLoadLocations extends MapEvent {
  final LatLng position;

  MapLoadLocations(this.position);

  @override
  List<Object> get props => [position];
}

/// STATES

abstract class MapState extends Equatable {
  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLocationsLoaded extends MapState {
  final List<Location> locations;

  MapLocationsLoaded(this.locations);

  List<Object> get props => locations;
}

/// BLOC

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationsRepository _locationsRepository;

  MapBloc({
    @required LocationsRepository locationsRepository,
  }) : _locationsRepository = locationsRepository;

  @override
  MapState get initialState => MapInitial();

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is MapLoadLocations) {
      yield MapLoading();
      final locations = await _locationsRepository.getStores(event.position);
      yield MapLocationsLoaded(locations);
    }
  }
}
