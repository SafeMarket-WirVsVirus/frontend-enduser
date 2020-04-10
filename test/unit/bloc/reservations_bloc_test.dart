import 'package:reservation_system_customer/repository/notification_handler.dart';

import '../unit_test_helper.dart';

class MockReservationsRepository extends Mock
    implements ReservationsRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockNotificationHandler extends Mock implements NotificationHandler {}

void main() {
  final String testDeviceId = 'testDeviceId';

  ReservationsBloc bloc;
  MockReservationsRepository mockReservationsRepository;
  MockUserRepository mockUserRepository;
  MockNotificationHandler mockNotificationHandler;

  setUp(() {
    mockReservationsRepository = MockReservationsRepository();
    mockUserRepository = MockUserRepository();
    mockNotificationHandler = MockNotificationHandler();

    bloc = ReservationsBloc(
      reservationsRepository: mockReservationsRepository,
      userRepository: mockUserRepository,
      notificationHandler: mockNotificationHandler,
      context: null,
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

      blocTest(
        'emits updated items with notification ids',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value([
                    ReservationFactory.createReservation(
                        id: 30, reminderNotificationId: 500),
                    ReservationFactory.createReservation(id: 35),
                    ReservationFactory.createReservation(
                        id: 40, reminderNotificationId: 600),
                  ]));
          when(mockReservationsRepository.getReservations(
                  deviceId: testDeviceId))
              .thenAnswer((_) => Future.value([
                    ReservationFactory.createReservation(id: 30),
                    ReservationFactory.createReservation(id: 35),
                    ReservationFactory.createReservation(id: 40),
                  ]));
          return bloc;
        },
        act: (b) => b.add(LoadReservations()),
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([
            ReservationFactory.createReservation(
                id: 30, reminderNotificationId: 500),
            ReservationFactory.createReservation(id: 35),
            ReservationFactory.createReservation(
                id: 40, reminderNotificationId: 600),
          ]),
        ],
      );

      blocTest(
        'emits updated items with notification ids and removed old items',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value([
                    ReservationFactory.createReservation(
                        id: 30, reminderNotificationId: 500),
                    ReservationFactory.createReservation(id: 35),
                    ReservationFactory.createReservation(
                        id: 40, reminderNotificationId: 600),
                  ]));
          when(mockReservationsRepository.getReservations(
                  deviceId: testDeviceId))
              .thenAnswer((_) => Future.value([
                    ReservationFactory.createReservation(id: 35),
                    ReservationFactory.createReservation(id: 40),
                    ReservationFactory.createReservation(id: 45),
                  ]));
          return bloc;
        },
        act: (b) => b.add(LoadReservations()),
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([
            ReservationFactory.createReservation(
                id: 30, reminderNotificationId: 500),
            ReservationFactory.createReservation(id: 35),
            ReservationFactory.createReservation(
                id: 40, reminderNotificationId: 600),
          ]),
          ReservationsLoaded([
            ReservationFactory.createReservation(id: 35),
            ReservationFactory.createReservation(
                id: 40, reminderNotificationId: 600),
            ReservationFactory.createReservation(id: 45),
          ]),
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
        verify(mockReservationsRepository.getReservations(
                deviceId: testDeviceId))
            .called(1);
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
        verify(mockReservationsRepository.getReservations(
                deviceId: testDeviceId))
            .called(1);
        verify(mockReservationsRepository.saveReservations(
            [ReservationFactory.createReservation(id: 1)])).called(1);
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
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value([
                    ReservationFactory.createReservation(id: 1),
                    ReservationFactory.createReservation(
                        id: 40, reminderNotificationId: 240),
                  ]));
          var isFirstEvent = true;
          when(mockReservationsRepository.getReservations(deviceId: testDeviceId)).thenAnswer((_) {
            final result = isFirstEvent
                ? [
                    ReservationFactory.createReservation(id: 1),
                    ReservationFactory.createReservation(id: 40),
                  ]
                : [
                    ReservationFactory.createReservation(id: 30),
                    ReservationFactory.createReservation(
                        id: 40, reminderNotificationId: 240),
                  ];
            isFirstEvent = false;
            return Future.value(result);
          });
          return bloc;
        },
        act: (b) {
          bloc.add(LoadReservations());
          b.add(UpdateReservations());
          return;
        },
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([
            ReservationFactory.createReservation(id: 1),
            ReservationFactory.createReservation(
                id: 40, reminderNotificationId: 240),
          ]),
          ReservationsLoading(),
          ReservationsLoaded([
            ReservationFactory.createReservation(id: 30),
            ReservationFactory.createReservation(
                id: 40, reminderNotificationId: 240),
          ]),
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

        verify(mockReservationsRepository.getReservations(
                deviceId: testDeviceId))
            .called(1);
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

        verify(mockReservationsRepository.getReservations(
                deviceId: testDeviceId))
            .called(1);
        verify(mockReservationsRepository.saveReservations(
            [ReservationFactory.createReservation(id: 1)])).called(1);
        verifyNoMoreInteractions(mockReservationsRepository);
      });
    });

    group('ToggleReminderForReservation event', () {
      setUp(() {
        when(mockReservationsRepository.getReservations(deviceId: testDeviceId))
            .thenThrow(Exception('no internet'));
      });

      blocTest(
        'does not emit an event when reservation not found',
        build: () async {
          when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
              Future.value([ReservationFactory.createReservation(id: 20)]));
          return bloc;
        },
        act: (b) {
          b.add(LoadReservations());
          b.add(ToggleReminderForReservation(reservationId: 10));
          return;
        },
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([ReservationFactory.createReservation(id: 20)]),
        ],
      );

      blocTest(
        'emit an event and sets reminderNotificationId when reservation found without notification',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value([
                    ReservationFactory.createReservation(id: 10),
                    ReservationFactory.createReservation(id: 20),
                  ]));
          when(mockNotificationHandler.scheduleReservationReminder(
            context: anyNamed('context'),
            reservation: anyNamed('reservation'),
          )).thenAnswer((_) => Future.value(123));
          return bloc;
        },
        act: (b) {
          b.add(LoadReservations());
          b.add(ToggleReminderForReservation(reservationId: 10));
          return;
        },
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([
            ReservationFactory.createReservation(id: 10),
            ReservationFactory.createReservation(id: 20),
          ]),
          ReservationsLoaded([
            ReservationFactory.createReservation(
                id: 10, reminderNotificationId: 123),
            ReservationFactory.createReservation(id: 20),
          ]),
        ],
      );

      blocTest(
        'emit an event and removes reminderNotificationId when reservation found with notification',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value([
                    ReservationFactory.createReservation(id: 10),
                    ReservationFactory.createReservation(
                        id: 20, reminderNotificationId: 100),
                  ]));
          return bloc;
        },
        act: (b) {
          b.add(LoadReservations());
          b.add(ToggleReminderForReservation(reservationId: 20));
          return;
        },
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([
            ReservationFactory.createReservation(id: 10),
            ReservationFactory.createReservation(
                id: 20, reminderNotificationId: 100),
          ]),
          ReservationsLoaded([
            ReservationFactory.createReservation(id: 10),
            ReservationFactory.createReservation(id: 20),
          ]),
        ],
      );

      test(
          'calls scheduleReservationReminder when reservation should be scheduled',
          () async {
        when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
            Future.value([ReservationFactory.createReservation(id: 20)]));
        when(mockNotificationHandler.scheduleReservationReminder(
          context: anyNamed('context'),
          reservation: anyNamed('reservation'),
        )).thenAnswer((_) => Future.value(123));

        bloc.add(LoadReservations());
        bloc.add(ToggleReminderForReservation(reservationId: 20));

        await bloc.close();

        verify(mockNotificationHandler.scheduleReservationReminder(
                context: anyNamed('context'),
                reservation: ReservationFactory.createReservation(id: 20)))
            .called(1);
        verifyNoMoreInteractions(mockNotificationHandler);
      });

      test(
          'calls cancelReservationReminder when reservation should be canceled',
          () async {
        when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
            Future.value([
              ReservationFactory.createReservation(
                  id: 20, reminderNotificationId: 123)
            ]));

        bloc.add(LoadReservations());
        bloc.add(ToggleReminderForReservation(reservationId: 20));

        await bloc.close();

        verify(mockNotificationHandler.cancelNotification(123)).called(1);
        verifyNoMoreInteractions(mockNotificationHandler);
      });
    });
  });
}
