import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReservationConfirmationDialog extends StatelessWidget {
  final name;
  ReservationConfirmationDialog(this.name);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reservation successful'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('You have booked a slot for ${this.name}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      )
    );
  }
}
