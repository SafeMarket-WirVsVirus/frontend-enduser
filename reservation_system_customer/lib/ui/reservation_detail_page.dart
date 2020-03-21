import 'package:flutter/material.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repository/data/data.dart';

Future<void> _ackAlert(BuildContext context, String id) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Container(
        height: 400,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('Dein Ticket:',
                style: Theme.of(context).textTheme.headline,),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child:  QrImage(
                  data: id,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


class ReservationDetailPage extends StatefulWidget {
  final Reservation reservation;

  ReservationDetailPage({this.reservation});

  @override
  _ReservationDetailPageState createState() => _ReservationDetailPageState(reservation);
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  final DateFormat dateFormat = DateFormat("dd.MM.yyyy");
  final DateFormat timeFormat = DateFormat("hh:mm");
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Reservation reservation;
  bool reminder = false;
  Widget reminderIcon = Icon(Icons.notifications_off);

//  TODO actually remind the user
  SnackBar reminderSnackBar = SnackBar(
    content: Text("Erinnerung 30 Minuten vor deinem Termin"),
    duration: Duration(seconds: 3),
  );

  _ReservationDetailPageState(this.reservation);

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
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Text("Du hast einen Shopping-Slot bei"),
              Text("${reservation.location.name}",
                style: Theme.of(context).textTheme.headline,),
              Text("am"),
              Text("${dateFormat.format(reservation.timeSlot.startTime)}",
                style: Theme.of(context).textTheme.headline,),
              Text("um"),
              Text("${timeFormat.format(reservation.timeSlot.startTime)}",
                style: Theme.of(context).textTheme.headline,),

              Padding(
                padding: EdgeInsets.all(30),
                child: RaisedButton(
                  child: Icon(Icons.navigation),
                  onPressed: _navigate,
                ),
              )
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.confirmation_number),
        onPressed: () {
          _ackAlert(context, reservation.id);
        },
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

  void _navigate() {
//    TODO navigate
  }
}