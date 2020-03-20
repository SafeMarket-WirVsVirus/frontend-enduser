import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'data/data.dart';

class ReservationsRepository {
  Future<List<Reservation>> getReservations() async {
    await Future.delayed(Duration(seconds: 3));
    return [
      Reservation(
        locationName: 'Supermarkt A',
        location: LatLng(48.160490, 11.555184),
        timeSlot: TimeSlot(
          startTime: DateTime.now().add(Duration(hours: 3)),
          endTime: DateTime.now().add(Duration(hours: 4)),
        ),
      ),
      Reservation(
        locationName: 'Supermarkt B',
        location: LatLng(47.960490, 11.355184),
        timeSlot: TimeSlot(
          startTime: DateTime.now().add(Duration(hours: 5)),
          endTime: DateTime.now().add(Duration(hours: 6)),
        ),
      ),
    ];
  }
}
