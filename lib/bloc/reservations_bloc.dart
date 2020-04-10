import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:reservation_system_customer/repository/notification_handler.dart';
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

/// Schedules or cancels a notification and emits the updated reservations.
class ToggleReminderForReservation extends ReservationsEvent {
  final int reservationId;

  ToggleReminderForReservation({
    @required this.reservationId,
  });
}

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

  @override
  String toString() {
    return 'ReservationsLoaded: $reservations';
  }
}

/// BLOC

class ReservationsBloc extends Bloc<ReservationsEvent, ReservationsState> {
  final ReservationsRepository _reservationsRepository;
  final UserRepository _userRepository;
  final NotificationHandler _notificationHandler;
  final BuildContext _context;

  ReservationsBloc({
    @required ReservationsRepository reservationsRepository,
    @required UserRepository userRepository,
    @required NotificationHandler notificationHandler,
    @required BuildContext context,
  })  : _reservationsRepository = reservationsRepository,
        _userRepository = userRepository,
        _notificationHandler = notificationHandler,
        _context = context;

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
        final reservations = await _fetchReservations(
          loadedReservations: _currentReservations,
          timeoutInSec: 10,
        );
        print('Loaded fetched reservations: $reservations');
        if (reservations != null) {
          yield ReservationsLoaded(reservations ?? loadedReservations ?? []);
        }
        _reservationsRepository.saveReservations(reservations ?? []);
      } catch (error) {
        print('Fetching reservations failed with $error');
        if (loadedReservations?.isEmpty ?? true) {
          yield ReservationsLoadFail();
        }
      }
    } else if (event is UpdateReservations) {
      print('Updating reservations ...');
      final currentReservations = _currentReservations;
      yield ReservationsLoading();
      var reservations = <Reservation>[];
      try {
        reservations = await _fetchReservations(
          loadedReservations: currentReservations,
          timeoutInSec: 5,
        );
        print('Updated with fetched reservations: $reservations');
        yield ReservationsLoaded(reservations ?? []);
        _reservationsRepository.saveReservations(reservations ?? []);
      } catch (_) {
        print('Could not retrieve any reservations.');
        yield ReservationsLoadFail();
      }
    } else if (event is ToggleReminderForReservation) {
      if (state is ReservationsLoaded) {
        final reservations = (state as ReservationsLoaded).reservations;
        final index =
            reservations.indexWhere((r) => r.id == event.reservationId);
        if (index != -1) {
          final reservation = reservations[index];
          int notificationId;

          if (reservation.reminderNotificationId != null) {
            _notificationHandler
                .cancelNotification(reservation.reminderNotificationId);
          } else {
            notificationId =
                await _notificationHandler.scheduleReservationReminder(
              reservation: reservation,
              context: _context,
            );
          }
          final Reservation updatedReservation =
              Reservation.withUpdatedNotificationId(
                  reservation, notificationId);

          final newReservations = List<Reservation>.from(reservations);
          newReservations[index] = updatedReservation;

          _reservationsRepository.saveReservations(newReservations);

          yield ReservationsLoaded(newReservations);
        }
      } else {
        print(
            'Not updating reminder. Expected state ReservationsLoaded but was $state.');
      }
    }
  }

  List<Reservation> get _currentReservations {
    if (state is ReservationsLoaded) {
      return (state as ReservationsLoaded).reservations;
    }
    return [];
  }

  Future<List<Reservation>> _fetchReservations({
    @required List<Reservation> loadedReservations,
    @required int timeoutInSec,
  }) async {
    final deviceId = await _userRepository.deviceId();

    final fetchedReservations = await _reservationsRepository
        .getReservations(
          deviceId: deviceId,
        )
        .timeout(Duration(seconds: timeoutInSec));

    fetchedReservations?.sort((a, b) => a.startTime.compareTo(b.startTime));
    // Update with persisted notification ids

    return fetchedReservations?.map((r) {
      final notificationId = loadedReservations
          .firstWhere((loadedReservation) => loadedReservation.id == r.id,
              orElse: () => null)
          ?.reminderNotificationId;
      return Reservation.withUpdatedNotificationId(r, notificationId);
    })?.toList();
  }
}
