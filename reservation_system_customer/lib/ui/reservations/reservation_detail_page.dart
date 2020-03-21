import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../repository/data/data.dart';

Future<void> _ticketDialog(BuildContext context, String id) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
  GoogleMapController mapController;
  final Set<Marker> markers = new Set();

  @override
  void initState() {
    markers.add(Marker(
      markerId: MarkerId(reservation.location.id),
      position: reservation.location.position,
    ));
  }

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
      body: Column(
        children: <Widget>[
          Padding(
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
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Expanded(
            child: Container(
              constraints: BoxConstraints.expand(),
              child: GoogleMap(
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                mapType: MapType.normal,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    reservation.location.position.latitude,
                    reservation.location.position.longitude,
                  ),
                  zoom: 15,
                ),
                onMapCreated: _onMapCreated,
                markers: markers,
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),

          FlatButton(
            child: Text("Ticket",
              style: Theme.of(context).textTheme.headline,),
            onPressed: () {
              _ticketDialog(context, reservation.id);
            },
          ),

          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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