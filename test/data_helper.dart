import 'package:flutter/foundation.dart';
import 'package:reservation_system_customer/repository/data/data.dart';

class ReservationFactory {
  static Reservation createReservation({
    @required int id,
    DateTime startTime,
    int reminderNotificationId,
    ReservationLocation location,
  }) =>
      Reservation(
        id: id,
        location: location,
        startTime: startTime ?? DateTime.now().add(Duration(minutes: id)),
        codeWords: ['Apple', 'Code'],
        reminderNotificationId: reminderNotificationId,
      );
}

class ReservationLocationFactory {
  static ReservationLocation createLocation({@required int id}) =>
      ReservationLocation(
        id: id,
        name: 'a name',
        address: 'an address',
      );
}

class LocationFactory {
  static Location createLocation({
    @required int id,
    LocationType locationType,
  }) =>
      Location(
        id: id,
        name: null,
        latitude: 10,
        longitude: 20,
        fillStatus: FillStatus.yellow,
        openingHours: [],
        slotDuration: null,
        slotSize: null,
        address: null,
        locationType: locationType ?? LocationType.supermarket,
      );
}
