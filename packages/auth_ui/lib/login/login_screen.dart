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
      // No AppBar, full-screen background
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/bg.jpg', // Add a travel-themed image here
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Translucent dark overlay for readability
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // BlocListener and LoginForm over the background
          BlocListener<AuthBloc, AuthState>(
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
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Center(child: LoginForm()),
            ),
          ),
        ],
      ),
    );
  }
}
