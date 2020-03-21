import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'data/data.dart';

class ReservationsRepository {
  var reservations = [
    Reservation(
      id: 'id1',
      location: Location(
        id: 'reservation1',
        name: 'Supermarkt A',
        position: LatLng(48.160490, 11.555184),
      ),
      timeSlot: TimeSlot(
        startTime: DateTime.now().add(Duration(hours: 3)),
        endTime: DateTime.now().add(Duration(hours: 4)),
      ),
    ),
    Reservation(
      id: 'id2',
      location: Location(
        id: 'reservation2',
        name: 'Supermarkt B',
        position: LatLng(47.960490, 11.355184),
      ),
      timeSlot: TimeSlot(
        startTime: DateTime.now().add(Duration(hours: 5)),
        endTime: DateTime.now().add(Duration(hours: 6)),
      ),
    ),
  ];

  Future<List<Reservation>> cancelReservation(String id) async {
    //TODO: Cancel the reservation
    await Future.delayed(Duration(seconds: 1));
    reservations.removeWhere((item) => item.id == id);
    return reservations;
  }

  Future<List<Reservation>> getReservations() async {
    //TODO: Fetch the real reservations
    await Future.delayed(Duration(seconds: 2));
    return reservations;
  }
}
