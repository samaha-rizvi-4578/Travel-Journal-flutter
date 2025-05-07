import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/journal_event.dart';
import '../../bloc/journal_bloc.dart';
import '../../bloc/journal_state.dart';
import '../../data/journal_repository.dart';

class JournalFeedPage extends StatelessWidget {
  const JournalFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JournalBloc(
        journalRepository: context.read<JournalRepository>(),
      )..add(LoadJournals()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Travel Journals'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.push('/add-journal'),
            ),
          ],
        ),
        body: BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            if (state is JournalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is JournalLoaded) {
              if (state.journals.isEmpty) {
                return const Center(child: Text('No journals found.'));
              }
              return ListView.builder(
                itemCount: state.journals.length,
                itemBuilder: (context, index) {
                  final journal = state.journals[index];
                  return ListTile(
                    onTap: () => context.push('/journal/${journal.id}'),
                    
                    title: Text(journal.placeName),
            
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Id: ${journal.id}"),
                          Text("Mood: ${journal.mood}"),
                          Text("Visited: ${journal.visited ? 'Yes' : 'No'}"),
                          Text("Notes: ${journal.notes}"),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    isThreeLine: true,
                  );
                },
              );
            } else if (state is JournalError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            // Covers JournalInitial or any unknown state
            return const Center(child: Text('Fetching journals...'));
          },
        ),
      ),
    );
  }
}