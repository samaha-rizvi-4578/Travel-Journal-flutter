import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_repo/auth_repo.dart';
import 'package:auth_ui/auth_ui.dart';
import '../../../journal/data/journal_repository.dart';
import '../../../journal/bloc/journal_bloc.dart';
import '../../../journal/bloc/journal_event.dart';
import './routes/app_router.dart';

class App extends StatefulWidget {
  final AuthRepository authRepo;

  const App({super.key, required this.authRepo});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final JournalRepository journalRepo;
  late final AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    journalRepo = JournalRepository();
    authBloc = AuthBloc(authRepo: widget.authRepo);

    // Initialize auth after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAuth();
    });
  }

  Future<void> _initializeAuth() async {
    try {
      final user = await widget.authRepo.currentUser;
      if (mounted) {
        authBloc.add(AuthUserChanged(user));
      }
    } catch (e) {
      // Handle or log initialization errors
      debugPrint("Auth initialization failed: $e");
    }
  }

  @override
  void dispose() {
    authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: widget.authRepo),
        RepositoryProvider<JournalRepository>.value(value: journalRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<JournalBloc>(
            create: (context) => JournalBloc(journalRepository: journalRepo)
              ..add(LoadJournals()),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: AppRouter(widget.authRepo).router,
          title: 'WanderLog',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true).copyWith(
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.teal[700],
              titleTextStyle: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: true,
              toolbarHeight: 60,
              titleSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}