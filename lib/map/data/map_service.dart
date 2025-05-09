import '../../journal/data/journal_model.dart';
import '../../journal/data/journal_repository.dart';

class MapService {
  final JournalRepository _journalRepo;

  MapService(this._journalRepo);

  // Fetch journals marked as visited by the active user
  Stream<List<TravelJournal>> getVisitedJournalsWithLocation(String userEmail) {
    return _journalRepo.getPublicJournals().map((journals) =>
        journals
            .where((j) =>
                j.visited &&
                j.userEmail == userEmail && // Filter by active user's email
                j.latitude != null &&
                j.longitude != null)
            .toList());
  }
}