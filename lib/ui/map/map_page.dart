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
                id: id,
                fillStatus: location.fillStatus,
                position: location.position,
                consumeTapEvents: true,
                icon: state.markerIcons[location.id],
                onTap: () {
                  // only create the bloc providers once prevents issues when disposing the bottom sheet
                  final blocProviders = [
                    BlocProvider.value(
                        value: BlocProvider.of<ModifyReservationBloc>(context)),
                    Provider(
                      create: (_) => Provider.of<LocationsRepository>(context,
                          listen: false),
                    ),
                  ];
                  //TODO: Visible area on marker
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    builder: (_) => MultiProvider(
                      providers: blocProviders,
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
