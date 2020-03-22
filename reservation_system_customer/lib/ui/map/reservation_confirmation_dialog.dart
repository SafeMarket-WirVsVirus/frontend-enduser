import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/app_localizations.dart';

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
            child: Text(AppLocalizations.of(context).translate("res_success")),
          ),
          Icon(Icons.check),
            ],
          ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
              AppLocalizations.of(context).translate("res_detail_1") +
                  " ${this.name} " +
                  AppLocalizations.of(context).translate("res_detail_2") +
                  " ${dateFormat.format(this.startTime)} " +
                  AppLocalizations.of(context).translate("res_detail_3") +
                  " ${timeFormat.format(this.startTime)} "),
//              'Du hast am ${dateFormat.format(this.startTime)} um ${timeFormat.format(this.startTime)} einen Shopping-Slot bei ${this.name} reserviert.'),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              },
            child: Text(AppLocalizations.of(context).translate("ok")),
        )
      ],
    );
  }
}
