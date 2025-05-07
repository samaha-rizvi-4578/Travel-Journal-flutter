import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_repo/auth_repo.dart';
import 'package:auth_ui/auth_ui.dart';
import '../../../journal/data/journal_repository.dart';
import '../../../journal/bloc/journal_bloc.dart'; // Import JournalBloc
import '../../../journal/bloc/journal_event.dart'; // Import JournalEvents
import './routes/app_router.dart';

class App extends StatelessWidget {
  final AuthRepository authRepo;

  const App({super.key, required this.authRepo});

  @override
  Widget build(BuildContext context) {
    final journalRepo = JournalRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepo),
        RepositoryProvider<JournalRepository>.value(value: journalRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepo: authRepo)
              ..add(AuthUserChanged(authRepo.currentUser)),
          ),
          BlocProvider<JournalBloc>(
            create: (context) => JournalBloc(journalRepository: journalRepo)
              ..add(LoadJournals()), // Load journals on app start
          ),
        ],
        child: MaterialApp.router(
          routerConfig: AppRouter(authRepo).router,
          title: 'Travel Journal',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
        ),
      ),
    );
  }
}