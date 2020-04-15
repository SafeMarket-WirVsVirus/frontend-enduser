import 'dart:async';

import 'package:reservation_system_customer/repository/notification_handler.dart';

import '../unit_test_helper.dart';

class MockReservationsRepository extends Mock
    implements ReservationsRepository {}

class MockNotificationHandler extends Mock implements NotificationHandler {}

class MockModifyReservationBloc extends Mock implements ModifyReservationBloc {}

void main() {
  final DateTime testTime = DateTime.now().add(Duration(days: 1));

  ReservationsBloc bloc;
  MockModifyReservationBloc mockModifyReservationBloc;
  StreamController<ModifyReservationState> modifyReservationBlocController;
  MockReservationsRepository mockReservationsRepository;
  MockNotificationHandler mockNotificationHandler;

  setUp(() {
    mockModifyReservationBloc = MockModifyReservationBloc();
    modifyReservationBlocController =
        StreamController<ModifyReservationState>.broadcast();
    mockReservationsRepository = MockReservationsRepository();
    mockNotificationHandler = MockNotificationHandler();

    whenListen(
        mockModifyReservationBloc, modifyReservationBlocController.stream);

    bloc = ReservationsBloc(
      modifyReservationBloc: mockModifyReservationBloc,
      reservationsRepository: mockReservationsRepository,
      notificationHandler: mockNotificationHandler,
    );
  });

  tearDown(() {
    modifyReservationBlocController?.close();
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
          when(mockReservationsRepository.getReservations())
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
          when(mockReservationsRepository.getReservations())
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
          when(mockReservationsRepository.getReservations()).thenAnswer((_) =>
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
          when(mockReservationsRepository.getReservations()).thenAnswer((_) =>
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
        'emits updated items with notification ids and locations',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value([
                    ReservationFactory.createReservation(
                      id: 30,
                      reminderNotificationId: 500,
                      location:
                          ReservationLocationFactory.createLocation(id: 501),
                    ),
                    ReservationFactory.createReservation(id: 35),
                    ReservationFactory.createReservation(
                        id: 40, reminderNotificationId: 600),
                  ]));
          when(mockReservationsRepository.getReservations())
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
              id: 30,
              reminderNotificationId: 500,
              location: ReservationLocationFactory.createLocation(id: 501),
            ),
            ReservationFactory.createReservation(id: 35),
            ReservationFactory.createReservation(
                id: 40, reminderNotificationId: 600),
          ]),
        ],
      );

      blocTest(
        'emits updated items with notification ids and locations, and removed old items',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value([
                    ReservationFactory.createReservation(
                        id: 30, reminderNotificationId: 500),
                    ReservationFactory.createReservation(id: 35),
                    ReservationFactory.createReservation(
                      id: 40,
                      reminderNotificationId: 600,
                      location:
                          ReservationLocationFactory.createLocation(id: 601),
                    ),
                  ]));
          when(mockReservationsRepository.getReservations())
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
              id: 40,
              reminderNotificationId: 600,
              location: ReservationLocationFactory.createLocation(id: 601),
            ),
          ]),
          ReservationsLoaded([
            ReservationFactory.createReservation(id: 35),
            ReservationFactory.createReservation(
              id: 40,
              reminderNotificationId: 600,
              location: ReservationLocationFactory.createLocation(id: 601),
            ),
            ReservationFactory.createReservation(id: 45),
          ]),
        ],
      );

      test('does not persist when no internet', () async {
        when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
            Future.value([ReservationFactory.createReservation(id: 30)]));
        when(mockReservationsRepository.getReservations())
            .thenAnswer((_) => Future.error(Exception('no internet')));

        bloc.add(LoadReservations());

        await bloc.close();

        verify(mockReservationsRepository.loadReservations()).called(1);
        verify(mockReservationsRepository.getReservations()).called(1);
        verifyNoMoreInteractions(mockReservationsRepository);
      });

      test('persists received notifications when internet', () async {
        when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
            Future.value([ReservationFactory.createReservation(id: 30)]));
        when(mockReservationsRepository.getReservations()).thenAnswer(
            (_) => Future.value([ReservationFactory.createReservation(id: 1)]));

        bloc.add(LoadReservations());

        await bloc.close();

        verify(mockReservationsRepository.loadReservations()).called(1);
        verify(mockReservationsRepository.getReservations()).called(1);
        verify(mockReservationsRepository.saveReservations(
            [ReservationFactory.createReservation(id: 1)])).called(1);
        verifyNoMoreInteractions(mockReservationsRepository);
      });
    });

    group('CreateReservationSuccess event', () {
      blocTest(
        'emits failed when no persisted items and no internet',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value(null));
          when(mockReservationsRepository.getReservations())
              .thenAnswer((_) => Future.error(Exception('no internet')));
          return bloc;
        },
        act: (b) {
          modifyReservationBlocController.add(CreateReservationSuccess(
            location: ReservationLocationFactory.createLocation(id: 10),
            startTime: DateTime.now(),
          ));
          return;
        },
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
          when(mockReservationsRepository.getReservations())
              .thenAnswer((_) => Future.error(Exception('no internet')));
          return bloc;
        },
        act: (b) {
          modifyReservationBlocController.add(CreateReservationSuccess(
            location: ReservationLocationFactory.createLocation(id: 10),
            startTime: DateTime.now(),
          ));
          return;
        },
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
          when(mockReservationsRepository.getReservations()).thenAnswer((_) {
            final result = isFirstEvent
                ? [
                    ReservationFactory.createReservation(id: 1),
                    ReservationFactory.createReservation(id: 40),
                  ]
                : [
                    ReservationFactory.createReservation(id: 40),
                    ReservationFactory.createReservation(
                        id: 50, startTime: testTime),
                  ];
            isFirstEvent = false;
            return Future.value(result);
          });
          return bloc;
        },
        act: (b) {
          bloc.add(LoadReservations());
          modifyReservationBlocController.add(CreateReservationSuccess(
            location: ReservationLocationFactory.createLocation(id: 50),
            startTime: testTime,
          ));
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
            ReservationFactory.createReservation(
                id: 40, reminderNotificationId: 240),
            ReservationFactory.createReservation(
                id: 50,
                startTime: testTime,
                location: ReservationLocationFactory.createLocation(id: 50)),
          ]),
        ],
      );

      blocTest(
        'emits loaded when no persisted items and internet',
        build: () async {
          when(mockReservationsRepository.loadReservations())
              .thenAnswer((_) => Future.value(null));
          when(mockReservationsRepository.getReservations()).thenAnswer((_) =>
              Future.value([
                ReservationFactory.createReservation(id: 1, startTime: testTime)
              ]));
          return bloc;
        },
        act: (b) {
          modifyReservationBlocController.add(CreateReservationSuccess(
            location: ReservationLocationFactory.createLocation(id: 10),
            startTime: testTime,
          ));
          return;
        },
        expect: [
          ReservationsLoading(),
          ReservationsLoaded([
            ReservationFactory.createReservation(
              id: 1,
              startTime: testTime,
              location: ReservationLocationFactory.createLocation(id: 10),
            )
          ]),
        ],
      );

      test('does not persist when no internet', () async {
        when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
            Future.value([ReservationFactory.createReservation(id: 30)]));
        when(mockReservationsRepository.getReservations())
            .thenAnswer((_) => Future.error(Exception('no internet')));

        modifyReservationBlocController.add(CreateReservationSuccess(
          location: ReservationLocationFactory.createLocation(id: 10),
          startTime: DateTime.now(),
        ));

        await bloc.take(3).toList();

        verify(mockReservationsRepository.getReservations()).called(1);
        verifyNoMoreInteractions(mockReservationsRepository);
      });

      test('persists received notifications when internet', () async {
        when(mockReservationsRepository.loadReservations()).thenAnswer((_) =>
            Future.value([ReservationFactory.createReservation(id: 30)]));
        when(mockReservationsRepository.getReservations()).thenAnswer((_) =>
            Future.value([
              ReservationFactory.createReservation(id: 1, startTime: testTime)
            ]));

        modifyReservationBlocController.add(CreateReservationSuccess(
          location: ReservationLocationFactory.createLocation(id: 10),
          startTime: testTime,
        ));

        await bloc.take(3).toList();

        verify(mockReservationsRepository.getReservations()).called(1);
        verify(mockReservationsRepository.saveReservations([
          ReservationFactory.createReservation(
            id: 1,
            startTime: testTime,
            location: ReservationLocationFactory.createLocation(id: 10),
          )
        ])).called(1);
        verifyNoMoreInteractions(mockReservationsRepository);
      });
    });

    group('ToggleReminderForReservation event', () {
      setUp(() {
        when(mockReservationsRepository.getReservations())
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
          b.add(ToggleReminderForReservation(reservationId: 10, context: null));
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
          b.add(ToggleReminderForReservation(reservationId: 10, context: null));
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
          b.add(ToggleReminderForReservation(reservationId: 20, context: null));
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
        bloc.add(ToggleReminderForReservation(reservationId: 20, context: null));

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
        bloc.add(ToggleReminderForReservation(reservationId: 20, context: null));

        await bloc.close();

        verify(mockNotificationHandler.cancelNotification(123)).called(1);
        verifyNoMoreInteractions(mockNotificationHandler);
      });
    });
  });
}
