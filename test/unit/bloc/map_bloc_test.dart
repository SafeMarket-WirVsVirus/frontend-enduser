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
    when(mockMapMarkerLoader.loadMarkerIcons())
        .thenAnswer((_) => Future.value({}));

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
          when(mockLocationsRepository.getStores(
            position: testPosition,
            radius: testRadius,
            type: LocationType.supermarket,
          )).thenAnswer((_) => Future.value([
                LocationFactory.createLocation(
                    id: 10, locationType: LocationType.supermarket),
                LocationFactory.createLocation(
                    id: 12, locationType: LocationType.pharmacy)
              ]));
          return bloc;
        },
        act: (b) async {
          b.add(MapLoadLocations(position: testPosition, radius: testRadius));
          await b.take(2).toList();

          b.add(MapSettingsChanged(newFilterSettings));
          return;
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
          MapLocationsLoaded(
            locations: [
              LocationFactory.createLocation(
                  id: 12, locationType: LocationType.pharmacy)
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
