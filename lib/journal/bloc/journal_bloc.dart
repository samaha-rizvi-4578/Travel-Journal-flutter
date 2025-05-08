import 'package:flutter_bloc/flutter_bloc.dart';
import '../../journal/data/journal_repository.dart';
import '../../journal/bloc/journal_event.dart';
import '../../journal/bloc/journal_state.dart';
import '../domain/journal_repository_interface.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final IJournalRepository journalRepository;

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