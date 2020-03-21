import 'package:flutter/material.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ReservationsRepository reservationsRepository;
  bool fetchingData = true;
  List<Reservation> items = [];
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  void initState() {
    super.initState();
    reservationsRepository = ReservationsRepository();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if (fetchingData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, int index) {
          final item = items[index];
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
              final reservations =
                  await reservationsRepository.cancelReservation(item);
              setState(() {
                fetchingData = false;
                items = reservations;
              });
            },
            child: ListTile(
              title: Text(item.locationName),
              subtitle:
                  Text('Start: ${dateFormat.format(item.timeSlot.startTime)}'),
            ),
          );
        });
  }

  _fetchData() async {
    final reservations = await reservationsRepository.getReservations();
    setState(() {
      fetchingData = false;
      items = reservations;
    });
  }
}
