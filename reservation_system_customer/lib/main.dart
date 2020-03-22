import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/ui/start_page.dart';

import 'bloc/bloc.dart';
import 'repository/repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final baseUrl = 'wirvsvirusretail.azurewebsites.net';

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository();
    return MaterialApp(
      title: 'Reservierungssystem',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.deepOrange
      ),
      theme: ThemeData(
        accentColor: Colors.orange,
        brightness: Brightness.light
      ),
      home: MultiProvider(
        providers: [
          BlocProvider(
            create: (context) => ReservationsBloc(
              reservationsRepository: ReservationsRepository(baseUrl: baseUrl),
              userRepository: userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => MapBloc(
              locationsRepository: LocationsRepository(baseUrl: baseUrl),
            ),
          ),
          Provider(
            create: (context) => userRepository,
          )
        ],
        child: StartPage(),
      ),
    );
  }
}
