import 'package:flutter/material.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../repository/data/data.dart';

class ReservationDetailPage extends StatefulWidget {
  final Reservation reservation;

  ReservationDetailPage({this.reservation});

  @override
  _ReservationDetailPageState createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool reminder = false;
  Widget reminderIcon = Icon(Icons.notifications_off);
//  TODO actually remind the user
  SnackBar reminderSnackBar = SnackBar(
    content: Text("Erinnerung 30 Minuten vor deinem Termin"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.reservation.location.name),
        actions: <Widget>[
          IconButton(
            icon: reminderIcon,
            onPressed: () {
              _reminderSwitch();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              Navigator.pop(context); //TODO delete reservation
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            QrImage(
              data: widget.reservation.id,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            Row(
              children: <Widget>[
                Text("Erinnern"),
                Switch(
                  value: reminder, // TODO!
                  onChanged: (value) {
                    setState(() {
                      reminder = value;
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _reminderSwitch() {
    setState(() {
      reminder = !reminder;
      if (reminder) {
        reminderIcon = Icon(Icons.notifications_active);
        _scaffoldKey.currentState.showSnackBar(reminderSnackBar);
      } else {
        reminderIcon = Icon(Icons.notifications_off);
      }
    });
  }
}