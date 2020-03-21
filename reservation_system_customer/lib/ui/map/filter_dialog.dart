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
  int _selectedIndex = 0;

  List<bool> traffic = [true, true, true];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child:Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() {
            _selectedIndex = index;
          }),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.traffic),
                title: Text("Auslastung")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: Text("Geschäfte")
            ),
          ],
        ),

        body: _page(_selectedIndex),
      )
    );
  }

  Widget _page(int index) {
    switch (index) {
      case 0:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Zeige Geschäfte mit:",
              style: Theme.of(context).textTheme.headline,),
            ),
            SwitchListTile(
              value: traffic[0],
              title: Text("hoher Auslastung"),
              onChanged: (bool value) {
                setState(() {
                  traffic[0] = value;
                });
              },
            ),
            SwitchListTile(
              value: traffic[1],
              title: Text("mittlerer Auslastung"),
              onChanged: (bool value) {
                setState(() {
                  traffic[1] = value;
                });
              },
            ),
            SwitchListTile(
              value: traffic[2],
              title: Text("geringer Auslastung"),
              onChanged: (bool value) {
                setState(() {
                  traffic[2] = value;
                });
              },
            ),
          ],
        );
      case 1:
        return Container();
      default:
        return Container();
    }
  }
}