import 'dart:async';

import '../unit_test_helper.dart';

class MockReservationsRepository extends Mock
    implements ReservationsRepository {}

void main() {
  final testLocation = LocationFactory.createLocation(
      id: 10, locationType: LocationType.pharmacy);
  final testTime = DateTime.utc(2020, 04, 13);
  final testReservation = ReservationFactory.createReservation(
    id: 50,
    location: ReservationLocation.fromLocation(testLocation),
  );

  ModifyReservationBloc bloc;
  MockReservationsRepository mockReservationsRepository;

  setUp(() {
    mockReservationsRepository = MockReservationsRepository();

    bloc = ModifyReservationBloc(
      reservationsRepository: mockReservationsRepository,
    );
  });

  tearDown(() {
    bloc?.close();
  });

  group('ModifyReservationBloc', () {
    test('initial state is [ModifyReservationIdle]', () {
      expect(bloc.state, ModifyReservationIdle());
    });

    group('CreateReservation', () {
      blocTest(
        'emits success when reservation created successful',
        build: () async {
          when(mockReservationsRepository.createReservation(
            locationId: testLocation.id,
            startTime: testTime,
          )).thenAnswer((_) => Future.value(true));
          return bloc;
        },
        act: (b) => b.add(CreateReservation(
          location: testLocation,
          startTime: testTime,
        )),
        expect: [
          CreateReservationSuccess(
            location: ReservationLocation.fromLocation(testLocation),
            startTime: testTime,
          ),
          ModifyReservationIdle(),
        ],
      );

      blocTest(
        'emits failure when reservation created unsuccessful',
        build: () async {
          when(mockReservationsRepository.createReservation(
            locationId: testLocation.id,
            startTime: testTime,
          )).thenAnswer((_) => Future.value(false));
          return bloc;
        },
        act: (b) => b.add(CreateReservation(
          location: testLocation,
          startTime: testTime,
        )),
        expect: [
          CreateReservationFailure(),
          ModifyReservationIdle(),
        ],
      );

      test('calls reservationRepository.createReservation', () async {
        when(mockReservationsRepository.createReservation(
          locationId: anyNamed('locationId'),
          startTime: anyNamed('startTime'),
        )).thenAnswer((_) => Future.value(true));

        bloc.add(CreateReservation(
          location: testLocation,
          startTime: testTime,
        ));

        await bloc.close();

        verify(mockReservationsRepository.createReservation(
          locationId: testLocation.id,
          startTime: testTime,
        )).called(1);
        verifyNoMoreInteractions(mockReservationsRepository);
      });
    });

    group('CancelReservation', () {
      blocTest(
        'emits success when reservation created successful',
        build: () async {
          when(mockReservationsRepository.cancelReservation(
            locationId: testLocation.id,
            reservationId: testReservation.id,
          )).thenAnswer((_) => Future.value(true));
          return bloc;
        },
        act: (b) => b.add(CancelReservation(testReservation)),
        expect: [
          CancelReservationSuccess(),
          ModifyReservationIdle(),
        ],
      );

      blocTest(
        'emits failure when reservation created unsuccessful',
        build: () async {
          when(mockReservationsRepository.cancelReservation(
            locationId: testLocation.id,
            reservationId: testReservation.id,
          )).thenAnswer((_) => Future.value(false));
          return bloc;
        },
        act: (b) => b.add(CancelReservation(testReservation)),
        expect: [
          CancelReservationFailure(),
          ModifyReservationIdle(),
        ],
      );

      test('calls reservationRepository.cancelReservation', () async {
        when(mockReservationsRepository.cancelReservation(
          locationId: anyNamed('locationId'),
          reservationId: anyNamed('reservationId'),
        )).thenAnswer((_) => Future.value(true));

        bloc.add(CancelReservation(testReservation));

        await bloc.close();

        verify(mockReservationsRepository.cancelReservation(
          locationId: testLocation.id,
          reservationId: testReservation.id,
        )).called(1);
        verifyNoMoreInteractions(mockReservationsRepository);
      });
    });
  });
}
