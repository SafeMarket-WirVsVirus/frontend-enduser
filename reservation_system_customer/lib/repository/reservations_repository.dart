import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'data/data.dart';

class ReservationsRepository {
  var reservations = [
    Reservation(
      id: 'id1',
      locationName: 'Supermarkt A',
      location: LatLng(48.160490, 11.555184),
      timeSlot: TimeSlot(
        startTime: DateTime.now().add(Duration(hours: 3)),
        endTime: DateTime.now().add(Duration(hours: 4)),
      ),
    ),
    Reservation(
      id: 'id2',
      locationName: 'Supermarkt B',
      location: LatLng(47.960490, 11.355184),
      timeSlot: TimeSlot(
        startTime: DateTime.now().add(Duration(hours: 5)),
        endTime: DateTime.now().add(Duration(hours: 6)),
      ),
    ),
  ];

  Future<List<Reservation>> cancelReservation(Reservation reservation) async {
    //TODO: Cancel the reservation
    await Future.delayed(Duration(seconds: 1));
    reservations.remove(reservation);
    return reservations;
  }

  Future<List<Reservation>> getReservations() async {
    //TODO: Fetch the real reservations
    await Future.delayed(Duration(seconds: 2));
    return reservations;
  }
}
