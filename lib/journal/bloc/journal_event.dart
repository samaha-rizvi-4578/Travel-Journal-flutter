// lib/journal/bloc/journal_event.dart
import 'package:equatable/equatable.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();
}

class LoadJournals extends JournalEvent {
  @override
  List<Object?> get props => [];
}