import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import './../main.dart';

// Auth
import 'package:auth_repo/auth_repo.dart';
import 'package:auth_ui/auth_ui.dart';

// Screens
import './../home/presentation/pages/home_page.dart';
import './../map/presentation/map_view.dart';
import './../journal/presentation/pages/add_journal_page.dart';
import './../journal/presentation/pages/edit_journal_page.dart';
import './../journal/presentation/pages/journal_feed_page.dart';
import './../journal/presentation/pages/view_journal_page.dart';

// Blocs
import './../journal/bloc/journal_bloc.dart';
import './../../journal/bloc/journal_state.dart';

// Models
import './../journal/data/journal_model.dart';

class AppRouter {
  final AuthRepository authRepo;

  AppRouter(this.authRepo);

  late final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authRepo.user),
    initialLocation: '/',
    routes: <GoRoute>[
      // Login Route
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
        redirect: (context, state) {
          final authRepo = globalAuthRepo;
          final user = authRepo.currentUser;
          if (user != null) return '/home'; // Redirect to Home Page after login
          return null;
        },
      ),

      // Home Route
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Feed Route (Journals)
      GoRoute(
        path: '/feed',
        name: 'feed',
        builder: (context, state) => const JournalFeedPage(),
      ),

      // View Journal Route
      GoRoute(
        path: '/journal/:id',
        name: 'view_journal',
        builder: (context, state) {
          final String? journalId = state.params['id'];
          final journalBloc = context.read<JournalBloc>();
          TravelJournal journal;

          if (journalBloc.state is JournalLoaded) {
            final journals = (journalBloc.state as JournalLoaded).journals;
            journal = journals.firstWhere(
              (j) => j.id == journalId,
              orElse: () => TravelJournal(
                id: '',
                placeName: 'Unknown',
                notes: '',
                mood: '',
                visited: false,
                userId: '',
                createdAt: Timestamp(0, 0),
              ),
            );
          } else {
            journal = TravelJournal(
              id: '',
              placeName: 'Unknown',
              notes: '',
              mood: '',
              visited: false,
              userId: '',
              createdAt: Timestamp(0, 0),
            );
          }

          return ViewJournalPage(journal: journal);
        },
      ),

      // Edit Journal Route
      GoRoute(
        path: '/journal/:id/edit',
        name: 'edit_journal',
        builder: (context, state) {
          final journal = state.extra as TravelJournal;

          if (journal.id.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Invalid journal data')),
            );
          }

          return EditJournalPage(journal: journal);
        },
      ),

      // Add Journal Route
      GoRoute(
        path: '/add-journal',
        name: 'add_journal',
        builder: (context, state) => const AddJournalPage(),
      ),

      // Map Route
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) => const MapView(),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}