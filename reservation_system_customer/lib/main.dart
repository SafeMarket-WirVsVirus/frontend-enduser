import 'package:flutter/material.dart';
import 'package:reservation_system_customer/ui/start_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reservierungssystem',
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.orange,
      ),
      home: StartPage(),
    );
  }
}
