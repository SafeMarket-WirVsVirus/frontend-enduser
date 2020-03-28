import 'package:flutter/material.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:reservation_system_customer/repository/data/reservation.dart';
import 'package:reservation_system_customer/ui/reservations/reservation_list_detail.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_list_entry.dart';

import '../../app_localizations.dart';

class ReservationsListPage extends StatefulWidget {
  @override
  _ReservationsListPageState createState() => _ReservationsListPageState();
}

class _ReservationsListPageState extends State<ReservationsListPage> {
  List<Item> _data = new List();

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
        updateList(state.reservations);
        if (state.reservations.length > 0) {
          return Scaffold(
              appBar: AppBar(
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
                            .translate("reservations_title"),
                      ),
                    ),
                  ],
                ),
              ),
              body: Stack(
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
                          setState(() {
                            for (int i = 0; i < _data.length; i++) {
                              _data[i].isExpanded = false;
                            }
                            _data[index].isExpanded = !isExpanded;
                          });
                        },
                        children: _data.map<ExpansionPanel>((Item item) {
                          return ExpansionPanel(
                            canTapOnHeader: true,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ReservationListEntry(
                                  reservation: item.reservation);
                            },
                            body: Padding(
                              padding: EdgeInsets.all(10),
                              child: ReservationListDetail(
                                reservation: item.reservation,
                              ),
                            ),
                            isExpanded: item.isExpanded,
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
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

  void updateList(List<Reservation> reservations) {
    reservations.forEach((res) => addIfNew(res));
  }

  void addIfNew(Reservation res) {
    bool isNew = true;
    if (_data == null) {
      _data.add(Item(reservation: res));
      return;
    }
    _data.forEach((item) => {if (item.reservation.id == res.id) isNew = false});
    if (isNew) _data.add(Item(reservation: res));
  }
}

class Item {
  final Reservation reservation;
  bool isExpanded;

  Item({
    this.reservation,
    this.isExpanded = false,
  });

  @override
  bool operator ==(Object other) =>
      other is Item && reservation.id == other.reservation.id;

  @override
  int get hashCode => reservation.id;
}
