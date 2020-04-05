import 'package:flutter/gestures.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_list.dart';
import 'package:reservation_system_customer/ui_imports.dart';
import 'package:url_launcher/url_launcher.dart';

class ReservationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text("About"),
              ),
              PopupMenuItem(
                value: 1,
                child: Text("Second"),
              ),
            ],
            onSelected: (int value) {
              print("selected $value");

              switch (value) {
                case 0:
                  showAboutDialog(
                      context: context,
                      applicationVersion: '1.0.1',
                      applicationIcon: Image.asset(
                        "assets/AppIcon.png",
                        width: 50,
                        height: 50,
                      ),
                      children: <Widget>[
                        new RichText(
                          text: new TextSpan(
                            children: [
                              TextSpan(
                                text: 'Our project was created during the ',
                                style: new TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                              TextSpan(
                                text: '#WirVsVirus hackathon',
                                style: new TextStyle(
                                    color: Colors.blue, fontSize: 17),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(
                                        'https://wirvsvirushackathon.devpost.com/');
                                  },
                              ),
                              TextSpan(
                                text:
                                    '.\n\nSafeMarket is a digital reservation service which minimizes infections and queues. It allows people visiting a place to see the future, planned occupancy rate. Our first use case during the Corona pandemic is the visit of a store such as a supermarket with minimizing social interactions.',
                                style: new TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ]);

                  break;
              }
            },
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
