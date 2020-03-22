import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:reservation_system_customer/repository/repository.dart';

/// EVENTS

abstract class ReservationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadReservations extends ReservationsEvent {}

class CancelReservation extends ReservationsEvent {
  final int reservationId;
  final int locationId;

  CancelReservation({
    @required this.reservationId,
    @required this.locationId,
  });

  @override
  List<Object> get props => [reservationId, locationId];
}

class MakeReservation extends ReservationsEvent {
  final int locationId;
  final DateTime startTime;

  MakeReservation({
    @required this.locationId,
    @required this.startTime,
  });
}

/// STATES

abstract class ReservationsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReservationsInitial extends ReservationsState {}

class ReservationsLoading extends ReservationsState {}

class ReservationsLoaded extends ReservationsState {
  final List<Reservation> reservations;

  ReservationsLoaded(this.reservations);

  List<Object> get props => reservations;
}

/// BLOC

class ReservationsBloc extends Bloc<ReservationsEvent, ReservationsState> {
  final ReservationsRepository _reservationsRepository;
  final UserRepository _userRepository;

  ReservationsBloc({
    @required ReservationsRepository reservationsRepository,
    @required UserRepository userRepository,
  })  : _reservationsRepository = reservationsRepository,
        _userRepository = userRepository;

  @override
  ReservationsState get initialState => ReservationsInitial();

  @override
  Stream<ReservationsState> mapEventToState(ReservationsEvent event) async* {
    final deviceId = await _userRepository.deviceId();
    if (event is LoadReservations) {
      yield ReservationsLoading();
      final reservations =
          await _reservationsRepository.getReservations(deviceId: deviceId);
      yield ReservationsLoaded(reservations);
    } else if (event is CancelReservation) {
      yield ReservationsLoading();
      final reservations = await _reservationsRepository.cancelReservation(
        reservationId: event.reservationId,
        deviceId: deviceId,
        locationId: event.locationId,
      );
      yield ReservationsLoaded(reservations);
    } else if (event is MakeReservation) {
      await _reservationsRepository.createReservation(
        deviceId: deviceId,
        locationId: event.locationId,
        startTime: event.startTime,
      );
      yield ReservationsLoading();
      final reservations = await _reservationsRepository.getReservations(
        deviceId: deviceId,
      );
      yield ReservationsLoaded(reservations);
    }
  }
}
