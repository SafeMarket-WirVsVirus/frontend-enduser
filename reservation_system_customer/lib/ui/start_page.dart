import 'package:flutter/material.dart';
import 'package:reservation_system_customer/ui/home_page.dart';
import 'package:reservation_system_customer/ui/map_page.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
          ),
        ],
      ),
      body: _page(_selectedIndex),
    );
  }

  Widget _page(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return MapPage();
      default:
        return Container();
    }
  }
}
