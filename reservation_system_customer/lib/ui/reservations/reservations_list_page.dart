import 'package:flutter/material.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../app_localizations.dart';
import 'reservation_detail_page.dart';

class ReservationsListPage extends StatelessWidget {
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationsBloc, ReservationsState>(
        builder: (context, state) {
      if (state is ReservationsInitial) {
        return Container();
      } else if (state is ReservationsLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is ReservationsLoaded) {
        if (state.reservations.length > 0) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    child: Image(
                        image: AssetImage("assets/005-calendar.png"),
                        fit: BoxFit.fitHeight),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          AppLocalizations.of(context)
                              .translate("reservations_title"),
                          style: TextStyle(color: Color(0xff322153)))),
                ],
              ),
            ),
            body: ListView.builder(
                itemCount: state.reservations.length,
                itemBuilder: (_, int index) {
                  final item = state.reservations[index];
                  return Dismissible(
                    key: Key('${item.id}'),
                    background: Container(
                      color: Colors.red,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(Icons.delete, size: 40))
                          ]),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                              'Do you really want to delete the reservation for ${item.location?.name}?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) async {
                      BlocProvider.of<ReservationsBloc>(context)
                          .add(CancelReservation(
                        reservationId: item.id,
                        locationId: item.location.id,
                      ));
                    },
                    child: ListTile(
                      title: Text(item.location?.name ?? ''),
                      subtitle:
                          Text('Start: ${dateFormat.format(item.startTime)}'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReservationDetailPage(reservation: item)));
                      },
                    ),
                  );
                }),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Du hast aktuell keine offenen Reservationen.",
                  style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          );
        }
      }
      return Container();
    });
  }
}
