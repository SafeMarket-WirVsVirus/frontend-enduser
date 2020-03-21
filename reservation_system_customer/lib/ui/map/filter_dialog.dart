import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  double sliderValue = 3;
  List<Color> sliderColor = [Colors.green, Colors.orange, Colors.red];
  List<String> sliderTips = [
    "Nur die Läden mit sehr geringer Auslastung werden angezeigt "
        "(optimal für besonders gefährdete Personen)",
    "Die Läden mit sehr hoher Auslastung werden nicht angezeigt",
    "Alle Läden werden angezeigt, auch wenn gerade viel los ist"
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Auslastungsniveau",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Slider(
              onChanged: (double value) {
                setState(() {
                  if (value > 0) sliderValue = value;
                });
              },
              value: sliderValue,
              min: 0.0,
              max: 3.0,
              divisions: 3,
              activeColor: sliderColor[(sliderValue - 1).round()],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(sliderTips[(sliderValue - 1).round()]),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ));
  }
}
