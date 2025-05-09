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
        title: const Text(
          'Journal Details',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.teal,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the journal image if available
              if (journal.imageUrl != null && journal.imageUrl!.isNotEmpty)
                Hero(
                  tag: 'journal-image-${journal.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      journal.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (journal.imageUrl != null && journal.imageUrl!.isNotEmpty)
                const SizedBox(height: 16),

              // Display the place name
              Text(
                journal.placeName,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),

              // Display the mood
              Row(
                children: [
                  const Icon(Icons.mood, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Mood: ${journal.mood}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Display the notes
              const Text(
                'Notes:',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                journal.notes,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),

              // Display the visited/wishlist chip
              Chip(
                label: Text(
                  journal.visited ? "Visited" : "Wishlist",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor:
                    journal.visited ? Colors.green : Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              const SizedBox(height: 16),

              // Display the user email
              const Text(
                'Created By:',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                journal.userEmail,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),

              // Display the budget if available
              if (journal.budget != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Budget:',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${journal.budget}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}