import 'package:flutter/material.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
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
        return ListView.builder(
            itemCount: state.reservations.length,
            itemBuilder: (_, int index) {
              final item = state.reservations[index];
              return Dismissible(
                key: Key(item.id),
                background: Container(color: Theme.of(context).accentColor),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          'Do you really want to delete the reservation for ${item.locationName}?'),
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
                      .add(CancelReservation(item.id));
                },
                child: ListTile(
                  title: Text(item.locationName),
                  subtitle: Text(
                      'Start: ${dateFormat.format(item.timeSlot.startTime)}'),
                ),
              );
            });
      }
      return Container();
    });
  }
}
