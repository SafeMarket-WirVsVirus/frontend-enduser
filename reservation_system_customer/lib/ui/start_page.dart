import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/app_localizations.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_list_page.dart';
import 'package:reservation_system_customer/ui/map/map_page.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReservationsBloc>(context).add(LoadReservations());
    Provider.of<UserRepository>(context, listen: false)..loadUserPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(AppLocalizations.of(context).translate("reservations")),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text(AppLocalizations.of(context).translate("map")),
          ),
        ],
      ),
      body: _page(_selectedIndex),
    );
  }

  Widget _page(int index) {
    switch (index) {
      case 0:
        return ReservationsListPage();
      case 1:
        return MapPage();
      default:
        return Container();
    }
  }
}
