import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:reservation_system_customer/repository/data/data.dart';
import 'package:reservation_system_customer/repository/repository.dart';

import '../../app_localizations.dart';

class ReservationListDetail extends StatelessWidget {
  final Reservation reservation;

  const ReservationListDetail({
    Key key,
    this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
        child: QrImage(
          data: reservation.id.toString(),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          errorCorrectionLevel: QrErrorCorrectLevel.H,
          embeddedImage: AssetImage('assets/AppIcon.png'),
        ),
      ),
      Align(
          alignment: Alignment.topRight,
          child: FlatButton(
              child: Icon(Icons.delete),
              onPressed: () {
                _deleteDialog(context, reservation);
              }))
    ]);
  }
}

Future<void> _deleteDialog(BuildContext context, Reservation reservation) {
  var reservationsRepository =
      Provider.of<ReservationsRepository>(context, listen: false);
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate("delete_res_1") +
            '${reservation.location?.name ?? ''}' +
            AppLocalizations.of(context).translate("delete_res_2"),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppLocalizations.of(context).translate("cancel")),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
            child: Text(AppLocalizations.of(context).translate("ok")),
            onPressed: () {
              reservationsRepository.cancelReservation(
                locationId: reservation.location.id,
                reservationId: reservation.id,
              );
              Navigator.of(context).pop();
            }),
      ],
    ),
  );
}
