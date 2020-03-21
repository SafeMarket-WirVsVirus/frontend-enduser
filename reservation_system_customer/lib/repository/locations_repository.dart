import 'dart:ffi';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/repository/data/capacity_utilization.dart';

import 'data/data.dart';

class LocationsRepository {
  var locations = [
    Location(
      id: 'id1',
      position: LatLng(48.160490, 11.555184),
      name: 'Supermarkt A',
      fillStatus: FillStatus.green,
        slot_duration: Duration(minutes: 10)
    ),
    Location(
      id: 'id2',
      position: LatLng(47.960490, 11.355184),
      name: 'Supermarkt B',
      fillStatus: FillStatus.red,
        slot_duration: Duration(minutes: 10)
    ),
  ];

  Future<List<Location>> getStores(LatLng position) async {
    //TODO: Fetch the real reservations
    await Future.delayed(Duration(seconds: 2));

    //TODO: Delete dummy data
    Capacity_utilization cu1 = Capacity_utilization();
    cu1.utilization = 0.9;
    Daily_Utilization du = Daily_Utilization(date: DateTime.now());
    for (var i = 1; i < 20; i++) {
      du.timeslot_data.add(Timeslot_Data(
          timeslot: TimeSlot(
            startTime: DateTime.now().add(new Duration(minutes: i * 10)),
            endTime: DateTime.now().add(new Duration(minutes: (i + 1) * 10)),
          ),
          bookings: i,
          utilization: i / 10));
    }
    cu1.daily_utilization.add(du);
    Capacity_utilization cu2 = cu1;
    cu2.utilization = 0.1;
    locations[0].capacity_utilization = cu1;
    locations[1].capacity_utilization = cu2;
    return locations;
  }
}
