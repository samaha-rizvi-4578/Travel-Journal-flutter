import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:auth_repo/auth_repo.dart';
import 'package:auth_ui/auth_ui.dart';

// import 'package:travel_journal/auth/bloc/auth_bloc.dart';
// import 'package:travel_journal/auth/presentation/pages/login_page.dart';

import './../map/presentation/map_view.dart';
import './../journal/presentation/pages/add_journal_page.dart';
import './../journal/presentation/pages/journal_feed_page.dart';

class AppRouter {
  final AuthRepository authRepo;

  AppRouter(this.authRepo);

  late final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authRepo.userStream),
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
        redirect: (context, state) {
          final user = authRepo.currentUser;
          if (user != null) return '/feed';
          return null;
        },
      ),
      GoRoute(
        path: '/feed',
        name: 'feed',
        builder: (context, state) => const JournalFeedPage(),
      ),
      // GoRoute(
      //   path: '/add-journal',
      //   name: 'add_journal',
      //   builder: (context, state) => const AddJournalPage(),
      // ),
      // GoRoute(
      //   path: '/map',
      //   name: 'map',
      //   builder: (context, state) => const MapView(),
      // ),
    ],
  );
}
