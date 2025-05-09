import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

import '../../bloc/journal_event.dart';
import '../../bloc/journal_bloc.dart';
import '../../bloc/journal_state.dart';
import '../../data/journal_repository.dart';

class JournalFeedPage extends StatelessWidget {
  const JournalFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the logged-in user's email
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return DefaultTabController(
      length: 2, // Two tabs: FEED and My Journals
      child: BlocProvider(
        create: (context) => JournalBloc(
          journalRepository: context.read<JournalRepository>(),
        )..add(LoadJournals()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Travel Journals'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'FEED'),
                Tab(text: 'My Journals'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // FEED Tab
              BlocBuilder<JournalBloc, JournalState>(
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
                                Text("Created By: ${journal.userEmail}"),
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
                  return const Center(child: Text('Fetching journals...'));
                },
              ),

              // My Journals Tab
              Scaffold(
                appBar: AppBar(
                  title: const Text('My Journals'),
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
                      final myJournals = state.journals
                          .where((journal) => journal.userEmail == userEmail) // Use logged-in user's email
                          .toList();
                      if (myJournals.isEmpty) {
                        return const Center(child: Text('No journals found.'));
                      }
                      return ListView.builder(
                        itemCount: myJournals.length,
                        itemBuilder: (context, index) {
                          final journal = myJournals[index];
                          return ListTile(
                            onTap: () => context.push('/journal/${journal.id}'),
                            title: Text(journal.placeName),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                    return const Center(child: Text('Fetching journals...'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}