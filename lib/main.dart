import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/bloc/map_marker_loader.dart';
import 'package:reservation_system_customer/repository/notification_handler.dart';
import 'package:reservation_system_customer/repository/storage.dart';
import 'package:reservation_system_customer/ui/start_page.dart';
import 'package:reservation_system_customer/ui_imports.dart';
import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storage = Storage();
    final userRepository = UserRepository(storage: storage);
    final reservationRepository = ReservationsRepository(
      baseUrl: Constants.baseUrl,
      userRepository: userRepository,
      storage: storage,
    );
    final locationsRepository = LocationsRepository(
      baseUrl: Constants.baseUrl,
      storage: storage,
    );
    // ignore: close_sinks
    final modifyReservationsBloc = ModifyReservationBloc(
      reservationsRepository: reservationRepository,
    );
    return MaterialApp(
      title: "SafeMarket",
      theme: ThemeData.light().copyWith(
          primaryColor: Color(0xff2196F3),
          accentColor: Color(0xff00F2A9),
          appBarTheme: ThemeData.light().appBarTheme.copyWith(
              color: Colors.white,
              textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                      color: Color(0xff322153),
                      fontSize: 17,
                    ),
                  ),
              iconTheme: ThemeData.light().iconTheme.copyWith(
                    color: Color(0xff322153),
                  )),
          brightness: Brightness.light),
      home: MultiProvider(
        providers: [
          BlocProvider(
            create: (context) => ReservationsBloc(
              modifyReservationBloc: modifyReservationsBloc,
              reservationsRepository: reservationRepository,
              notificationHandler: NotificationHandler(),
              context: context,
            ),
          ),
          BlocProvider(
            create: (context) => MapBloc(
              locationsRepository: locationsRepository,
              markerLoader: MapMarkerLoader(),
            ),
          ),
          BlocProvider(
            create: (context) => modifyReservationsBloc,
          ),
          Provider(
            create: (context) => userRepository,
          ),
          Provider(
            create: (context) => reservationRepository,
          ),
          Provider(
            create: (context) => locationsRepository,
          ),
        ],
        child: StartPage(),
      ),
      supportedLocales: [
        Locale('en', ''),
        Locale('de', ''),
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
