import 'package:flutter/material.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:reservation_system_customer/repository/data/reservation.dart';

import '../../app_localizations.dart';
import 'reservation_detail_page.dart';

class ReservationsListPage2 extends StatefulWidget {
  @override
  _ReservationsListPage2State createState() => _ReservationsListPage2State();
}

class _ReservationsListPage2State extends State<ReservationsListPage2> {
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  List<Item> _data;

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
        _data = generateItems(state.reservations);
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
              body: SingleChildScrollView(
                child: Container(
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _data[index].isExpanded = !isExpanded;
                        print("Tap");
                      });
                    },
                    children: _data.map<ExpansionPanel>((Item item) {
                      return ExpansionPanel(
                          canTapOnHeader: true,
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(item.reservation.location.name),
                            );
                          },
                          body: ListTile(
                            title: Text("Testcity"),
//                            title: Text(item.reservation.location.address_city),
                            subtitle:
                              Text("Testaddress")
//                                Text(item.reservation.location.address_street),
                          ),
                          isExpanded: item.isExpanded,
                      );
                    }).toList(),
                  ),
                ),
              ));
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
                  style: Theme.of(context).textTheme.title,
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

  List<Item> generateItems(List<Reservation> reservations) {
    List<Item> items = List();
    reservations.forEach((res) => items.add(Item(reservation: res)));
    return items;
  }
}

class Item {
  final Reservation reservation;
  bool isExpanded;

  Item({
    this.reservation,
    this.isExpanded = true,
  });
}
