import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../journal/data/journal_model.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../domain/journal_repository_interface.dart';

class JournalRepository implements IJournalRepository{
  final CollectionReference _journalCollection = FirebaseFirestore.instance
      .collection('journals');

  Stream<List<TravelJournal>> getPublicJournals() {
    return _journalCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => TravelJournal.fromMap(
                      doc.id,
                      doc.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList(),
        );
  }

  // Future<void> addJournal(TravelJournal journal) async {
  //   try {
  //     await _journalCollection.add(journal.toMap());
  //   } catch (e) {
  //     if (kDebugMode) print("Error adding journal: $e");
  //     rethrow;
  //   }
  // }

Future<void> addJournal(TravelJournal journal, {File? imageFile}) async {
  try {
    String? imageUrl;

    // Step 1: Upload the image to Firebase Storage (if provided)
    if (imageFile != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('journal_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the image file
      final uploadTask = await imageRef.putFile(imageFile);

      // Get the download URL
      imageUrl = await imageRef.getDownloadURL();
    }

    // Step 2: Add the image URL to the journal data
    final journalData = journal.toMap();
    if (imageUrl != null) {
      journalData['imageUrl'] = imageUrl;
    }

    // Step 3: Save the journal data to Firestore
    await _journalCollection.add(journalData);
  } catch (e) {
    if (kDebugMode) print("Error adding journal: $e");
    rethrow;
  }
}

  Future<void> updateJournal(TravelJournal journal) async {
    try {
      await _journalCollection.doc(journal.id).update(journal.toMap());
    } catch (e) {
      if (kDebugMode) print("Error updating journal: $e");
      rethrow;
    }
  }
}
