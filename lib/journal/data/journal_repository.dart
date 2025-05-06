// lib/journal/data/journal_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../journal/data/journal_model.dart';

class JournalRepository {
  final CollectionReference _journalCollection =
      FirebaseFirestore.instance.collection('journals');

  Stream<List<TravelJournal>> getPublicJournals() {
    return _journalCollection.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => TravelJournal.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addJournal(TravelJournal journal) async {
    try {
      await _journalCollection.add(journal.toMap());
    } catch (e) {
      if (kDebugMode) print("Error adding journal: $e");
      rethrow;
    }
  }
}