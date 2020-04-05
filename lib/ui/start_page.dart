import 'package:provider/provider.dart';
import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui/map/map_page.dart';
import 'package:reservation_system_customer/ui/offline_page.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_page.dart';
import 'package:reservation_system_customer/ui_imports.dart';

import 'loading_page.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
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
      } else if (state is ReservationsLoadFail) {
        return OfflinePage();
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
  final pages = [_BottomBarType.reservations, _BottomBarType.map];
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
        items: pages
            .map((type) => BottomNavigationBarItem(
                  icon: Image.asset(type.iconName, height: 30),
                  title: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(type.label(context).toUpperCase()),
                  ),
                ))
            .toList(),
      ),
      body: _page(_selectedIndex),
    );
  }

  Widget _page(int index) {
    switch (index) {
      case 0:
        return ReservationsPage();
      case 1:
        return MapPage();
      default:
        return Container();
    }
  }
}

enum _BottomBarType { reservations, map }

extension _BottomBarInfos on _BottomBarType {
  String label(BuildContext context) {
    switch (this) {
      case _BottomBarType.reservations:
        return AppLocalizations.of(context).reservationsBottomBarTitle;
      case _BottomBarType.map:
        return AppLocalizations.of(context).mapBottomBarTitle;
      default:
        return '';
    }
  }

  String get iconName {
    switch (this) {
      case _BottomBarType.reservations:
        return 'assets/005-calendar.png';
      case _BottomBarType.map:
        return 'assets/001-loupe.png';
      default:
        return '';
    }
  }
}
