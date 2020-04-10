import 'dart:convert';

import 'package:reservation_system_customer/repository/storage.dart';

import '../unit_test_helper.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockStorage extends Mock implements Storage {}

void main() {
  final String testDeviceId = 'testDeviceId';

  ReservationsRepository reservationsRepository;
  MockUserRepository mockUserRepository;
  MockStorage mockStorage;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockStorage = MockStorage();
    reservationsRepository = ReservationsRepository(
      baseUrl: 'a base url',
      storage: mockStorage,
      userRepository: mockUserRepository,
    );

    when(mockUserRepository.deviceId())
        .thenAnswer((_) => Future.value(testDeviceId));
  });

  tearDown(() {});

  group('ReservationsRepository', () {
    group('loadReservations', () {
      test('is null when no reservations persisted', () async {
        when(mockStorage.getString(StorageKey.reservations))
            .thenAnswer((_) => Future.value(null));

        var reservations = await reservationsRepository.loadReservations();

        expect(reservations, null);
      });

      test('is null when persisted reservations could not be decoded',
          () async {
        when(mockStorage.getString(StorageKey.reservations))
            .thenAnswer((_) => Future.value('[undecodable-object]'));

        var reservations = await reservationsRepository.loadReservations();

        expect(reservations, null);
      });

      test('is empty list when persisted reservations are empty', () async {
        when(mockStorage.getString(StorageKey.reservations))
            .thenAnswer((_) => Future.value('[]'));

        var reservations = await reservationsRepository.loadReservations();

        expect(reservations, []);
      });

      test('is persisted reservation when persisted reservations are not empty',
          () async {
        when(mockStorage.getString(StorageKey.reservations)).thenAnswer((_) =>
            Future.value(
                jsonEncode([ReservationFactory.createReservation(id: 100)])));

        var reservations = await reservationsRepository.loadReservations();

        expect(reservations, [ReservationFactory.createReservation(id: 100)]);
      });
    });
  });
}
