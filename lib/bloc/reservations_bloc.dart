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

/// STATES

abstract class ReservationsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReservationsInitial extends ReservationsState {}

class ReservationsLoading extends ReservationsState {}

class ReservationsLoadFail extends ReservationsState {}

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
      try {
        print("Loading reservations...");
        final reservations = await _reservationsRepository
            .getReservations(
              deviceId: deviceId,
            )
            .timeout(Duration(seconds: 5));
        if (reservations != null) yield ReservationsLoaded(reservations);
      } catch (_) {
        print("Loading reservations failed");
        yield ReservationsLoadFail();
      }
    }
  }
}
