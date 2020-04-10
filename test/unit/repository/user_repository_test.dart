import 'package:reservation_system_customer/repository/storage.dart';

import '../unit_test_helper.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  UserRepository userRepository;
  MockStorage mockStorage;

  setUp(() {
    mockStorage = MockStorage();
    userRepository = UserRepository(
      storage: mockStorage,
    );
  });

  tearDown(() {});

  group('UserRepository', () {
    group('shouldShowTutorial', () {
      test('is true when no data persisted', () async {
        when(mockStorage.getBool(StorageKey.userFinishedTutorial))
            .thenAnswer((_) => Future.value(null));

        var showTutorial = await userRepository.shouldShowTutorial();

        expect(showTutorial, true);
        verify(mockStorage.getBool(StorageKey.userFinishedTutorial)).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test('is true when false persisted', () async {
        when(mockStorage.getBool(StorageKey.userFinishedTutorial))
            .thenAnswer((_) => Future.value(false));

        var showTutorial = await userRepository.shouldShowTutorial();

        expect(showTutorial, true);
        verify(mockStorage.getBool(StorageKey.userFinishedTutorial)).called(1);
        verifyNoMoreInteractions(mockStorage);
      });

      test('is false when true persisted', () async {
        when(mockStorage.getBool(StorageKey.userFinishedTutorial))
            .thenAnswer((_) => Future.value(true));

        var showTutorial = await userRepository.shouldShowTutorial();

        expect(showTutorial, false);
        verify(mockStorage.getBool(StorageKey.userFinishedTutorial)).called(1);
        verifyNoMoreInteractions(mockStorage);
      });
    });

    group('saveUserFinishedTutorial', () {
      test('is true when no data persisted', () async {
        await userRepository.saveUserFinishedTutorial();

        verify(mockStorage.setBool(StorageKey.userFinishedTutorial, true))
            .called(1);
        verifyNoMoreInteractions(mockStorage);
      });
    });
  });
}
