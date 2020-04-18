import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reservation_system_customer/bloc/map_marker_loader.dart';

import '../unit_test_helper.dart';

class MockLocationsRepository extends Mock implements LocationsRepository {}

class MockMapMarkerLoader extends Mock implements MapMarkerLoader {}

void main() {
  final FilterSettings defaultFilterSettings = FilterSettings(
    locationType: LocationType.supermarket,
    minFillStatus: FillStatus.red,
  );
  final LatLng testPosition = LatLng(50, 10);
  final int testRadius = 1000;

  MapBloc bloc;
  MockLocationsRepository mockLocationsRepository;
  MockMapMarkerLoader mockMapMarkerLoader;

  setUp(() {
    mockLocationsRepository = MockLocationsRepository();
    when(mockLocationsRepository.loadMapFilterSettings())
        .thenAnswer((_) => Future.value(null));
    mockMapMarkerLoader = MockMapMarkerLoader();

    bloc = MapBloc(
      locationsRepository: mockLocationsRepository,
      markerLoader: mockMapMarkerLoader,
    );
  });

  tearDown(() {
    bloc?.close();
  });

  group('MapBloc', () {
    group('Init', () {
      test('initial state is [MapInitial]', () {
        expect(bloc.state, MapInitial(filterSettings: defaultFilterSettings));
      });

      test('loads persisted settings', () async {
        clearInteractions(mockLocationsRepository);
        when(mockLocationsRepository.loadMapFilterSettings())
            .thenAnswer((_) => Future.value(FilterSettings(
                  locationType: LocationType.pharmacy,
                  minFillStatus: FillStatus.yellow,
                )));
        bloc = MapBloc(
          locationsRepository: mockLocationsRepository,
          markerLoader: mockMapMarkerLoader,
        );
        await bloc.take(2).toList();

        verify(mockLocationsRepository.loadMapFilterSettings()).called(1);
        verifyNoMoreInteractions(mockLocationsRepository);

        expect(
            bloc.state,
            MapInitial(
              filterSettings: FilterSettings(
                locationType: LocationType.pharmacy,
                minFillStatus: FillStatus.yellow,
              ),
            ));
      });

      blocTest(
        'emits loaded settings',
        build: () async {
          when(mockLocationsRepository.loadMapFilterSettings())
              .thenAnswer((_) => Future.value(FilterSettings(
                    locationType: LocationType.pharmacy,
                    minFillStatus: FillStatus.yellow,
                  )));
          return MapBloc(
            locationsRepository: mockLocationsRepository,
            markerLoader: mockMapMarkerLoader,
          );
        },
        act: (b) async {
          await b.take(2).toList();
          return;
        },
        expect: [
          MapInitial(
              filterSettings: FilterSettings(
            locationType: LocationType.pharmacy,
            minFillStatus: FillStatus.yellow,
          )),
        ],
      );
    });

    group('MapLoadLocations event', () {
      blocTest(
        'emits [MapLoading] and [MapLocationsLoaded]',
        build: () async {
          when(mockLocationsRepository.getStores(
            position: testPosition,
            radius: testRadius,
            type: LocationType.supermarket,
          )).thenAnswer((_) => Future.value([
                LocationFactory.createLocation(
                    id: 10, locationType: LocationType.supermarket)
              ]));
          return bloc;
        },
        act: (b) => b.add(MapLoadLocations(
          position: testPosition,
          radius: testRadius,
        )),
        expect: [
          MapLoading(
            locations: [],
            filterSettings: defaultFilterSettings,
            markerIcons: {},
          ),
          MapLocationsLoaded(
            locations: [
              LocationFactory.createLocation(
                  id: 10, locationType: LocationType.supermarket)
            ],
            filterSettings: defaultFilterSettings,
            markerIcons: {},
          ),
        ],
      );

      blocTest(
        'caches unique locations',
        build: () async {
          var requestCount = -1;
          when(mockLocationsRepository.getStores(
            position: testPosition,
            radius: testRadius,
            type: LocationType.supermarket,
          )).thenAnswer((_) {
            requestCount++;
            if (requestCount == 0) {
              return Future.value([
                LocationFactory.createLocation(id: 1),
                LocationFactory.createLocation(id: 2),
                LocationFactory.createLocation(id: 3),
                LocationFactory.createLocation(id: 4),
                LocationFactory.createLocation(id: 5),
              ]);
            } else if (requestCount == 1) {
              return Future.value([
                LocationFactory.createLocation(id: 7),
                LocationFactory.createLocation(id: 4),
                LocationFactory.createLocation(id: 6),
                LocationFactory.createLocation(id: 5),
                LocationFactory.createLocation(id: 3),
              ]);
            }
            return Future.value([
              LocationFactory.createLocation(id: 10),
              LocationFactory.createLocation(id: 6),
              LocationFactory.createLocation(id: 20),
              LocationFactory.createLocation(id: 30),
              LocationFactory.createLocation(id: 0),
              LocationFactory.createLocation(id: 3),
            ]);
          });
          return bloc;
        },
        act: (b) async {
          b.add(MapLoadLocations(
            position: testPosition,
            radius: testRadius,
          ));
          await bloc.take(2).toList();
          b.add(MapLoadLocations(
            position: testPosition,
            radius: testRadius,
          ));
          await bloc.take(2).toList();
          b.add(MapLoadLocations(
            position: testPosition,
            radius: testRadius,
          ));
        },
        expect: [
          MapLoading(
            locations: [],
            filterSettings: defaultFilterSettings,
            markerIcons: {},
          ),
          MapLocationsLoaded(
            locations: [1, 2, 3, 4, 5]
                .map((id) => LocationFactory.createLocation(id: id))
                .toList(),
            filterSettings: defaultFilterSettings,
            markerIcons: {},
          ),
          MapLoading(
            locations: [1, 2, 3, 4, 5]
                .map((id) => LocationFactory.createLocation(id: id))
                .toList(),
            filterSettings: defaultFilterSettings,
            markerIcons: {},
          ),
          MapLocationsLoaded(
            locations: [1, 2, 7, 4, 6, 5, 3]
                .map((id) => LocationFactory.createLocation(id: id))
                .toList(),
            filterSettings: defaultFilterSettings,
            markerIcons: {},
          ),
          MapLoading(
            locations: [1, 2, 7, 4, 6, 5, 3]
                .map((id) => LocationFactory.createLocation(id: id))
                .toList(),
            filterSettings: defaultFilterSettings,
            markerIcons: {},
          ),
          MapLocationsLoaded(
            locations: [1, 2, 7, 4, 5, 10, 6, 20, 30, 0, 3]
                .map((id) => LocationFactory.createLocation(id: id))
                .toList(),
            filterSettings: defaultFilterSettings,
            markerIcons: {},
          ),
        ],
      );

      test('calls reservation repository', () async {
        bloc.add(MapLoadLocations(
          position: testPosition,
          radius: testRadius,
        ));

        await bloc.close();

        verify(mockLocationsRepository.loadMapFilterSettings()).called(1);
        verify(mockLocationsRepository.getStores(
          position: testPosition,
          radius: testRadius,
          type: LocationType.supermarket,
        )).called(1);
        verifyNoMoreInteractions(mockLocationsRepository);
      });
    });

    group('MapSettingsChanged event', () {
      final newFilterSettings = FilterSettings(
        locationType: LocationType.pharmacy,
        minFillStatus: FillStatus.yellow,
      );

      blocTest(
        'with state [MapInitial] emits new filter settings',
        build: () async {
          return bloc;
        },
        act: (b) => b.add(MapSettingsChanged(newFilterSettings)),
        expect: [
          MapInitial(filterSettings: newFilterSettings),
        ],
      );

      blocTest(
        'with state [MapLocationsLoaded] emits new filter settings and filtered locations',
        build: () async {
          var isFirstRequest = true;
          when(mockLocationsRepository.getStores(
            position: testPosition,
            radius: testRadius,
            type: anyNamed('type'),
          )).thenAnswer((_) {
            if (isFirstRequest) {
              isFirstRequest = false;
              return Future.value([
                LocationFactory.createLocation(
                    id: 10, locationType: LocationType.supermarket),
                LocationFactory.createLocation(
                    id: 12, locationType: LocationType.pharmacy),
              ]);
            }
            return Future.value([
              LocationFactory.createLocation(
                  id: 12, locationType: LocationType.pharmacy),
              LocationFactory.createLocation(
                  id: 14, locationType: LocationType.pharmacy),
            ]);
          });
          return bloc;
        },
        act: (b) async {
          b.add(MapLoadLocations(position: testPosition, radius: testRadius));
          await b.take(3).toList();

          b.add(MapSettingsChanged(newFilterSettings));
          await b.take(2).toList();
        },
        expect: [
          MapLoading(
              locations: [],
              markerIcons: {},
              filterSettings: defaultFilterSettings),
          MapLocationsLoaded(
            locations: [
              LocationFactory.createLocation(
                  id: 10, locationType: LocationType.supermarket)
            ],
            filterSettings: defaultFilterSettings,
            markerIcons: {},
          ),
          MapLoading(
            locations: [
              LocationFactory.createLocation(
                  id: 12, locationType: LocationType.pharmacy)
            ],
            filterSettings: newFilterSettings,
            markerIcons: {},
          ),
          MapLocationsLoaded(
            locations: [
              LocationFactory.createLocation(
                  id: 12, locationType: LocationType.pharmacy),
              LocationFactory.createLocation(
                  id: 14, locationType: LocationType.pharmacy)
            ],
            filterSettings: newFilterSettings,
            markerIcons: {},
          ),
        ],
      );

      test('[FilterSettings] are saved', () async {
        bloc.add(MapSettingsChanged(newFilterSettings));

        await bloc.take(2).toList();

        verify(mockLocationsRepository.saveMapFilterSettings(newFilterSettings))
            .called(1);
        verify(mockLocationsRepository.loadMapFilterSettings()).called(1);
        verifyNoMoreInteractions(mockLocationsRepository);
      });
    });
  });
}
