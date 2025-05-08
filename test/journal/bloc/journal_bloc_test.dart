import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_journel/journal/bloc/journal_event.dart';
import 'package:travel_journel/journal/bloc/journal_bloc.dart';
import 'package:travel_journel/journal/bloc/journal_state.dart';
import 'package:travel_journel/journal/domain/journal_repository_interface.dart';
import 'package:travel_journel/journal/data/journal_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'journal_bloc_test.mocks.dart';

@GenerateMocks([IJournalRepository])
void main() {
  late MockIJournalRepository mockJournalRepository;
  late JournalBloc journalBloc;

  setUp(() {
    mockJournalRepository = MockIJournalRepository();
    journalBloc = JournalBloc(journalRepository: mockJournalRepository);
  });

  tearDown(() {
    journalBloc.close();
  });

  final mockJournals = <TravelJournal>[
      TravelJournal(
        id: '1',
        placeName: 'Place 1',
        notes: 'Notes 1',
        mood: 'Happy',
        visited: true,
        userId: 'user1',
        createdAt: Timestamp.now(),
        imageUrl: null,
        latitude: 12.34,
        longitude: 56.78,
        budget: 1000,
      ),
      TravelJournal(
        id: '2',
        placeName: 'Place 2',
        notes: 'Notes 2',
        mood: 'Excited',
        visited: false,
        userId: 'user2',
        createdAt: Timestamp.now(),
        imageUrl: null,
        latitude: null,
        longitude: null,
        budget: 500,
      ),
    ];


  blocTest<JournalBloc, JournalState>(
    'JournalBloc emits [JournalLoading, JournalLoaded] when LoadJournals is added and succeeds',
    build: () {
      when(mockJournalRepository.getPublicJournals())
          .thenAnswer((_) => Stream.value(mockJournals));
      return journalBloc;
    },
    act: (bloc) => bloc.add(LoadJournals()),
    expect: () => [
      JournalLoading(),
      JournalLoaded(mockJournals),
    ],
  );

  blocTest<JournalBloc, JournalState>(
    'JournalBloc emits [JournalLoading, JournalError] when LoadJournals fails',
    build: () {
      when(mockJournalRepository.getPublicJournals())
          .thenThrow(Exception('Failed to load journals'));
      return journalBloc;
    },
    act: (bloc) => bloc.add(LoadJournals()),
    expect: () => [
      JournalLoading(),
      isA<JournalError>(),
    ],
  );
}
