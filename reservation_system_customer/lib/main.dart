import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/ui/start_page.dart';

import 'app_localizations.dart';
import 'bloc/bloc.dart';
import 'repository/repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final baseUrl = 'wirvsvirusretail.azurewebsites.net';

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository();
    return MaterialApp(
      title: "SafeMarket",
      theme: ThemeData(
          primaryColor: Color(0xff2196F3),
          accentColor: Color(0xff00F2A9),
          brightness: Brightness.light),
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
//
      supportedLocales: [
        Locale('en', ''),
        Locale('de', '')
      ],

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      localeListResolutionCallback: (locales, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locales.first.languageCode &&
              locales.first.countryCode.contains(supportedLocale.countryCode)) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
