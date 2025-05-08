import 'package:travel_journel/journal/data/journal_model.dart';

abstract class IJournalRepository {
  Stream<List<TravelJournal>> getPublicJournals();
  Future<void> addJournal(TravelJournal journal);
  Future<void> updateJournal(TravelJournal journal);
}
