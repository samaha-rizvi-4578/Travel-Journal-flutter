// lib/journal/bloc/journal_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../journal/data/journal_model.dart';
import '../../journal/data/journal_repository.dart';
import '../../journal/bloc/journal_event.dart';
import '../../journal/bloc/journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalRepository journalRepository;

  JournalBloc({required this.journalRepository}) : super(JournalInitial()) {
    on<LoadJournals>((event, emit) async {
      emit(JournalLoading());
      try {
        final journals = await journalRepository.getPublicJournals().first;
        emit(JournalLoaded(journals));
      } catch (e) {
        emit(JournalError(e.toString()));
      }
    });
  }
}