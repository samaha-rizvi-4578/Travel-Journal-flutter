import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_repo/auth_repo.dart';
import '../../../journal/data/journal_repository.dart';
import 'package:auth_ui/auth_ui.dart';
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
      child: BlocProvider(
        create: (context) => AuthBloc(authRepo: authRepo)
          ..add(AuthUserChanged(authRepo.currentUser)),
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