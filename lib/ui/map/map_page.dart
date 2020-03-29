import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui/map/map_view.dart';

import 'location_detail_sheet.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          List<Marker> markers = [];
          if (state is! MapInitial) {
            markers = state.locations.map((location) {
              return Marker(
                point: LatLng(
                  location.position.latitude,
                  location.position.longitude,
                ),
                height: 60,
                width: 40,
                builder: ((context) {
                  return GestureDetector(
                    onTap: () => _openLocationDetail(context, location),
                    child: Image.asset(
                      _imageName(location.fillStatus),
                      alignment: Alignment.bottomCenter,
                    ),
                  );
                }),
                anchorPos: AnchorPos.align(AnchorAlign.bottom),
              );
            }).toList();
          }
          return MapView(
            markers: markers,
          );
        },
      ),
    );
  }

  String _imageName(FillStatus fillStatus) {
    switch (fillStatus) {
      case FillStatus.green:
        return 'assets/icon_green.png';
      case FillStatus.yellow:
        return 'assets/icon_yellow.png';
      case FillStatus.red:
        break;
    }
    return 'assets/icon_red.png';
  }

  _openLocationDetail(
    BuildContext context,
    Location location,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      builder: (_) => BlocProvider(
        create: (_) => BlocProvider.of<ReservationsBloc>(context),
        child: Provider(
            create: (_) =>
                Provider.of<ReservationsRepository>(context, listen: false),
            child: LocationDetailSheet(
              location: location,
              scaffoldContext: context,
            )),
      ),
    );
  }
}
