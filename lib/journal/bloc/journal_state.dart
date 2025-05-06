// lib/journal/bloc/journal_state.dart
import 'package:equatable/equatable.dart';
import '../../journal/data/journal_model.dart';

abstract class JournalState extends Equatable {
  const JournalState();
}

class JournalInitial extends JournalState {
  @override
  List<Object?> get props => [];
}

class JournalLoading extends JournalState {
  @override
  List<Object?> get props => [];
}

class JournalLoaded extends JournalState {
  final List<TravelJournal> journals;

  const JournalLoaded(this.journals);

  @override
  List<Object?> get props => [journals];
}

class JournalError extends JournalState {
  final String message;

  const JournalError(this.message);

  @override
  List<Object?> get props => [message];
}