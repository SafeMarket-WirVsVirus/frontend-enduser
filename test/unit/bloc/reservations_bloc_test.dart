import '../unit_test_helper.dart';

class MockReservationsRepository extends Mock
    implements ReservationsRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  final String testDeviceId = 'testDeviceId';

  ReservationsBloc bloc;
  MockReservationsRepository mockReservationsRepository;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockReservationsRepository = MockReservationsRepository();
    mockUserRepository = MockUserRepository();
    bloc = ReservationsBloc(
      reservationsRepository: mockReservationsRepository,
      userRepository: mockUserRepository,
    );
    when(mockUserRepository.deviceId())
        .thenAnswer((_) => Future.value(testDeviceId));
  });

  tearDown(() {
    bloc?.close();
  });

  group('ReservationsBloc', () {
    test('initial state is [ReservationsInitial]', () {
      expect(bloc.state, ReservationsInitial());
    });

    group('LoadReservations event', () {
      blocTest(
        'emits failed when no persisted items and no internet',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value(null));
          when(mockReservationsRepository.getReservations(
                  deviceId: testDeviceId))
              .thenAnswer((_) => Future.error(Exception('no internet')));
          return bloc;
        },
        act: (b) => b.add(LoadReservations()),
        expect: [
          ReservationsLoading(),
          ReservationsLoadFail(),
        ],
      );

      blocTest(
        'emits loaded when persisted items and no internet',
        build: () async {
          when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
              Future.value([ReservationFactory.createReservation(id: 30)]));
          when(mockReservationsRepository.getReservations(
                  deviceId: testDeviceId))
              .thenAnswer((_) => Future.error(Exception('no internet')));
          return bloc;
        },
        act: (b) => b.add(LoadReservations()),
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([ReservationFactory.createReservation(id: 30)]),
        ],
      );

      blocTest(
        'emits loaded twice when persisted items and internet',
        build: () async {
          when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
              Future.value([ReservationFactory.createReservation(id: 30)]));
          when(mockReservationsRepository.getReservations(
                  deviceId: testDeviceId))
              .thenAnswer((_) =>
                  Future.value([ReservationFactory.createReservation(id: 1)]));
          return bloc;
        },
        act: (b) => b.add(LoadReservations()),
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([ReservationFactory.createReservation(id: 30)]),
          ReservationsLoaded([ReservationFactory.createReservation(id: 1)]),
        ],
      );

      blocTest(
        'emits loaded when no persisted items and internet',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value(null));
          when(mockReservationsRepository.getReservations(
                  deviceId: testDeviceId))
              .thenAnswer((_) =>
                  Future.value([ReservationFactory.createReservation(id: 1)]));
          return bloc;
        },
        act: (b) => b.add(LoadReservations()),
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([ReservationFactory.createReservation(id: 1)]),
        ],
      );

      test('does not persist when no internet', () async {
        when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
            Future.value([ReservationFactory.createReservation(id: 30)]));
        when(mockReservationsRepository.getReservations(deviceId: testDeviceId))
            .thenAnswer((_) => Future.error(Exception('no internet')));

        bloc.add(LoadReservations());

        await bloc.close();

        verify(mockReservationsRepository.loadReservations()).called(1);
        verify(mockReservationsRepository.getReservations(deviceId: testDeviceId)).called(1);
        verifyNoMoreInteractions(mockReservationsRepository);
      });

      test('persists received notifications when internet', () async {
        when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
            Future.value([ReservationFactory.createReservation(id: 30)]));
        when(mockReservationsRepository.getReservations(deviceId: testDeviceId))
            .thenAnswer((_) =>
                Future.value([ReservationFactory.createReservation(id: 1)]));

        bloc.add(LoadReservations());

        await bloc.close();

        verify(mockReservationsRepository.loadReservations()).called(1);
        verify(mockReservationsRepository.getReservations(deviceId: testDeviceId)).called(1);
        verify(mockReservationsRepository
            .saveReservations([ReservationFactory.createReservation(id: 1)])).called(1);
        verifyNoMoreInteractions(mockReservationsRepository);
      });
    });

    group('UpdateReservations event', () {
      blocTest(
        'emits failed when no persisted items and no internet',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value(null));
          when(mockReservationsRepository.getReservations(
                  deviceId: testDeviceId))
              .thenAnswer((_) => Future.error(Exception('no internet')));
          return bloc;
        },
        act: (b) => b.add(UpdateReservations()),
        expect: [
          ReservationsLoading(),
          ReservationsLoadFail(),
        ],
      );

      blocTest(
        'emits failed when persisted items and no internet',
        build: () async {
          when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
              Future.value([ReservationFactory.createReservation(id: 30)]));
          when(mockReservationsRepository.getReservations(
                  deviceId: testDeviceId))
              .thenAnswer((_) => Future.error(Exception('no internet')));
          return bloc;
        },
        act: (b) => b.add(UpdateReservations()),
        expect: [
          ReservationsLoading(),
          ReservationsLoadFail(),
        ],
      );

      blocTest(
        'emits loaded with new items when internet',
        build: () async {
          when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
              Future.value([ReservationFactory.createReservation(id: 30)]));
          when(mockReservationsRepository.getReservations(
                  deviceId: testDeviceId))
              .thenAnswer((_) =>
                  Future.value([ReservationFactory.createReservation(id: 1)]));
          return bloc;
        },
        act: (b) => b.add(UpdateReservations()),
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([ReservationFactory.createReservation(id: 1)]),
        ],
      );

      blocTest(
        'emits loaded when no persisted items and internet',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value(null));
          when(mockReservationsRepository.getReservations(
                  deviceId: testDeviceId))
              .thenAnswer((_) =>
                  Future.value([ReservationFactory.createReservation(id: 1)]));
          return bloc;
        },
        act: (b) => b.add(UpdateReservations()),
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([ReservationFactory.createReservation(id: 1)]),
        ],
      );

      test('does not persist when no internet', () async {
        when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
            Future.value([ReservationFactory.createReservation(id: 30)]));
        when(mockReservationsRepository.getReservations(deviceId: testDeviceId))
            .thenAnswer((_) => Future.error(Exception('no internet')));

        bloc.add(UpdateReservations());

        await bloc.close();

        verify(mockReservationsRepository.getReservations(deviceId: testDeviceId)).called(1);
        verifyNoMoreInteractions(mockReservationsRepository);
      });

      test('persists received notifications when internet', () async {
        when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
            Future.value([ReservationFactory.createReservation(id: 30)]));
        when(mockReservationsRepository.getReservations(deviceId: testDeviceId))
            .thenAnswer((_) =>
            Future.value([ReservationFactory.createReservation(id: 1)]));

        bloc.add(UpdateReservations());

        await bloc.close();

        verify(mockReservationsRepository.getReservations(deviceId: testDeviceId)).called(1);
        verify(mockReservationsRepository
            .saveReservations([ReservationFactory.createReservation(id: 1)])).called(1);
        verifyNoMoreInteractions(mockReservationsRepository);
      });
    });
  });
}
