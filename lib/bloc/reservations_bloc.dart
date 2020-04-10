import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:reservation_system_customer/repository/repository.dart';

/// EVENTS

abstract class ReservationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Load reservations from persistence and update with new fetched reservations from backend.
class LoadReservations extends ReservationsEvent {}

/// Update the reservations from backend. This fails when the user has no network.
class UpdateReservations extends ReservationsEvent {}

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
    if (event is LoadReservations) {
      yield ReservationsLoading();
      print('Loading reservations ...');
      final loadedReservations =
      await _reservationsRepository.loadReservations();
      if (loadedReservations != null) {
        print('Loaded persisted reservations: $loadedReservations');
        yield ReservationsLoaded(loadedReservations);
      }

      try {
        final reservations = await _fetchReservations(timeoutInSec: 10);
        print('Loaded fetched reservations: $reservations');
        if (reservations != null) {
          yield ReservationsLoaded(reservations ?? loadedReservations ?? []);
        }
        _reservationsRepository.saveReservations(reservations ?? []);
      } catch (_) {
        print('Could not retrieve any reservations.');
        if (loadedReservations?.isEmpty ?? true) {
          yield ReservationsLoadFail();
        }
      }
    } else if (event is UpdateReservations) {
      print('Updating reservations ...');
      yield ReservationsLoading();
      var reservations = <Reservation>[];
      try {
        reservations = await _fetchReservations(timeoutInSec: 5);
        print('Updated with fetched reservations: $reservations');
        yield ReservationsLoaded(reservations ?? []);
        _reservationsRepository.saveReservations(reservations ?? []);
      } catch (_) {
        print('Could not retrieve any reservations.');
        yield ReservationsLoadFail();
      }
    }
  }

  Future<List<Reservation>> _fetchReservations({
    @required int timeoutInSec,
  }) async {
    final deviceId = await _userRepository.deviceId();

    final reservations = await _reservationsRepository
        .getReservations(
          deviceId: deviceId,
        )
        .timeout(Duration(seconds: timeoutInSec));

    reservations?.sort((a, b) => a.startTime.compareTo(b.startTime));
    return reservations;
  }
}
