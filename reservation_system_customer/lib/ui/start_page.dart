import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            icon: new Image.asset('assets/005-calendar.png', height: 40,),
            title: Text('MEINE SLOTS'),
          ),
          BottomNavigationBarItem(
            icon: new Image.asset('assets/001-loupe.png', height: 40,),
            title: Text('SUCHE'),
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
