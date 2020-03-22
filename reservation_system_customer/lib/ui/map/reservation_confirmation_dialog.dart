import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ReservationConfirmationDialog extends StatelessWidget {
  final name;
  final startTime;
  final DateFormat dateFormat = DateFormat("dd.MM.yyyy");
  final DateFormat timeFormat = DateFormat("hh:mm");
  ReservationConfirmationDialog(this.name, this.startTime);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //title: Text('Reservation successful'),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text('Reservation successfull'),
          ),
          Icon(Icons.check),
            ],
          ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Du hast am ${dateFormat.format(this.startTime)} um ${timeFormat.format(this.startTime)} einen Shopping-Slot bei ${this.name} reserviert.'),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              },
            child: Text('OK'),
        )
      ],
    );
  }
}
