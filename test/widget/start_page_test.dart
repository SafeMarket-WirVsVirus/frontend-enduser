import 'dart:async';

import 'package:reservation_system_customer/repository/repository.dart';
import 'package:reservation_system_customer/ui/map/map_page.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_page.dart';
import 'package:reservation_system_customer/ui/start_page.dart';
import 'package:reservation_system_customer/ui/tutorials/tutorial_sliders.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widget_test_helper.dart';

class MockReservationsBloc extends Mock implements ReservationsBloc {}

class MockMapBloc extends Mock implements MapBloc {}

class MockModifyReservationBloc extends Mock implements ModifyReservationBloc {}

class MockUserRepository extends Mock implements UserRepository {}

class MockLocationsRepository extends Mock implements LocationsRepository {}

class MockAppLocalizations extends Fake implements AppLocalizations {
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
  MockModifyReservationBloc mockModifyReservationBloc;
  MapBloc mapBloc;
  UserRepository userRepository;
  Widget startPage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    reservationsBloc = MockReservationsBloc();
    mockModifyReservationBloc = MockModifyReservationBloc();
    mapBloc = MockMapBloc();
    userRepository = MockUserRepository();

    when(userRepository.loadUserPosition())
        .thenAnswer((_) => Future.value(null));

    when(userRepository.shouldShowTutorial())
        .thenAnswer((_) => Future.value(false));

    mockBlocState(
      mapBloc,
      MapInitial(
        filterSettings: FilterSettings(
          locationType: LocationType.supermarket,
          minFillStatus: FillStatus.red,
        ),
      ),
    );

    mockBlocState(mockModifyReservationBloc, ModifyReservationIdle());

    startPage = TestApp(
      blocs: [reservationsBloc, mapBloc, mockModifyReservationBloc],
      child: Provider.value(
        value: userRepository,
        child: StartPage(),
      ),
    );
  });

  tearDown(() {
    reservationsBloc.close();
    mockModifyReservationBloc.close();
    mapBloc.close();
  });

  _mockBlocState(ReservationsState state) {
    mockBlocState(reservationsBloc, state);
  }

  group('StartPage', () {
    testWidgets('displays progress indicator when ReservationsLoading',
        (WidgetTester tester) async {
      _mockBlocState(ReservationsLoading());

      await tester.pumpWidget(startPage);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays MapPage when ReservationsLoadFail',
        (WidgetTester tester) async {
      _mockBlocState(ReservationsLoadFail());

      await tester.pumpWidget(startPage);

      expect(find.byType(MapPage), findsOneWidget);
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
          ReservationFactory.createReservation(id: 123),
        ]),
      );

      await tester.pumpWidget(startPage);

      expect(find.byType(ReservationsPage), findsOneWidget);
    });

    testWidgets(
        'displays [TutorialSliders] when UserRepository.shouldShowTutorial is true',
        (WidgetTester tester) async {
      when(userRepository.shouldShowTutorial())
          .thenAnswer((_) => Future.value(true));
      _mockBlocState(
        ReservationsLoaded([
          ReservationFactory.createReservation(id: 123),
        ]),
      );

      await tester.pumpWidget(startPage);
      await tester.pumpAndSettle();

      expect(find.byType(TutorialSliders), findsOneWidget);
    });
  });
}
