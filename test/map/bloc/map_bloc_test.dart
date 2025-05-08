import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_journel/map/bloc/map_bloc.dart';
import 'package:travel_journel/map/bloc/map_event.dart';
import 'package:travel_journel/map/bloc/map_state.dart';
import 'package:travel_journel/map/data/map_service.dart';
import 'package:travel_journel/journal/data/journal_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'map_bloc_test.mocks.dart';
import 'dart:async';

@GenerateMocks([MapService])
void main() {
  late MockMapService mockMapService;
  late MapBloc mapBloc;

  setUp(() {
    mockMapService = MockMapService();
    mapBloc = MapBloc(mapService: mockMapService);
  });

  tearDown(() => mapBloc.close());

  group('MapBloc', () {
    const userId = 'test_user';

    final testJournals = [
      TravelJournal(
        id: '1',
        placeName: 'Lahore',
        notes: 'Beautiful city',
        mood: 'Happy',
        visited: true,
        userId: userId,
        createdAt: Timestamp.now(),
        latitude: 31.5204,
        longitude: 74.3587,
        imageUrl: null,
        budget: 1000,
      ),
    ];

    blocTest<MapBloc, MapState>(
      'emits [MapLoading, MapReady] when LoadMapMarkers is added and succeeds',
      build: () {
        when(mockMapService.getVisitedJournalsWithLocation(userId))
            .thenAnswer((_) => Stream.value(testJournals));
        return mapBloc;
      },
      act: (bloc) => bloc.add(const LoadMapMarkers(userId: userId)),
      expect: () => [
        MapLoading(),
        MapReady(testJournals),
      ],
      verify: (_) {
        verify(mockMapService.getVisitedJournalsWithLocation(userId)).called(1);
      },
    );

    blocTest<MapBloc, MapState>(
      'emits [MapLoading, MapError] when LoadMapMarkers fails',
      build: () {
        when(mockMapService.getVisitedJournalsWithLocation(userId))
            .thenThrow(Exception('Failed to fetch'));
        return mapBloc;
      },
      act: (bloc) => bloc.add(const LoadMapMarkers(userId: userId)),
      expect: () => [
        MapLoading(),
        isA<MapError>(),
      ],
    );
  });
}
