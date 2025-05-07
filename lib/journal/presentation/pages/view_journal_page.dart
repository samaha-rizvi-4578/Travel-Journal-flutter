// lib/journal/presentation/pages/view_journal_page.dart
import 'package:flutter/material.dart';
import '../../../journal/data/journal_model.dart';
import 'package:go_router/go_router.dart';

class ViewJournalPage extends StatelessWidget {
  final TravelJournal journal;

  const ViewJournalPage({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.pushNamed('edit_journal', params: {'id': journal.id});
            },
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
          ],
        ),
      ),
    );
  }
}
