import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:reservation_system_customer/app_localizations.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';

import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui/map/map_page.dart';
import 'package:reservation_system_customer/ui/offline_page.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_list_page.dart';
import 'package:reservation_system_customer/ui/start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockReservationsBloc extends Mock implements ReservationsBloc {}

class MockMapBloc extends Mock implements MapBloc {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAppLocalizations extends Fake implements AppLocalizations {
  @override
  String translate(String key) {
    return key;
  }

  @override
  Locale get locale => Locale('en');
}

class MockLocalizationsDelegate extends Fake
    implements LocalizationsDelegate<AppLocalizations> {
  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(MockAppLocalizations());
  }

  bool isSupported(Locale locale) => true;

  Type get type => AppLocalizations;
}

void main() {
  ReservationsBloc reservationsBloc;
  MapBloc mapBloc;
  UserRepository userRepository;
  Widget startPage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    reservationsBloc = MockReservationsBloc();
    mapBloc = MapBloc();
    userRepository = MockUserRepository();

    when(userRepository.loadUserPosition())
        .thenAnswer((_) => Future.value(null));

    startPage = MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: reservationsBloc),
          BlocProvider.value(value: mapBloc),
        ],
        child: Provider.value(
          value: userRepository,
          child: StartPage(),
        ),
      ),
      localizationsDelegates: [
        MockLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  });

  tearDown(() {
    reservationsBloc.close();
    mapBloc.close();
  });

  _mockBlocState(ReservationsState state) {
    when(reservationsBloc.state).thenReturn(state);
    whenListen(reservationsBloc, Stream.fromIterable([state]));
  }

  group('StartPage', () {
    testWidgets('displays progress indicator when ReservationsLoading',
        (WidgetTester tester) async {
      _mockBlocState(ReservationsLoading());

      await tester.pumpWidget(startPage);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays warning when ReservationsLoadFail',
        (WidgetTester tester) async {
      _mockBlocState(ReservationsLoadFail());

      await tester.pumpWidget(startPage);

      expect(find.byType(OfflinePage), findsOneWidget);
      expect(find.text('offline'), findsOneWidget);
    });

    testWidgets(
        'displays [MapPage] when ReservationsLoaded but reservations null',
        (WidgetTester tester) async {
      _mockBlocState(ReservationsLoaded(null));

      await tester.pumpWidget(startPage);

      expect(find.byType(MapPage), findsOneWidget);
    });

    testWidgets(
        'displays [MapPage] when ReservationsLoaded but reservations empty',
        (WidgetTester tester) async {
      _mockBlocState(ReservationsLoaded([]));

      await tester.pumpWidget(startPage);

      expect(find.byType(MapPage), findsOneWidget);
    });

    testWidgets(
        'displays [ReservationsListPage] when ReservationsLoaded and reservations not empty',
        (WidgetTester tester) async {
      _mockBlocState(
        ReservationsLoaded([
          Reservation(
            id: 123,
            location: Location(),
            startTime: DateTime.now(),
          ),
        ]),
      );

      await tester.pumpWidget(startPage);

      expect(find.byType(ReservationsListPage), findsOneWidget);
    });
  });
}
