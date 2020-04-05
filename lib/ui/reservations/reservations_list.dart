import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/ui/reservations/reservation_list_detail.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_list_header.dart';
import 'package:reservation_system_customer/ui_imports.dart';

class ReservationsList extends StatefulWidget {
  final List<Reservation> reservations;

  const ReservationsList({Key key, this.reservations}) : super(key: key);

  @override
  _ReservationsListState createState() => _ReservationsListState();
}

class _ReservationsListState extends State<ReservationsList> {
  int expandedReservationId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          )),
        ),
        SingleChildScrollView(
          child: Container(
            color: Theme.of(context).accentColor,
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                final reservation = widget.reservations[index];
                setState(() {
                  if (isExpanded) {
                    expandedReservationId = null;
                  } else {
                    if (!isExpanded && !_isExpired(reservation.startTime)) {
                      expandedReservationId = reservation.id;
                    } else {
                      expandedReservationId = null;
                    }
                  }
                });
              },
              children: widget.reservations.map<ExpansionPanel>((reservation) {
                final isExpired = _isExpired(reservation.startTime);

                return ExpansionPanel(
                  canTapOnHeader:
                      !isExpired || reservation.id == expandedReservationId,
                  isExpanded:
                      reservation.id == expandedReservationId && !isExpired,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Opacity(
                      opacity: isExpired ? 0.3 : 1,
                      child: ReservationListHeader(
                        reservation: reservation,
                      ),
                    );
                  },
                  body: ReservationListDetail(
                    reservation: reservation,
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  bool _isExpired(DateTime time) {
    return time.difference(DateTime.now()) <
        -Constants.minDurationBeforeNowBeforeExpired;
  }
}
