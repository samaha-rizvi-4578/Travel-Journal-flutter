import 'package:auth_ui/auth_ui.dart';
import 'package:flutter/material.dart';
import 'signup_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/bg.jpg', // Same travel-themed background
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          // Dark overlay for contrast
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // BlocListener with centered form
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                Navigator.pushReplacementNamed(context, '/home');
              } else if (state.status == AuthStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage ?? 'Auth Failed')),
                );
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Center(child: SignupForm()),
            ),
          ),
        ],
      ),
    );
  }
}
