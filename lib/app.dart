import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_repo/auth_repo.dart';
import 'package:auth_repo/auth_repo.dart';
import 'package:auth_ui/auth_ui.dart';

class App extends StatelessWidget {
  final AuthRepository authRepo;
  const App({super.key, required this.authRepo});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
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
