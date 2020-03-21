import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'data/data.dart';

class LocationsRepository {
  var locations = [
    Location(
        id: 'id1',
        location: LatLng(48.160490, 11.555184),
        locationName: 'Supermarkt A'),
    Location(
        id: 'id2',
        location: LatLng(47.960490, 11.355184),
        locationName: 'Supermarkt B'),
  ];

  Future<List<Location>> getStores(LatLng position) async {
    //TODO: Fetch the real reservations
    await Future.delayed(Duration(seconds: 2));
    return locations;
  }
}
