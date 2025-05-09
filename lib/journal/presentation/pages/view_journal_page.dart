import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../journal/data/journal_model.dart';
import '../../../journal/data/journal_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../journal/bloc/journal_bloc.dart';
class ViewJournalPage extends StatelessWidget {
  final TravelJournal journal;

  const ViewJournalPage({super.key, required this.journal});

  Future<void> _deleteJournal(BuildContext context) async {
    final journalRepository = context.read<JournalRepository>();
    final journalBloc = context.read<JournalBloc>();

    try {
      await journalRepository.deleteJournal(journal.id);
      journalBloc.reloadJournals(); // Reload the journals
      Navigator.pop(context); // Go back to the previous page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Journal deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting journal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmationBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Are you sure you want to delete this journal?'),
        action: SnackBarAction(
          label: 'Delete',
          textColor: Colors.red,
          onPressed: () {
            _deleteJournal(context); // Delete the journal
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? activeUserEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Details'),
        actions: [
          if (journal.userEmail == activeUserEmail)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.pushNamed('edit_journal', params: {'id': journal.id});
              },
            ),
          if (journal.userEmail == activeUserEmail)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmationBar(context),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (journal.imageUrl != null && journal.imageUrl!.isNotEmpty)
              Hero(
                tag: 'journal-image-${journal.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    journal.imageUrl!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (journal.imageUrl != null && journal.imageUrl!.isNotEmpty)
              const SizedBox(height: 16),
            Text(
              journal.placeName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.mood, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  'Mood: ${journal.mood}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Notes:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(journal.notes, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Chip(
              label: Text(journal.visited ? "Visited" : "Wishlist"),
              backgroundColor:
                  journal.visited ? Colors.green[200] : Colors.orange[200],
            ),
            const SizedBox(height: 16),
            const Text(
              'Created By:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              journal.userEmail,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}