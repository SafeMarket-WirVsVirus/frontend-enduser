import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:reservation_system_customer/repository/repository.dart';

/// EVENTS
abstract class ModifyReservationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Creates a reservation for the given location
class CreateReservation extends ModifyReservationEvent {
  final Location location;
  final DateTime startTime;

  CreateReservation({
    @required this.location,
    @required this.startTime,
  });
}

/// STATES

abstract class ModifyReservationState extends Equatable {
  @override
  List<Object> get props => [];
}

class ModifyReservationIdle extends ModifyReservationState {}

class CreateReservationSuccess extends ModifyReservationState {
  final ReservationLocation location;
  final DateTime startTime;

  CreateReservationSuccess({
    @required this.location,
    @required this.startTime,
  });
}

class CreateReservationFailure extends ModifyReservationState {}

/// BLOC

class ModifyReservationBloc
    extends Bloc<ModifyReservationEvent, ModifyReservationState> {
  final ReservationsRepository _reservationsRepository;

  ModifyReservationBloc({
    @required ReservationsRepository reservationsRepository,
  }) : _reservationsRepository = reservationsRepository;

  @override
  ModifyReservationState get initialState => ModifyReservationIdle();

  @override
  Stream<ModifyReservationState> mapEventToState(
      ModifyReservationEvent event) async* {
    if (event is CreateReservation) {
      final success = await _reservationsRepository.createReservation(
        locationId: event.location.id,
        startTime: event.startTime,
      );
      if (success) {
        yield CreateReservationSuccess(
          location: ReservationLocation.fromLocation(event.location),
          startTime: event.startTime,
        );
      } else {
        yield CreateReservationFailure();
      }
    }
    yield ModifyReservationIdle();
  }
}
