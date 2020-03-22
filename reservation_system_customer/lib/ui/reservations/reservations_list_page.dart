import 'package:flutter/material.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../app_localizations.dart';
import 'reservation_detail_page.dart';

class ReservationsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationsBloc, ReservationsState>(
        builder: (context, state) {
      if (state is ReservationsInitial) {
        return Container();
      } else if (state is ReservationsLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is ReservationsLoaded) {
        if (state.reservations.length > 0) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    child: Image(
                        image: AssetImage("assets/005-calendar.png"),
                        fit: BoxFit.fitHeight),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          AppLocalizations.of(context)
                              .translate("reservations_title"),
                          style: TextStyle(color: Color(0xff322153)))),
                ],
              ),
            ),
            body: ListView.builder(
                itemCount: state.reservations.length,
                itemBuilder: (_, int index) {
                  final item = state.reservations[index];
                  return ReservationListEntry(item: state.reservations[index]);
                }),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  AppLocalizations.of(context).translate("no_reservations"),
                  style: Theme
                      .of(context)
                      .textTheme
                      .title,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          );
        }
      }
      return Container();
        });
  }
}

class ReservationListEntry extends StatelessWidget {
  final item;

  const ReservationListEntry({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return Dismissible(
        key: Key('${item.id}'),
        background: Container(
          color: Colors.red,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.delete, size: 40))
              ]),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text(
                    AppLocalizations.of(context).translate("delete_res_1") +
                        '${item.location?.name}' +
                        AppLocalizations.of(context).translate("delete_res_2"),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                          AppLocalizations.of(context).translate("cancel")),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    FlatButton(
                      child: Text(AppLocalizations.of(context).translate("ok")),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
          );
        },
        onDismissed: (direction) async {
          BlocProvider.of<ReservationsBloc>(context).add(CancelReservation(
            reservationId: item.id,
            locationId: item.location.id,
          ));
        },
        child: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 50,
                    child: Image(
                      image: AssetImage('assets/002-shop.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            item.location.name,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline,
                            softWrap: true,
                          ),
                          Text(
                            item.location.address ?? "",
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle,
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 70,
                    child: FlatButton(
                      child: Image(
                        image: AssetImage(
                          'assets/004-bell.png',
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    width: 70,
                    child: FlatButton(
                      child: Image(
                          image: AssetImage('assets/school-material.png'),
                          fit: BoxFit.fitWidth),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
              Text(DateFormat.yMMMMd("de_DE").add_jm().format(item.startTime))
            ],
          ),
        ));
  }
}
