import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_list_page.dart';
import 'package:reservation_system_customer/ui/map/map_page.dart';

import '../app_localizations.dart';
import 'loading_page.dart';

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
    return BlocBuilder<ReservationsBloc, ReservationsState>(
        builder: (context, state) {
      if (state is ReservationsLoaded) {
        return _HomePage();
      }
      return LoadingPage();
    });
  }
}

class _HomePage extends StatefulWidget {
  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    var state = BlocProvider.of<ReservationsBloc>(context).state;
    if (state is ReservationsLoaded &&
        (state.reservations?.isNotEmpty ?? false)) {
      _selectedIndex = 0;
    }
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
            icon: new Image.asset(
              'assets/005-calendar.png',
              height: 40,
            ),
            title: Text(AppLocalizations.of(context).translate("reservations")),
          ),
          BottomNavigationBarItem(
            icon: new Image.asset(
              'assets/001-loupe.png',
              height: 40,
            ),
            title: Text(AppLocalizations.of(context).translate("map")),
          )
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
