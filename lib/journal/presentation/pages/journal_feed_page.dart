import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

import '../../bloc/journal_event.dart';
import '../../bloc/journal_bloc.dart';
import '../../bloc/journal_state.dart';
import '../../data/journal_repository.dart';
import '../widgets/search_and_filter_widget.dart'; // Import the widget

class JournalFeedPage extends StatefulWidget {
  const JournalFeedPage({super.key});

  @override
  State<JournalFeedPage> createState() => _JournalFeedPageState();
}

class _JournalFeedPageState extends State<JournalFeedPage> {
  String searchQuery = '';
  String filterOption = 'None';

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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchAndFilterWidget(
                      onSearch: (query) {
                        setState(() {
                          searchQuery = query;
                        });
                      },
                      onFilter: (filter) {
                        setState(() {
                          filterOption = filter;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<JournalBloc, JournalState>(
                      builder: (context, state) {
                        if (state is JournalLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is JournalLoaded) {
                          var journals = state.journals;

                          // Apply Search
                          if (searchQuery.isNotEmpty) {
                            journals = journals
                                .where((journal) =>
                                    journal.placeName
                                        .toLowerCase()
                                        .contains(searchQuery.toLowerCase()) ||
                                    journal.userEmail
                                        .toLowerCase()
                                        .contains(searchQuery.toLowerCase()))
                                .toList();
                          }

                          // Apply Filter
                          if (filterOption == 'Budget') {
                            journals = journals
                                .where((journal) => journal.budget != null)
                                .toList();
                            journals.sort((a, b) => (a.budget ?? 0).compareTo(b.budget ?? 0));
                          } else if (filterOption == 'Visited') {
                            journals = journals.where((journal) => journal.visited).toList();
                          } else if (filterOption == 'Wishlist') {
                            journals = journals.where((journal) => !journal.visited).toList();
                          } else if (filterOption == 'Alphabetical') {
                            journals.sort((a, b) => a.placeName.compareTo(b.placeName));
                          }

                          if (journals.isEmpty) {
                            return const Center(child: Text('No journals found.'));
                          }

                          return ListView.builder(
                            itemCount: journals.length,
                            itemBuilder: (context, index) {
                              final journal = journals[index];
                              return ListTile(
                                onTap: () => context.push('/journal/${journal.id}'),
                                title: Text(journal.placeName),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Created By: ${journal.userEmail}"),
                                      Text("Budget: ${journal.budget ?? 'N/A'}"),
                                      Text("Visited: ${journal.visited ? 'Yes' : 'No'}"),
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

              // My Journals Tab
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchAndFilterWidget(
                      onSearch: (query) {
                        setState(() {
                          searchQuery = query;
                        });
                      },
                      onFilter: (filter) {
                        setState(() {
                          filterOption = filter;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<JournalBloc, JournalState>(
                      builder: (context, state) {
                        if (state is JournalLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is JournalLoaded) {
                          var myJournals = state.journals
                              .where((journal) => journal.userEmail == userEmail) // Use logged-in user's email
                              .toList();

                          // Apply Search
                          if (searchQuery.isNotEmpty) {
                            myJournals = myJournals
                                .where((journal) =>
                                    journal.placeName
                                        .toLowerCase()
                                        .contains(searchQuery.toLowerCase()))
                                .toList();
                          }

                          // Apply Filter
                          if (filterOption == 'Budget') {
                            myJournals = myJournals
                                .where((journal) => journal.budget != null)
                                .toList();
                            myJournals.sort((a, b) => (a.budget ?? 0).compareTo(b.budget ?? 0));
                          } else if (filterOption == 'Visited') {
                            myJournals = myJournals.where((journal) => journal.visited).toList();
                          } else if (filterOption == 'Wishlist') {
                            myJournals = myJournals.where((journal) => !journal.visited).toList();
                          } else if (filterOption == 'Alphabetical') {
                            myJournals.sort((a, b) => a.placeName.compareTo(b.placeName));
                          }

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
                                      Text("Budget: ${journal.budget ?? 'N/A'}"),
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
            ],
          ),
        ),
      ),
    );
  }
}