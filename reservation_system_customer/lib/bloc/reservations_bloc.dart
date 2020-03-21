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
  final String reservationId;

  CancelReservation(this.reservationId);

  @override
  List<Object> get props => [reservationId];
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

  ReservationsBloc({
    @required ReservationsRepository reservationsRepository,
  }) : _reservationsRepository = reservationsRepository;

  @override
  ReservationsState get initialState => ReservationsInitial();

  @override
  Stream<ReservationsState> mapEventToState(ReservationsEvent event) async* {
    if (event is LoadReservations) {
      yield ReservationsLoading();
      final reservations = await _reservationsRepository.getReservations();
      yield ReservationsLoaded(reservations);
    } else if (event is CancelReservation) {
      yield ReservationsLoading();
      final reservations = await _reservationsRepository.cancelReservation(event.reservationId);
      yield ReservationsLoaded(reservations);
    }
  }
}
