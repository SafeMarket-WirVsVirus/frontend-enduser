import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:reservation_system_customer/ui_imports.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: QrImage(
          data: reservation.id.toString(),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          errorCorrectionLevel: QrErrorCorrectLevel.H,
          embeddedImage: AssetImage('assets/AppIcon.png'),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
            children: reservation.codeWords.map<Widget>((String word) {
          return Expanded(
            child: Center(
              child: Text(word, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        }).toList()),
      ),
      Align(
          alignment: Alignment.topRight,
          child: FlatButton(
              child: Icon(Icons.delete_outline),
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
        reservation.location?.name == null
            ? AppLocalizations.of(context)
                .deleteReservationDialogTitleWithoutLocation
            : AppLocalizations.of(context)
                .deleteReservationDialogTitle(reservation.location?.name),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppLocalizations.of(context).commonCancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
            child: Text(AppLocalizations.of(context).commonOk),
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
