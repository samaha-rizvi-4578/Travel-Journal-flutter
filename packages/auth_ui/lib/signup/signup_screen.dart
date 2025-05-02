import 'package:auth_ui/auth_ui.dart';
import 'package:flutter/material.dart';
import 'signup_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_repo/auth_repo.dart';
import '../bloc/auth_bloc.dart'; // adjust path if needed
import '../bloc/auth_event.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Auth Failed')),
            );
          }
        },
        child: const SignupForm(),
      ),
    );
  }
}

