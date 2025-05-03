import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_form.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state.status == AuthStatus.unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login failed. Please try again.')),
            );
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: LoginForm(),
        ),
      ),
    );
  }
}
