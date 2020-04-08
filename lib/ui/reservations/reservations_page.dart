import 'package:reservation_system_customer/ui/about/about_page.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_list.dart';
import 'package:reservation_system_customer/ui_imports.dart';

class ReservationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => AboutPage())),
          )
        ],
        title: Row(
          children: <Widget>[
            Image(
              height: 25,
              image: AssetImage("assets/005-calendar.png"),
              fit: BoxFit.fitHeight,
            ),
            SizedBox(width: 15),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)
                    .reservationsNavBarTitle
                    .toUpperCase(),
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ReservationsBloc, ReservationsState>(
        builder: (context, state) {
          if (state is ReservationsInitial || state is ReservationsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReservationsLoaded) {
            if (state.reservations?.isEmpty ?? true) {
              return _NoReservations();
            }
            return ReservationsList(reservations: state.reservations);
          }
          return Container();
        },
      ),
    );
  }
}

class _NoReservations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          AppLocalizations.of(context).reservationsListEmpty,
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
