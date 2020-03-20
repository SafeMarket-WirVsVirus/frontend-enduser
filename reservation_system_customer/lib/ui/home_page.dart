import 'package:flutter/material.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool fetchingData = true;
  List<Reservation> items = [];
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  void initState() {
    super.initState();
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
          return new ListTile(
            title: Text(item.locationName),
            subtitle:
                Text('Start: ${dateFormat.format(item.timeSlot.startTime)}'),
          );
        });
  }

  _fetchData() async {
    final reservations = await ReservationsRepository().getReservations();
    setState(() {
      fetchingData = false;
      items = reservations;
    });
  }
}
