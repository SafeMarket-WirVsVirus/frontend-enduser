import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/ui/map/map_marker.dart';
import 'package:reservation_system_customer/ui/map/map_view.dart';
import 'package:reservation_system_customer/ui_imports.dart';

import 'location_detail_sheet.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          List<MapMarker> markers = [];
          if (state is! MapInitial) {
            state.locations.forEach((location) {
              final id = '${location.id}';
              markers.add(MapMarker(
                id: "$id",
                position: location.position,
                consumeTapEvents: true,
                icon: state.markerIcons[location.fillStatus],
                onTap: () {
                  //TODO: Visible area on marker
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    builder: (_) => MultiProvider(
                      providers: [
                        BlocProvider(
                            create: (_) =>
                                BlocProvider.of<ReservationsBloc>(context)),
                        Provider(
                          create: (_) => Provider.of<ReservationsRepository>(
                              context,
                              listen: false),
                        ),
                        Provider(
                          create: (_) => Provider.of<LocationsRepository>(
                              context,
                              listen: false),
                        ),
                      ],
                      child: LocationDetailSheet(
                        location: location,
                        scaffoldContext: context,
                      ),
                    ),
                  );
                },
              ));
            });
          }
          return MapView(
            markers: markers,
          );
        },
      ),
    );
  }
}
