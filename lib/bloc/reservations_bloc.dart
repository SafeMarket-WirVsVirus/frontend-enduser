import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:reservation_system_customer/bloc/modify_reservation_bloc.dart';
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
class _UpdateReservations extends ReservationsEvent {
  final ReservationLocation newReservationLocation;
  final DateTime newReservationStartTime;

  _UpdateReservations({
    @required this.newReservationLocation,
    @required this.newReservationStartTime,
  });
}

/// Schedules or cancels a notification and emits the updated reservations.
class ToggleReminderForReservation extends ReservationsEvent {
  final int reservationId;
  final BuildContext context;

  ToggleReminderForReservation({
    @required this.reservationId,
    @required this.context,
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
  final ModifyReservationBloc _modifyReservationBloc;
  final ReservationsRepository _reservationsRepository;
  final NotificationHandler _notificationHandler;
  StreamSubscription _modifyReservationSubscription;

  ReservationsBloc({
    @required ModifyReservationBloc modifyReservationBloc,
    @required ReservationsRepository reservationsRepository,
    @required NotificationHandler notificationHandler,
  })  : _modifyReservationBloc = modifyReservationBloc,
        _reservationsRepository = reservationsRepository,
        _notificationHandler = notificationHandler {
    _modifyReservationSubscription = _modifyReservationBloc.listen((state) {
      if (state is CreateReservationSuccess) {
        add(_UpdateReservations(
          newReservationLocation: state.location,
          newReservationStartTime: state.startTime,
        ));
      }
    });
  }

  @override
  Future<void> close() async {
    await _modifyReservationSubscription.cancel();
    return super.close();
  }

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
    } else if (event is _UpdateReservations) {
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
        yield* _updateReservations(
          reservations: reservations ?? [],
          where: ((r) =>
              r.startTime == event.newReservationStartTime &&
              r.location?.id == null),
          alwaysSendUpdate: true,
          updatedReservation: ((r) async {
            return Reservation.withUpdatedLocation(
                r, event.newReservationLocation);
          }),
        );
      } catch (_) {
        print('Could not retrieve any reservations.');
        yield ReservationsLoadFail();
      }
    } else if (event is ToggleReminderForReservation) {
      if (state is ReservationsLoaded) {
        final reservations = (state as ReservationsLoaded).reservations;

        yield* _updateReservations(
          reservations: reservations,
          where: ((r) => r.id == event.reservationId),
          updatedReservation: ((r) async {
            int notificationId;
            if (r.reminderNotificationId != null) {
              _notificationHandler.cancelNotification(r.reminderNotificationId);
            } else {
              notificationId =
                  await _notificationHandler.scheduleReservationReminder(
                reservation: r,
                context: event.context,
              );
            }
            return Reservation.withUpdatedNotificationId(r, notificationId);
          }),
        );
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
    final fetchedReservations = await _reservationsRepository
        .getReservations()
        .timeout(Duration(seconds: timeoutInSec));

    fetchedReservations?.sort((a, b) => a.startTime.compareTo(b.startTime));
    // Update with persisted data
    return fetchedReservations?.map((r) {
      final localReservation = loadedReservations.firstWhere(
          (loadedReservation) => loadedReservation.id == r.id,
          orElse: () => null);
      return Reservation.withLocalData(
        r,
        localReservation?.location,
        localReservation?.reminderNotificationId,
      );
    })?.toList();
  }

  Stream<ReservationsState> _updateReservations({
    @required List<Reservation> reservations,
    @required bool where(Reservation reservation),
    bool alwaysSendUpdate = false,
    @required Future<Reservation> updatedReservation(Reservation reservation),
  }) async* {
    final index = reservations.indexWhere(where);
    if (index != -1) {
      final reservation = reservations[index];

      final Reservation newReservation = await updatedReservation(reservation);

      final newReservations = List<Reservation>.from(reservations);
      newReservations[index] = newReservation;

      _reservationsRepository.saveReservations(newReservations);
      yield ReservationsLoaded(newReservations);
      return;
    }
    if (alwaysSendUpdate) {
      yield ReservationsLoaded(reservations);
    }
  }
}
