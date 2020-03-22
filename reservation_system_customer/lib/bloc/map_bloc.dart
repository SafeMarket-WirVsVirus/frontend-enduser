import 'dart:typed_data';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
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

class MapSettingsChanged extends MapEvent{
  final int fillStatusPreference;
  final bool nonGrocery;

  MapSettingsChanged(this.fillStatusPreference, this.nonGrocery);

  @override
  List<Object> get props => [fillStatusPreference, nonGrocery];
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
  final Map<FillStatus, BitmapDescriptor> markerIcons;

  MapLocationsLoaded({
    @required this.locations,
    @required this.markerIcons,
  });

  List<Object> get props => locations;
}

/// BLOC

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationsRepository _locationsRepository;
  int fillStatusPreference = 3;
  bool nonGrocery = false;

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
      final Map<FillStatus, BitmapDescriptor> markerIcons = {};
      markerIcons[FillStatus.green] = await _icon(FillStatus.green);
      markerIcons[FillStatus.yellow] = await _icon(FillStatus.yellow);
      markerIcons[FillStatus.red] = await _icon(FillStatus.red);

      yield MapLocationsLoaded(
        locations: locations,
        markerIcons: markerIcons,
      );
    } else if (event is MapSettingsChanged) {
      MapSettingsChanged e = event;
      List<Location> locations;
      if (this.state is MapLocationsLoaded) {
        locations = ((this.state) as MapLocationsLoaded).locations;
      }
      final List<Location> newLocations = locations.where((l) => l.fillStatus.index < e.fillStatusPreference);
      yield MapLocationsLoaded(
        locations: newLocations,
        markerIcons: null,
      );
    }
  }

  Future<BitmapDescriptor> _icon(FillStatus color) async {
    final size = 70;
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
