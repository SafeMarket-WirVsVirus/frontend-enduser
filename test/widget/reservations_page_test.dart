import 'package:reservation_system_customer/ui/reservations/reservations_list.dart';
import 'package:reservation_system_customer/ui/reservations/reservations_page.dart';

import 'widget_test_helper.dart';

class MockReservationsBloc extends Mock implements ReservationsBloc {}

void main() {
  ReservationsBloc reservationsBloc;
  Widget reservationsPage;

  setUp(() {
    reservationsBloc = MockReservationsBloc();

    reservationsPage = TestApp(
      blocs: [reservationsBloc],
      child: ReservationsPage(),
    );
  });

  tearDown(() {
    reservationsBloc.close();
  });

  group('ReservationsPage', () {
    testWidgets('displays progress indicator when ReservationsInitial',
        (WidgetTester tester) async {
      mockBlocState(reservationsBloc, ReservationsInitial());

      await tester.pumpWidget(reservationsPage);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays progress indicator when ReservationsLoading',
        (WidgetTester tester) async {
      mockBlocState(reservationsBloc, ReservationsLoading());

      await tester.pumpWidget(reservationsPage);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays no reservations when ReservationsLoaded with null',
        (WidgetTester tester) async {
      mockBlocState(reservationsBloc, ReservationsLoaded(null));

      await tester.pumpWidget(reservationsPage);

      expect(find.text('You do not have any open reservations at the moment.'),
          findsOneWidget);
    });

    testWidgets(
        'displays no reservations when ReservationsLoaded with empty list',
        (WidgetTester tester) async {
      mockBlocState(reservationsBloc, ReservationsLoaded([]));

      await tester.pumpWidget(reservationsPage);

      expect(find.text('You do not have any open reservations at the moment.'),
          findsOneWidget);
    });

    testWidgets(
        'displays reservations when ReservationsLoaded with non-empty list',
        (WidgetTester tester) async {
      mockBlocState(
          reservationsBloc,
          ReservationsLoaded([
            Reservation(
              id: 1,
              location: Location(),
              startTime: DateTime.now().add(
                Duration(hours: 2),
              ),
            )
          ]));

      await tester.pumpWidget(reservationsPage);

      expect(find.byType(ReservationsList), findsOneWidget);
    });
  });
}
