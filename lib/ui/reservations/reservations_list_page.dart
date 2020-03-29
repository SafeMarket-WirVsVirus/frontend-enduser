import 'package:flutter/material.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/ui/reservations/reservation_list_detail.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_list_header.dart';

import '../../app_localizations.dart';

class ReservationsListPage extends StatefulWidget {
  @override
  _ReservationsListPageState createState() => _ReservationsListPageState();
}

class _ReservationsListPageState extends State<ReservationsListPage> {
  int expandedReservationId;

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
                          final reservation = state.reservations[index];
                          setState(() {
                            if (isExpanded) {
                              expandedReservationId = null;
                            } else {
                              if (!isExpanded &&
                                  !_isExpired(reservation.startTime)) {
                                expandedReservationId = reservation.id;
                              } else {
                                expandedReservationId = null;
                              }
                            }
                          });
                        },
                        children: state.reservations
                            .map<ExpansionPanel>((reservation) {
                          final isExpired = _isExpired(reservation.startTime);

                          return ExpansionPanel(
                            canTapOnHeader: !isExpired ||
                                reservation.id == expandedReservationId,
                            isExpanded:
                                reservation.id == expandedReservationId &&
                                    !isExpired,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
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

  bool _isExpired(DateTime time) {
    return time.difference(DateTime.now()) <
        -Constants.minDurationBeforeNowBeforeExpired;
  }
}
