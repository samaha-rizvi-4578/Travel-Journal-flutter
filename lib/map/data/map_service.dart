import '../../journal/data/journal_model.dart';
import '../../journal/data/journal_repository.dart';

class MapService {
  final JournalRepository _journalRepo;

  MapService(this._journalRepo);

  Stream<List<TravelJournal>> getVisitedJournalsWithLocation(String userId) {
    return _journalRepo.getPublicJournals().map((journals) =>
        journals.where((j) => j.visited && j.latitude != null && j.longitude != null).toList());
  }
}